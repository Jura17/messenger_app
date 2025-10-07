import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthApi {
  Stream<User?> onAuthChanged();

  User? getCurrentUser();
  Future<User> signInWithEmailPassword(String email, String password);
  Future<User> signUpWithEmailPassword(String email, String password);
  Future<void> signOut();
  Future<void> deleteAccount();
}
