import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

import 'package:messenger_app/features/users/data/models/user_data.dart';
import 'package:messenger_app/features/users/data/provider/userdata_api.dart';

class FirestoreUserdataApi implements UserdataApi {
  final FirebaseFirestore firestoreDb;

  FirestoreUserdataApi(this.firestoreDb);

  @override
  Future<void> createUser(String uid, String username, String email) async {
    await firestoreDb.collection('users').doc(uid).set({
      'uid': uid,
      'username': username,
      'email': email,
      'profileImage': '',
      'unreadCount': 0,
      'createdAt': FieldValue.serverTimestamp(),
      'lastSeen': FieldValue.serverTimestamp(),
    });
  }

  @override
  Stream<List<Map<String, dynamic>>> getAllUsersStream() {
    return firestoreDb
        .collection('users')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  @override
  Stream<List<String>> getBlockedUserIdsStream(User? currentUser) {
    return firestoreDb
        .collection('users')
        .doc(currentUser!.uid)
        .collection('blockedUsers')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.id).toList());
  }

  @override
  Future<Userdata?> getUserById(String uid) async {
    final userDoc = await firestoreDb.collection('users').doc(uid).get();

    if (userDoc.exists) {
      final data = userDoc.data();
      if (data != null) return Userdata.fromMap(data);
    }
    return null;
  }

  @override
  Future<void> updateOnlineStatus(String uid) async {
    Userdata? user = await getUserById(uid);
    if (user == null) {
      return;
    }
    final updatedUser = user.copyWith(lastSeen: DateTime.now()).toMap();
    await firestoreDb.collection('users').doc(uid).set(updatedUser, SetOptions(merge: true));
    // shorter alternative: await firestoreDb.collection('users').doc(uid).update({'lastSeen': FieldValue.serverTimestamp()});
    print("lastSeen run");
  }

  @override
  Future<void> blockUser(String uid, User? currentUser) async {
    await firestoreDb.collection('users').doc(currentUser!.uid).collection('blockedUsers').doc(uid).set({});
  }

  @override
  Future<void> unblockUser(String uid, User? currentUser) async {
    await firestoreDb.collection('users').doc(currentUser!.uid).collection('blockedUsers').doc(uid).delete();
  }

  @override
  Future<void> deleteAccount(User? currentUser) async {
    await firestoreDb.collection('users').doc(currentUser!.uid).delete();
  }

  @override
  Future<String?> getProfileImage(String uid) async {}
}
