import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:messenger_app/features/auth/data/models/mock_user.dart';
import 'package:messenger_app/features/auth/data/repositories/auth_repository.dart';

class MockAuthRepository implements AuthRepository {
  final _streamController = StreamController<User?>.broadcast();
  User? _currentUser;

  @override
  Stream<User?> onAuthChanged() => _streamController.stream;

  @override
  User? getCurrentUser() => _currentUser;

  @override
  Future<User> signIn(String email, String password) async {
    await Future.delayed(Duration(milliseconds: 200));

    final fakeUser = MockUser(uid: '123', email: email);
    _currentUser = fakeUser;
    _streamController.add(fakeUser);
    return fakeUser;
  }

  @override
  Future<User> signUp(String email, String password) async {
    await Future.delayed(Duration(milliseconds: 200));

    final fakeUser = MockUser(uid: '456', email: email);
    _currentUser = fakeUser;
    _streamController.add(fakeUser);
    return fakeUser;
  }

  @override
  Future<void> deleteAccount() async {
    _currentUser = null;
    _streamController.add(null);
  }

  @override
  Future<void> logout() async {
    _currentUser = null;
    _streamController.add(null);
  }

  void dispose() => _streamController.close();
}
