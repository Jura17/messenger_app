import 'package:firebase_auth/firebase_auth.dart';
import 'package:messenger_app/features/auth/data/models/error_handling_authentication.dart';
import 'package:messenger_app/features/auth/data/provider/auth_api.dart';
import 'package:messenger_app/features/auth/domain/entities/auth_user.dart';
import 'package:messenger_app/features/auth/domain/repositories/auth_repository.dart';

// converts raw Firebase data to app specific types
class FirebaseAuthRepository implements AuthRepository {
  final AuthApi _authApi;

  FirebaseAuthRepository(this._authApi);

  AuthUser _toEntity(User user) => AuthUser(uid: user.uid, email: user.email);

  // .map() transforms each value as it flows out
  @override
  Stream<AuthUser?> onAuthChanged() {
    return _authApi.onAuthChanged().map((firebaseUser) {
      if (firebaseUser == null) return null;
      return _toEntity(firebaseUser);
    });
  }

  @override
  AuthUser? getCurrentUser() {
    final firebaseUser = _authApi.getCurrentUser();
    if (firebaseUser == null) return null;
    return _toEntity(firebaseUser);
  }

  @override
  Future<AuthUser> signIn(String email, String password) async {
    email = email.trim();
    password = password.trim();

    try {
      UserCredential userCredential = await _authApi.signInWithEmailPassword(email, password);
      final authUser = AuthUser(uid: userCredential.user!.uid, email: userCredential.user!.email);
      return authUser;
    } on FirebaseAuthException catch (e) {
      throw LogInWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      throw const LogInWithEmailAndPasswordFailure();
    }
  }

  @override
  Future<AuthUser> signUp({required email, required username, required password}) async {
    email = email.trim();

    try {
      UserCredential userCredential =
          await _authApi.signUpWithEmailPassword(email: email, username: username, password: password);
      final authUser = AuthUser(uid: userCredential.user!.uid, email: userCredential.user!.email);
      return authUser;
    } on FirebaseAuthException catch (e) {
      throw SignUpWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      throw const SignUpWithEmailAndPasswordFailure();
    }
  }

  @override
  Future<void> deleteAccount() async {
    await _authApi.deleteAccount();
  }

  @override
  Future<void> logout() async {
    await _authApi.signOut();
  }

  @override
  Future<void> reauthenticateUser(String email, String password) async {
    await _authApi.reauthenticateUser(email, password);
  }
}
