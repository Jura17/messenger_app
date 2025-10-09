import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:messenger_app/features/auth/data/provider/firebase_auth_api.dart';
import 'package:messenger_app/features/users/data/models/user_data.dart';
import 'package:messenger_app/features/users/data/provider/userdata_api.dart';
import 'package:rxdart/rxdart.dart';

class FirestoreUserdataApi implements UserdataApi {
  final FirebaseFirestore firestoreDb;
  final FirebaseAuthApi authApi;

  FirestoreUserdataApi(this.firestoreDb, this.authApi);

  @override
  Future<void> createUser(String uid, String email) async {
    final newUser = Userdata(uid: uid, email: email);
    await firestoreDb.collection('users').doc(uid).set(newUser.toMap());
  }

  Stream<List<Map<String, dynamic>>> getAllUsers() {
    return firestoreDb
        .collection('users')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  @override
  Stream<List<String>> getBlockedUserIds() {
    final currentUser = authApi.getCurrentUser();
    return firestoreDb
        .collection('users')
        .doc(currentUser!.uid)
        .collection('blockedUsers')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.id).toList());
  }

  @override
  Stream<List<Map<String, dynamic>>> getAllPermittedUsers() {
    final currentUser = authApi.getCurrentUser();

    // Stream of blocked user IDs
    final blockedUsersStream = firestoreDb
        .collection('users')
        .doc(currentUser!.uid)
        .collection('blockedUsers')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.id).toList());

    // Combine blocked users with all users
    return blockedUsersStream.asyncExpand((blockedUserIds) {
      return firestoreDb.collection('users').snapshots().asyncExpand((allUsersSnapshot) {
        // For each permitted user, listen to their unread messages
        final streams = allUsersSnapshot.docs
            .where((doc) => doc.data()['email'] != currentUser.email && !blockedUserIds.contains(doc.id))
            .map((doc) {
          final userData = doc.data();
          final chatRoomId = [currentUser.uid, doc.id]..sort();

          // live unread count per user
          final unreadStream = firestoreDb
              .collection('chatrooms')
              .doc(chatRoomId.join('_'))
              .collection('messages')
              .where('receiverID', isEqualTo: currentUser.uid)
              .where('isRead', isEqualTo: false)
              .snapshots()
              .map((unreadSnap) {
            return {
              ...userData,
              'unreadCount': unreadSnap.docs.length,
            };
          });

          return unreadStream;
        }).toList();

        // Merge all unread streams into one combined list
        return Rx.combineLatestList(streams);
      });
    });
  }

  @override
  Future<Userdata?> getUser(String uid) async {
    final userDoc = await firestoreDb.collection('users').doc(uid).get();

    if (userDoc.exists) {
      final data = userDoc.data();
      if (data != null) return Userdata.fromMap(data);
    }
    return null;
  }

  @override
  Future<void> updateLastLogin() async {
    final currentUser = authApi.getCurrentUser();
    debugPrint("updateLastLogin from Api");
  }

  @override
  Future<void> blockUser(String uid) async {
    final currentUser = authApi.getCurrentUser();
    await firestoreDb.collection('users').doc(currentUser!.uid).collection('blockedUsers').doc(uid).set({});
  }

  @override
  Future<void> unblockUser(String uid) async {
    final currentUser = authApi.getCurrentUser();
    await firestoreDb.collection('users').doc(currentUser!.uid).collection('blockedUsers').doc(uid).delete();
  }

  // @override
  // Stream<List<Map<String, dynamic>>> getBlockedUsers(String uid) {
  //   // TODO: Just retrieve and use currentUser ID here like in the other functions?
  //   return firestoreDb.collection('users').doc(uid).collection('blockedUsers').snapshots().asyncMap((snapshot) async {
  //     // get IDs of blocked users
  //     final blockedUserIds = snapshot.docs.map((doc) => doc.id).toList();
  //     // use IDs to retrieve all blocked users
  //     final userDocs = await Future.wait(blockedUserIds.map((id) => firestoreDb.collection('users').doc(id).get()));
  //     // return all blocked users as a list
  //     return userDocs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  //   });
  // }

  @override
  Future<void> deleteAccount() async {
    final currentUser = authApi.getCurrentUser();
    await firestoreDb.collection('users').doc(currentUser!.uid).delete();
  }
}
