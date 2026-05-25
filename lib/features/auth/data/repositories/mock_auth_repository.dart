import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:messenger_app/features/auth/data/models/error_handling_authentication.dart';
import 'package:messenger_app/features/auth/data/models/mock_user.dart';
import 'package:messenger_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {
  final _streamController = StreamController<User?>.broadcast();
  User? currentUser;
  bool shouldFail = false;
  bool requiresRecentLogin = false;
  bool throwUnknownError = false;

  @override
  Stream<User?> onAuthChanged() => _streamController.stream;

  @override
  User? getCurrentUser() => currentUser;

  @override
  Future<User> signIn(String email, String password) async {
    await Future.delayed(Duration(milliseconds: 50));
    if (shouldFail) throw LogInWithEmailAndPasswordFailure('Invalid credentials');
    if (throwUnknownError) throw Exception('Something unexpected happened');
    final mockUser = MockUser(uid: '123', email: email);
    currentUser = mockUser;
    _streamController.add(mockUser);
    return mockUser;
  }

  @override
  Future<User> signUp({required email, required username, required password}) async {
    await Future.delayed(Duration(milliseconds: 50));
    if (shouldFail) throw SignUpWithEmailAndPasswordFailure('Invalid credentials');
    if (throwUnknownError) throw Exception('Something unexpected happened');
    final mockUser = MockUser(uid: '456', email: email);
    currentUser = mockUser;
    _streamController.add(mockUser);
    return mockUser;
  }

  @override
  Future<void> deleteAccount() async {
    if (requiresRecentLogin) {
      throw FirebaseAuthException(code: 'requires-recent-login');
    }
    currentUser = null;
    _streamController.add(null);
  }

  @override
  Future<void> logout() async {
    currentUser = null;
    _streamController.add(null);
  }

  void dispose() => _streamController.close();

  @override
  Future<void> reauthenticateUser(String email, String password) async {
    final mockUser = MockUser(uid: '456', email: email);
    currentUser = mockUser;
    final credentials = EmailAuthProvider.credential(email: email, password: password);
    await currentUser!.reauthenticateWithCredential(credentials);
  }
}
