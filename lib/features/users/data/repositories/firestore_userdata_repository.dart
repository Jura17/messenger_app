import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'package:messenger_app/features/users/data/models/user_data.dart';
import 'package:messenger_app/features/users/data/provider/firestore_userdata_api.dart';
import 'package:messenger_app/features/users/data/repositories/userdata_repository.dart';
import 'package:rxdart/rxdart.dart';

class FirestoreUserdataRepository implements UserdataRepository {
  final FirestoreUserdataApi _userdataApi;

  FirestoreUserdataRepository(this._userdataApi);

  @override
  Future<void> createUser(String uid, String email) async {
    await _userdataApi.createUser(uid, email);
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
  Future<Userdata?> getUser(String uid) {
    return _userdataApi.getUser(uid);
  }

  @override
  Future<void> updateLastLogin(String uid) async {
    // TODO: implement updateLastLogin logic after adding property to userdata model
    debugPrint("updateLastLogin from Api");
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
}
