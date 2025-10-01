import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthApi {
  Stream<User?> onAuthChanged();
  User? getCurrentUser();
  Future<UserCredential> signInWithEmailPassword(String email, String password);
  Future<UserCredential> signUpWithEmailPassword({
    required String username,
    required String email,
    required String password,
  });
  Future<void> signOut();
}
