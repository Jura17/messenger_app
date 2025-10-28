import 'package:firebase_auth/firebase_auth.dart';
import 'package:messenger_app/features/auth/data/repositories/auth_repository.dart';

class MockAuthRepository implements AuthRepository {
  @override
  Stream<User?> onAuthChanged() {
    // TODO: implement onAuthChanged
    throw UnimplementedError();
  }

  @override
  User? getCurrentUser() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }

  @override
  Future<User> signIn(String email, String password) {
    // TODO: implement signIn
    throw UnimplementedError();
  }

  @override
  Future<User> signUp(String email, String password) {
    // TODO: implement signUp
    throw UnimplementedError();
  }

  @override
  Future<void> deleteAccount() {
    // TODO: implement deleteAccount
    throw UnimplementedError();
  }

  @override
  Future<void> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }
}
