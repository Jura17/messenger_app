import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      'createdAt': FieldValue.serverTimestamp(),
      'lastSeen': FieldValue.serverTimestamp(),
      'isOnline': true,
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
  Stream<Userdata?> watchUserdata(String uid) {
    return firestoreDb.collection('users').doc(uid).snapshots().map((doc) {
      if (!doc.exists) return null;
      return Userdata.fromMap(doc.data()!);
    });
  }

  @override
  Future<void> updateOnlineStatus(String uid, bool isOnline) async {
    Userdata? user = await getUserById(uid);
    Map<String, dynamic> updatedUser;
    if (user == null) {
      return;
    }
    // if isOnline is true -> update only the bool, if false -> update also the lastSeen timestamp
    if (isOnline) {
      updatedUser = user.copyWith(isOnline: isOnline).toMap();
    } else {
      updatedUser = user.copyWith(lastSeen: DateTime.now(), isOnline: isOnline).toMap();
    }
    await firestoreDb.collection('users').doc(uid).set(updatedUser, SetOptions(merge: true));
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
  Future<String?> getProfileImage(String uid) async {
    // TODO: add getProfileImage logic
    return null;
  }
}
