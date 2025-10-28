import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:messenger_app/features/users/data/models/user_data.dart';
import 'package:messenger_app/features/users/data/repositories/userdata_repository.dart';

class MockUserdataRepository implements UserdataRepository {
  final List<Userdata> _mockUserDb = [];
  final _streamController = StreamController<List<Userdata>>.broadcast();

  MockUserdataRepository() {
    _streamController.add(_mockUserDb);
  }

  void dispose() {
    _streamController.close();
  }

  @override
  Future<void> createUser(String uid, String email) async {
    Future.delayed(Duration(milliseconds: 200));
    _mockUserDb.add(Userdata(uid: uid, email: email));

    // notify listeners and
    // create immutable-snapshot-like object (and not the direct reference to the db)
    // ==> Matches Firestore semeantics
    _streamController.add(List.unmodifiable(_mockUserDb));
  }

  void emitMockUser(List<Userdata> users) {
    _mockUserDb
      ..clear()
      ..addAll(users);
    _streamController.add(List.unmodifiable(_mockUserDb));
  }

  @override
  Stream<List<Userdata>> getAllPermittedUsersStream(User? currentUser) {
    return _streamController.stream;
  }

  @override
  Stream<List<Userdata>> getBlockedUsersStream(User? currentUser) {
    // TODO: implement getBlockedUsersStream
    throw UnimplementedError();
  }

  @override
  Future<Userdata?> getUser(String uid) {
    // TODO: implement getUser
    throw UnimplementedError();
  }

  @override
  Future<void> updateLastLogin(String uid) {
    // TODO: implement updateLastLogin
    throw UnimplementedError();
  }

  @override
  Future<void> blockUser(String uid, User? currentUser) {
    // TODO: implement blockUser
    throw UnimplementedError();
  }

  @override
  Future<void> unblockUser(String uid, User? currentUser) {
    // TODO: implement unblockUser
    throw UnimplementedError();
  }

  @override
  Future<void> deleteAccount(User? currentUser) {
    // TODO: implement deleteAccount
    throw UnimplementedError();
  }
}
