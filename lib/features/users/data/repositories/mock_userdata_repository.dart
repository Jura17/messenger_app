import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:messenger_app/features/users/bloc/user_state.dart';
import 'package:messenger_app/features/users/data/models/user_data.dart';
import 'package:messenger_app/features/users/data/repositories/userdata_repository.dart';

class MockUserdataRepository implements UserdataRepository {
  final List<Userdata> _mockUserDb = [];
  final Map<String, Set<String>> _blockedUsersMap = {};
  final _allUsersStreamController = StreamController<List<Userdata>>.broadcast();

  MockUserdataRepository() {
    _emitUserUpdates();
  }

  void dispose() {
    _allUsersStreamController.close();
  }

  @override
  Future<void> createUser(String uid, String email) async {
    await Future.delayed(Duration(milliseconds: 200));
    _mockUserDb.add(Userdata(uid: uid, email: email));
    _emitUserUpdates();
  }

  void emitMockUser(List<Userdata> users) {
    _mockUserDb
      ..clear()
      ..addAll(users);
    _emitUserUpdates();
  }

  @override
  Stream<List<Userdata>> getAllPermittedUsersStream(User? currentUser) {
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
  Stream<List<Userdata>> getBlockedUsersStream(User? currentUser) {
    if (currentUser == null) throw UserError("No current user");

    // listen to all user updates, and dynamically filter for blocked ones
    return _allUsersStreamController.stream.map((allUsers) {
      final blockedIds = _blockedUsersMap[currentUser.uid] ?? {};
      return allUsers.where((user) => blockedIds.contains(user.uid)).toList();
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
    // get the existing set of blocked user IDs or create a new set for the given user
    final blocked = _blockedUsersMap.putIfAbsent(currentUser.uid, () => <String>{});
    blocked.add(otherUserId);
    _emitUserUpdates();
  }

  @override
  Future<void> unblockUser(String otherUserId, User? currentUser) async {
    if (currentUser == null) throw Exception("No current user");
    final blocked = _blockedUsersMap[currentUser.uid];
    blocked?.remove(otherUserId);
    _emitUserUpdates();
  }

  @override
  Future<void> deleteAccount(User? currentUser) async {
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
    // ==> Matches Firestore semeantics
    _allUsersStreamController.add(List.unmodifiable(_mockUserDb));
  }
}
