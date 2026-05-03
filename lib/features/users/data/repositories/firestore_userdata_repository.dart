import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:messenger_app/features/users/data/models/user_data.dart';

import 'package:messenger_app/features/users/data/provider/userdata_api.dart';
import 'package:messenger_app/features/users/data/repositories/userdata_repository.dart';
import 'package:rxdart/rxdart.dart';

class FirestoreUserdataRepository implements UserdataRepository {
  final UserdataApi _userdataApi;

  FirestoreUserdataRepository(this._userdataApi);

  @override
  Future<void> createUser(String uid, String username, String email) async {
    await _userdataApi.createUser(uid, username, email);
  }

  @override
  Stream<List<Userdata>> getAllPermittedUsersStream(User? currentUser) {
    if (currentUser == null) throw Stream.error("UserdataRepo, getAllPermittedUsersStream: Userdata stream error");

    final allUsersStream = _userdataApi.getAllUsersStream();
    final blockedUsersStream = _userdataApi.getBlockedUserIdsStream(currentUser);

    // merge user stream and blocked user ID stream into one (emits value when one of them changes)
    return Rx.combineLatest2(allUsersStream, blockedUsersStream, (allUsers, blockedUserIds) {
      final permittedUsers =
          allUsers.where((user) => user['uid'] != currentUser.uid && !blockedUserIds.contains(user['uid']));

      return permittedUsers.map((user) => Userdata.fromMap(user)).toList();
    });
  }

  @override
  Stream<List<Userdata>> getBlockedUsersStream(User? currentUser) {
    if (currentUser == null) return Stream.error("Blocked users stream error");

    final allUsersStream = _userdataApi.getAllUsersStream();
    final blockedUsersStream = _userdataApi.getBlockedUserIdsStream(currentUser);

    // merge user stream and blocked user ID stream into one (emits value when one of them changes)
    return Rx.combineLatest2(allUsersStream, blockedUsersStream, (allUsers, blockedUserIds) {
      final blockedUsers =
          allUsers.where((user) => user['uid'] != currentUser.uid && blockedUserIds.contains(user['uid']));

      return blockedUsers.map((user) => Userdata.fromMap(user)).toList();
    });
  }

  @override
  Future<Userdata?> getUserById(String uid) {
    return _userdataApi.getUserById(uid);
  }

  @override
  Stream<Userdata?> watchCurrentUser(String uid) {
    return _userdataApi.watchCurrentUser(uid);
  }

  @override
  Future<void> updateOnlineStatus(String uid, bool onlineStatus) async {
    await _userdataApi.updateOnlineStatus(uid, onlineStatus);
  }

  @override
  Future<void> blockUser(String otherUserId, User? currentUser) async {
    await _userdataApi.blockUser(otherUserId, currentUser);
  }

  @override
  Future<void> unblockUser(String otherUserId, User? currentUser) async {
    await _userdataApi.unblockUser(otherUserId, currentUser);
  }

  @override
  Future<void> deleteAccount(User? currentUser) async {
    await _userdataApi.deleteAccount(currentUser);
  }

  @override
  Future<void> saveProfileImage(XFile imageFile, User? currentUser) async {
    debugPrint("from userdata api saveProfileImage");
    await _userdataApi.saveProfileImage(imageFile, currentUser);
  }
}
