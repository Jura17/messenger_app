import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Stream<User?> onAuthChanged();
  User? getCurrentUser();
  Future<User> signIn(String email, String password);
  Future<User> signUp({required email, required username, required password});
  Future<void> deleteAccount();
  Future<void> logout();
}
