import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthApi {
  Stream<User?> onAuthChanged();

  User? getCurrentUser();
  Future<UserCredential> signInWithEmailPassword(String email, String password);
  Future<UserCredential> signUpWithEmailPassword(String email, String password);
  Future<void> signOut();
  Future<void> deleteAccount();
}
