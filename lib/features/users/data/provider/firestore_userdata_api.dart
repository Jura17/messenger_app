import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messenger_app/features/auth/domain/entities/auth_user.dart';

import 'package:messenger_app/features/users/data/models/firestore_user_data.dart';
import 'package:messenger_app/features/users/data/provider/userdata_api.dart';
import 'package:messenger_app/features/users/domain/entities/app_user_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  Stream<List<String>> getBlockedUserIdsStream(AuthUser? currentUser) {
    return firestoreDb
        .collection('users')
        .doc(currentUser!.uid)
        .collection('blockedUsers')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.id).toList());
  }

  @override
  Future<AppUserData?> getUserById(String uid) async {
    final userDoc = await firestoreDb.collection('users').doc(uid).get();

    if (userDoc.exists) {
      final data = userDoc.data();
      if (data != null) {
        final userdata = FirestoreUserdata.fromMap(data);

        return AppUserData(
          uid: uid,
          email: userdata.email,
          username: userdata.username,
          createdAt: userdata.createdAt,
          lastSeen: userdata.lastSeen,
        );
      }
    }
    return null;
  }

  @override
  Stream<AppUserData?> watchCurrentUser(String uid) {
    return firestoreDb.collection('users').doc(uid).snapshots().map((doc) {
      if (!doc.exists) return null;
      final userdata = FirestoreUserdata.fromMap(doc.data()!);

      return AppUserData(
        uid: uid,
        email: userdata.email,
        username: userdata.username,
        createdAt: userdata.createdAt,
        lastSeen: userdata.lastSeen,
      );
    });
  }

  @override
  Future<void> updateOnlineStatus(String uid, bool isOnline) async {
    AppUserData? user = await getUserById(uid);
    Map<String, dynamic> updatedUserMap;
    if (user == null) {
      return;
    }
    // if isOnline is true -> update only the bool, if false -> update also the lastSeen timestamp
    if (isOnline) {
      updatedUserMap = {
        'uid': uid,
        'username': user.username,
        'email': user.email,
        'profileImageUrl': user.profileImageUrl,
        'lastSeen': Timestamp.fromDate(user.lastSeen),
        'createdAt': Timestamp.fromDate(user.createdAt),
        'isOnline': isOnline,
      };
    } else {
      // updatedUserMap = user.copyWith(lastSeen: DateTime.now(), isOnline: isOnline).toMap();
      updatedUserMap = {
        'uid': uid,
        'username': user.username,
        'email': user.email,
        'profileImageUrl': user.profileImageUrl,
        'lastSeen': Timestamp.fromDate(DateTime.now()),
        'createdAt': Timestamp.fromDate(DateTime.now()),
        'isOnline': isOnline,
      };
    }
    await firestoreDb.collection('users').doc(uid).set(updatedUserMap, SetOptions(merge: true));
  }

  @override
  Future<void> blockUser(String uid, AuthUser? currentUser) async {
    await firestoreDb.collection('users').doc(currentUser!.uid).collection('blockedUsers').doc(uid).set({});
  }

  @override
  Future<void> unblockUser(String uid, AuthUser? currentUser) async {
    await firestoreDb.collection('users').doc(currentUser!.uid).collection('blockedUsers').doc(uid).delete();
  }

  @override
  Future<void> deleteAccount(AuthUser? currentUser) async {
    await firestoreDb.collection('users').doc(currentUser!.uid).delete();
  }

  // save image locally via shared preferences (should be replaced with FirebaseStorage later)
  @override
  Future<void> saveProfileImage(XFile imageFile, AuthUser? currentUser) async {
    if (currentUser == null) return Future.delayed(Duration(milliseconds: 0));
    final prefs = await SharedPreferences.getInstance();
    try {
      prefs.setString(currentUser.uid, imageFile.path);
      //   final storageRef = FirebaseStorage.instance.ref();
      //   final imageRef = storageRef.child('profile_images').child('${currentUser.uid}.jpg');
      //   var metadata = SettableMetadata(contentType: "image/jpeg");

      //   await imageRef.putFile(File(imageFile.path), metadata);
      //   debugPrint('Upload complete');

      //   final downloadImageUrl = await imageRef.getDownloadURL();
      // await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).update({
      //   'profileImageUrl': downloadImageUrl,
      // });
    } catch (e) {
      debugPrint("From Firestore UserdataApi saveProfileImage: Uploading image failed: \n$e");
    }
  }
}
