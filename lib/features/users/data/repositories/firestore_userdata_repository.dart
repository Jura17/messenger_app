import 'package:flutter/foundation.dart';
import 'package:messenger_app/features/auth/data/provider/firebase_auth_api.dart';
import 'package:messenger_app/features/chat/data/repositories/firestore_chat_repository.dart';
import 'package:messenger_app/features/users/data/models/user_data.dart';
import 'package:messenger_app/features/users/data/provider/firestore_userdata_api.dart';
import 'package:messenger_app/features/users/data/repositories/userdata_repository.dart';
import 'package:rxdart/rxdart.dart';

class FirestoreUserdataRepository implements UserdataRepository {
  final FirestoreUserdataApi _userdataApi;
  final FirebaseAuthApi _authApi;
  // final FirestoreChatRepository _chatRepo;

  FirestoreUserdataRepository(this._userdataApi, this._authApi);

  @override
  Future<void> createUser(String uid, String email) async {
    await _userdataApi.createUser(uid, email);
  }

  @override
  Stream<List<Userdata>> getAllPermittedUsersStream() {
    final currentUser = _authApi.getCurrentUser();
    if (currentUser == null) throw Stream.error("User stream error");

    final allUsersStream = _userdataApi.getAllUsersStream();
    final blockedUsersStream = _userdataApi.getBlockedUserIdsStream();

    // merge user stream and blocked user ID stream into one (emits value when one of them changes)
    return Rx.combineLatest2(allUsersStream, blockedUsersStream, (allUsers, blockedUserIds) {
      final permittedUsers =
          allUsers.where((user) => user['uid'] != currentUser.uid && !blockedUserIds.contains(user['uid']));

      return permittedUsers.map((user) => Userdata.fromMap(user)).toList();
    });
  }

  // @override
  // Stream<List<Userdata>> getAllPermittedUsersStreamWithUnreadCount() {
  //   final currentUser = _authApi.getCurrentUser();
  //   // if (currentUser == null) throw Exception("No authenticated user");
  //   if (currentUser == null) return Stream.error("User stream error");

  //   final permittedUsersStream = getAllPermittedUsersStream();

  //   return permittedUsersStream.switchMap((users) {
  //     if (users.isEmpty) return Stream.value([]);

  //     final streams = users.map((user) {
  //       return _chatRepo.watchUnreadMessageCount(user.uid).map(
  //             (count) => user.copyWith(unreadCount: count),
  //           );
  //     }).toList();

  //     return Rx.combineLatestList(streams);
  //   });
  // }

  // @override
  // Future<void> markMessagesAsRead(String receiverId) async {
  //   await _userdataApi.markMessagesAsRead(receiverId);
  // }

  @override
  Stream<List<Userdata>> getBlockedUsersStream() {
    final currentUser = _authApi.getCurrentUser();
    if (currentUser == null) return Stream.error("Blocked users stream error");

    final allUsersStream = _userdataApi.getAllUsersStream();
    final blockedUsersStream = _userdataApi.getBlockedUserIdsStream();

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
