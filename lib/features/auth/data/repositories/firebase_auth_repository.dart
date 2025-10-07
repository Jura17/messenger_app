import 'package:firebase_auth/firebase_auth.dart';
import 'package:messenger_app/features/auth/data/provider/auth_api.dart';

class FirebaseAuthRepository {
  final AuthApi _authApi;

  FirebaseAuthRepository(this._authApi);

  Stream<User?> onAuthChanged() => _authApi.onAuthChanged();

  User? getCurrentUser() => _authApi.getCurrentUser();

  Future<User> signIn(String email, String password) async {
    return _authApi.signInWithEmailPassword(email, password);
  }

  Future<User> signUp(String email, String password) async {
    return _authApi.signUpWithEmailPassword(email, password);
  }

  Future<void> logout() async => await _authApi.signOut();
}
