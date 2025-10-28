import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:messenger_app/features/auth/data/provider/firebase_auth_api.dart';
import 'package:messenger_app/features/users/data/models/user_data.dart';
import 'package:messenger_app/features/users/data/provider/userdata_api.dart';

class FirestoreUserdataApi implements UserdataApi {
  final FirebaseFirestore firestoreDb;
  final FirebaseAuthApi authApi;

  FirestoreUserdataApi(this.firestoreDb, this.authApi);

  @override
  Future<void> createUser(String uid, String email) async {
    final newUser = Userdata(uid: uid, email: email);
    await firestoreDb.collection('users').doc(uid).set(newUser.toMap());
  }

  @override
  Stream<List<Map<String, dynamic>>> getAllUsersStream() {
    return firestoreDb
        .collection('users')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  @override
  Stream<List<String>> getBlockedUserIdsStream() {
    final currentUser = authApi.getCurrentUser();
    return firestoreDb
        .collection('users')
        .doc(currentUser!.uid)
        .collection('blockedUsers')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.id).toList());
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
  Future<void> updateLastLogin(String uid) async {
    // TODO: implement updateLastLogin logic after adding property to userdata model
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

  @override
  Future<void> deleteAccount() async {
    final currentUser = authApi.getCurrentUser();
    await firestoreDb.collection('users').doc(currentUser!.uid).delete();
  }
}
