import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:messenger_app/features/users/data/models/user_data.dart';
import 'package:messenger_app/features/users/data/repositories/userdata_repository.dart';

class MockUserdataRepository implements UserdataRepository {
  final List<Userdata> _mockUserDb = [];
  final Map<String, Set<String>> _blockedUsersMap = {};
  final _allUsersStreamController = StreamController<List<Userdata>>.broadcast();
  final _blockedUsersStreamController = StreamController<List<Userdata>>.broadcast();

  MockUserdataRepository() {
    _allUsersStreamController.add(List.unmodifiable(_mockUserDb));
    _blockedUsersStreamController.add([]);
  }

  void dispose() {
    _allUsersStreamController.close();
    _blockedUsersStreamController.close();
  }

  @override
  Future<void> createUser(String uid, String email) async {
    Future.delayed(Duration(milliseconds: 200));
    _mockUserDb.add(Userdata(uid: uid, email: email));

    // notify listeners and
    // create immutable-snapshot-like object (and not the direct reference to the db)
    // ==> Matches Firestore semeantics
    _allUsersStreamController.add(List.unmodifiable(_mockUserDb));
  }

  void emitMockUser(List<Userdata> users) {
    _mockUserDb
      ..clear()
      ..addAll(users);
    _allUsersStreamController.add(List.unmodifiable(_mockUserDb));
  }

  @override
  Stream<List<Userdata>> getAllPermittedUsersStream(User? currentUser) {
    if (currentUser == null) throw Exception("No current user");

    return _allUsersStreamController.stream.map((allUsers) {
      final blockedIds = _blockedUsersMap[currentUser.uid] ?? {};
      return allUsers.where((user) => user.uid != currentUser.uid && !blockedIds.contains(user.uid)).toList();
    });
  }

  @override
  Stream<List<Userdata>> getBlockedUsersStream(User? currentUser) {
    if (currentUser == null) throw Exception("No current user");

    return _blockedUsersStreamController.stream.map((blockedUsers) {
      final blockedIds = _blockedUsersMap[currentUser.uid] ?? {};
      return blockedUsers.where((user) => user.uid != currentUser.uid && !blockedIds.contains(user.uid)).toList();
    });
  }

  @override
  Future<Userdata?> getUser(String uid) async {
    try {
      return _mockUserDb.firstWhere((user) => user.uid == uid);
    } catch (e) {
      debugPrint("from mock userdata repo, getUser: $e");
      return null;
    }
  }

  @override
  Future<void> updateLastLogin(String uid) async {
    // TODO: implement updateLastLogin logic after adding property to userdata model
    debugPrint("updateLastLogin from Api");
  }

  @override
  Future<void> blockUser(String otherUserId, User? currentUser) async {
    if (currentUser == null) throw Exception("No current user");
    // get the existing set or create a new set for the given uid
    final blocked = _blockedUsersMap.putIfAbsent(currentUser.uid, () => <String>{});
    blocked.add(otherUserId);
    _emitUserUpdates(currentUser);
  }

  @override
  Future<void> unblockUser(String otherUserId, User? currentUser) async {
    if (currentUser == null) throw Exception("No current user");
    final blocked = _blockedUsersMap[currentUser.uid];
    blocked?.remove(otherUserId);
    _emitUserUpdates(currentUser);
  }

  @override
  Future<void> deleteAccount(User? currentUser) async {
    if (currentUser == null) throw Exception("No user to delete");
    _mockUserDb.removeWhere((user) => user.uid == currentUser.uid);
    _blockedUsersMap.remove(currentUser.uid);
    _emitUserUpdates(currentUser);
  }

  void _emitUserUpdates(User? currentUser) {
    final blockedUsers = _mockUserDb.where((user) {
      final blocked = _blockedUsersMap[currentUser?.uid] ?? {};
      return blocked.contains(user.uid);
    }).toList();

    // create and add an updated snapshot of the user list
    _allUsersStreamController.add(List.unmodifiable(_mockUserDb));
    _blockedUsersStreamController.add(blockedUsers);
  }
}
