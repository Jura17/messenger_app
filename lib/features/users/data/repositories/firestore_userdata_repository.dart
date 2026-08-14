import 'package:image_picker/image_picker.dart';
import 'package:messenger_app/features/auth/domain/entities/auth_user.dart';

import 'package:messenger_app/features/users/data/provider/userdata_api.dart';
import 'package:messenger_app/features/users/domain/entities/app_user_data.dart';
import 'package:messenger_app/features/users/domain/repositories/userdata_repository.dart';
import 'package:rxdart/rxdart.dart';

class FirestoreUserdataRepository implements UserdataRepository {
  final UserdataApi _userdataApi;

  FirestoreUserdataRepository(this._userdataApi);

  @override
  Future<void> createUser(String uid, String username, String email) async {
    await _userdataApi.createUser(uid, username, email);
  }

  @override
  Stream<List<AppUserData>> getAllPermittedUsersStream(AuthUser? currentUser) {
    if (currentUser == null) throw Stream.error("UserdataRepo, getAllPermittedUsersStream: Userdata stream error");

    final allUsersStream = _userdataApi.getAllUsersStream();
    final blockedUsersStream = _userdataApi.getBlockedUserIdsStream(currentUser);

    // merge user stream and blocked user ID stream into one (emits value when one of them changes)
    return Rx.combineLatest2(allUsersStream, blockedUsersStream, (allUsers, blockedUserIds) {
      final permittedUsers = allUsers.where((user) {
        return user['uid'] != currentUser.uid && !blockedUserIds.contains(user['uid']);
      });

      return permittedUsers.map((user) {
        return AppUserData(
          uid: user['uid'],
          email: user['email'],
          username: user['username'],
          createdAt: user['createdAt'].toDate(),
          lastSeen: user['lastSeen'].toDate(),
        );
      }).toList();
    });
  }

  @override
  Stream<List<AppUserData>> getBlockedUsersStream(AuthUser? currentUser) {
    if (currentUser == null) return Stream.error("Blocked users stream error");

    final allUsersStream = _userdataApi.getAllUsersStream();
    final blockedUsersStream = _userdataApi.getBlockedUserIdsStream(currentUser);

    // merge user stream and blocked user ID stream into one (emits value when one of them changes)
    return Rx.combineLatest2(allUsersStream, blockedUsersStream, (allUsers, blockedUserIds) {
      final blockedUsers =
          allUsers.where((user) => user['uid'] != currentUser.uid && blockedUserIds.contains(user['uid']));

      return blockedUsers.map((user) {
        return AppUserData(
          uid: user['uid'],
          email: user['email'],
          username: user['username'],
          createdAt: user['createdAt'].toDate(),
          lastSeen: user['lastSeen'].toDate(),
        );
      }).toList();
    });
  }

  @override
  Future<AppUserData?> getUserById(String uid) {
    return _userdataApi.getUserById(uid);
  }

  @override
  Stream<AppUserData?> watchCurrentUser(String uid) {
    return _userdataApi.watchCurrentUser(uid);
  }

  @override
  Future<void> updateOnlineStatus(String uid, bool onlineStatus) async {
    await _userdataApi.updateOnlineStatus(uid, onlineStatus);
  }

  @override
  Future<void> blockUser(String otherUserId, AuthUser? currentUser) async {
    await _userdataApi.blockUser(otherUserId, currentUser);
  }

  @override
  Future<void> unblockUser(String otherUserId, AuthUser? currentUser) async {
    await _userdataApi.unblockUser(otherUserId, currentUser);
  }

  @override
  Future<void> deleteAccount(AuthUser? currentUser) async {
    await _userdataApi.deleteAccount(currentUser);
  }

  @override
  Future<void> saveProfileImage(XFile imageFile, AuthUser? currentUser) async {
    await _userdataApi.saveProfileImage(imageFile, currentUser);
  }
}
