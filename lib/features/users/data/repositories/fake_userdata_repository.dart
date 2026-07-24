import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messenger_app/features/auth/domain/entities/auth_user.dart';
import 'package:messenger_app/features/users/domain/entities/app_user_data.dart';
import 'package:messenger_app/features/users/presentation/bloc/user_state.dart';

import 'package:messenger_app/features/users/domain/repositories/userdata_repository.dart';

class FakeUserdataRepository implements UserdataRepository {
  final List<AppUserData> _mockUserDb = [];
  final Map<String, Set<String>> _blockedUsersMap = {};
  final _allUsersStreamController = StreamController<List<AppUserData>>.broadcast();

  FakeUserdataRepository() {
    _emitUserUpdates();
  }

  void dispose() {
    _allUsersStreamController.close();
  }

  @override
  Future<void> createUser(String uid, String username, String email) async {
    await Future.delayed(Duration(milliseconds: 200));
    _mockUserDb.add(
      AppUserData(
        uid: uid,
        username: username,
        email: email,
        createdAt: DateTime.now(),
        lastSeen: DateTime.now(),
      ),
    );
    _emitUserUpdates();
  }

  void emitMockUser(List<AppUserData> users) {
    _mockUserDb
      ..clear()
      ..addAll(users);
    _emitUserUpdates();
  }

  @override
  Stream<List<AppUserData>> getAllPermittedUsersStream(AuthUser? currentUser) {
    if (currentUser == null) throw UserError("No current user");

    // Emit immediately before returning stream so that combineLatest2() actually returns sth
    Future.microtask(() {
      _emitUserUpdates();
    });

    return _allUsersStreamController.stream.map((allUsers) {
      final blockedIds = _blockedUsersMap[currentUser.uid] ?? {};
      return allUsers.where((user) => user.uid != currentUser.uid && !blockedIds.contains(user.uid)).toList();
    });
  }

  @override
  Stream<List<AppUserData>> getBlockedUsersStream(AuthUser? currentUser) {
    if (currentUser == null) throw UserError("No current user");

    // listen to all user updates, and dynamically filter for blocked ones
    return _allUsersStreamController.stream.map((allUsers) {
      final blockedIds = _blockedUsersMap[currentUser.uid] ?? {};
      return allUsers.where((user) => blockedIds.contains(user.uid)).toList();
    });
  }

  @override
  Future<AppUserData?> getUserById(String uid) async {
    try {
      Future.delayed(Duration(milliseconds: 500));
      return _mockUserDb.firstWhere((user) => user.uid == uid);
    } catch (e) {
      debugPrint("from mock userdata repo, getUser: $e");
      return null;
    }
  }

  @override
  Stream<AppUserData?> watchCurrentUser(String uid) {
    // makes stream behave like a firestore state stream, instead of a normal dart event stream,
    // meaning: right after subscription we want to emit the latest state of our data
    Future.microtask(_emitUserUpdates);

    return _allUsersStreamController.stream.map((allUsers) {
      try {
        return allUsers.firstWhere((user) => user.uid == uid);
      } catch (_) {
        return null;
      }
    });
  }

  @override
  Future<void> updateOnlineStatus(String uid, bool isOnline) async {
    final AppUserData? user = await getUserById(uid);
    Map<String, dynamic> updatedUserMap;
    if (user == null) {
      debugPrint("Test user not found");
      return;
    }
    final currentUserIndex = _mockUserDb.indexWhere((user) => user.uid == uid);

    if (isOnline) {
      updatedUserMap = {
        'uid': uid,
        'username': user.username,
        'email': user.email,
        'profileImageUrl': user.profileImageUrl,
        'lastSeen': user.lastSeen,
        'createdAt': user.createdAt,
        'isOnline': isOnline,
      };
    } else {
      // updatedUserMap = user.copyWith(lastSeen: DateTime.now(), isOnline: isOnline).toMap();
      updatedUserMap = {
        'uid': uid,
        'username': user.username,
        'email': user.email,
        'profileImageUrl': user.profileImageUrl,
        'lastSeen': DateTime.now(),
        'createdAt': DateTime.now(),
        'isOnline': isOnline,
      };
    }

    // _mockUserDb[currentUserIndex] = FirestoreUserdata.fromMap(updatedUser);
    _mockUserDb[currentUserIndex] = AppUserData(
      uid: uid,
      email: updatedUserMap['email'],
      username: updatedUserMap['username'],
      createdAt: updatedUserMap['createdAt'],
      lastSeen: updatedUserMap['lastSeen'],
    );
  }

  @override
  Future<void> blockUser(String otherUserId, AuthUser? currentUser) async {
    if (currentUser == null) throw Exception("No current user");
    // get the existing set of blocked user IDs or create a new set for the given user
    final blocked = _blockedUsersMap.putIfAbsent(currentUser.uid, () => <String>{});
    blocked.add(otherUserId);
    _emitUserUpdates();
  }

  @override
  Future<void> unblockUser(String otherUserId, AuthUser? currentUser) async {
    if (currentUser == null) throw Exception("No current user");
    final blocked = _blockedUsersMap[currentUser.uid];
    blocked?.remove(otherUserId);
    _emitUserUpdates();
  }

  @override
  Future<void> deleteAccount(AuthUser? currentUser) async {
    if (currentUser == null) throw Exception("No user to delete");
    _mockUserDb.removeWhere((user) => user.uid == currentUser.uid);

    // remove the uid from the blocked users of all users
    for (final blockedSet in _blockedUsersMap.values) {
      blockedSet.remove(currentUser.uid);
    }

    _blockedUsersMap.remove(currentUser.uid);
    _emitUserUpdates();
  }

  void _emitUserUpdates() {
    // notify listeners and
    // create immutable-snapshot-like object (and not the direct reference to the db)
    // ==> Matches Firestore semantics
    _allUsersStreamController.add(List.unmodifiable(_mockUserDb));
  }

  @override
  Future<void> saveProfileImage(XFile imageFile, AuthUser? currentUser) {
    // TODO: implement saveProfileImage
    throw UnimplementedError();
  }
}
