import 'package:flutter/foundation.dart';
import 'package:messenger_app/features/auth/data/provider/firebase_auth_api.dart';
import 'package:messenger_app/features/users/data/models/user_data.dart';
import 'package:messenger_app/features/users/data/provider/firestore_userdata_api.dart';
import 'package:messenger_app/features/users/data/repositories/userdata_repository.dart';
import 'package:rxdart/rxdart.dart';

class FirestoreUserdataRepository implements UserdataRepository {
  final FirestoreUserdataApi _userdataApi;
  final FirebaseAuthApi _authApi;

  FirestoreUserdataRepository(this._userdataApi, this._authApi);

  @override
  Future<void> createUser(String uid, String email) async {
    await _userdataApi.createUser(uid, email);
  }

  @override
  Stream<List<Userdata>> getAllPermittedUsers() {
    final currentUser = _authApi.getCurrentUser();
    final allUsersStream = _userdataApi.getAllUsers();
    final blockedUsersStream = _userdataApi.getBlockedUserIds();

    // merge user stream and blocked user ID stream into one (emits value when one of them changes)
    return Rx.combineLatest2(allUsersStream, blockedUsersStream, (allUsers, blockedUserIds) {
      final permittedUsers =
          allUsers.where((user) => user['uid'] != currentUser!.uid && !blockedUserIds.contains(user['uid']));

      return permittedUsers.map((user) => Userdata.fromMap(user)).toList();
    });
  }

  @override
  Future<Userdata?> getUser(String uid) {
    return _userdataApi.getUser(uid);
  }

  @override
  Future<void> updateLastLogin(String uid) async {
    debugPrint("updateLastLogin from Api");
  }

  // @override
  // Stream<List<Userdata>> getBlockedUsers(String uid) {
  //   return _userdataApi
  //       .getBlockedUserIds(uid)
  //       .map((userList) => userList.map((user) => Userdata.fromMap(user)).toList());
  // }

  @override
  Future<void> blockUser(String uid) async {
    await _userdataApi.blockUser(uid);
  }

  @override
  Future<void> unblockUser(String uid) async {
    await _userdataApi.unblockUser(uid);
  }

  @override
  Future<void> deleteAccount() async {
    await _userdataApi.deleteAccount();
  }
}
