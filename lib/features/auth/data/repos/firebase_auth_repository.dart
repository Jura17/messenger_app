import 'package:firebase_auth/firebase_auth.dart';
import 'package:messenger_app/features/auth/data/provider/auth_api.dart';

class FirebaseAuthRepository {
  final AuthApi _authApi;

  FirebaseAuthRepository(this._authApi);

  Stream<User?> onAuthChanged() => _authApi.onAuthChanged();

  User? getCurrentUser() => _authApi.getCurrentUser();

  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async =>
      _authApi.signInWithEmailPassword(email, password);

  Future<UserCredential> signUpWithEmailPassword({
    required String username,
    required String email,
    required String password,
  }) async =>
      _authApi.signUpWithEmailPassword(username: username, email: email, password: password);

  Future<void> signOut() async => await _authApi.signOut();
}
