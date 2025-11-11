import 'package:firebase_auth/firebase_auth.dart';
import 'package:messenger_app/features/auth/data/models/authentication_error_handling.dart';
import 'package:messenger_app/features/auth/data/provider/auth_api.dart';
import 'package:messenger_app/features/auth/data/repositories/auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  final AuthApi _authApi;

  FirebaseAuthRepository(this._authApi);

  @override
  Stream<User?> onAuthChanged() => _authApi.onAuthChanged();

  @override
  User? getCurrentUser() => _authApi.getCurrentUser();

  @override
  Future<User> signIn(String email, String password) async {
    email = email.trim();
    password = password.trim();

    try {
      UserCredential userCredential = await _authApi.signInWithEmailPassword(email, password);

      return userCredential.user!;
    } on FirebaseAuthException catch (e) {
      throw LogInWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      throw const LogInWithEmailAndPasswordFailure();
    }
  }

  @override
  Future<User> signUp({required email, required username, required password}) async {
    email = email.trim();

    try {
      UserCredential userCredential =
          await _authApi.signUpWithEmailPassword(email: email, username: username, password: password);
      return userCredential.user!;
    } on FirebaseAuthException catch (e) {
      throw SignUpWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      throw const SignUpWithEmailAndPasswordFailure();
    }
  }

  @override
  Future<void> deleteAccount() async => await _authApi.deleteAccount();

  @override
  Future<void> logout() async {
    try {
      await _authApi.signOut();
    } catch (_) {
      throw LogOutFailure();
    }
  }
}
