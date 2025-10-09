import 'package:firebase_auth/firebase_auth.dart';
import 'package:messenger_app/features/auth/data/provider/auth_api.dart';
import 'package:messenger_app/features/users/data/provider/userdata_api.dart';

class FirebaseAuthRepository {
  final AuthApi _authApi;
  final UserdataApi _userdataApi;

  FirebaseAuthRepository(this._authApi, this._userdataApi);

  Stream<User?> onAuthChanged() => _authApi.onAuthChanged();

  User? getCurrentUser() => _authApi.getCurrentUser();

  Future<User> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _authApi.signInWithEmailPassword(email, password);
      await _userdataApi.updateLastLogin();
      return userCredential.user!;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<User> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await _authApi.signUpWithEmailPassword(email, password);
      await _userdataApi.createUser(userCredential.user!.uid, email);

      return userCredential.user!;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> deleteAccount() async {
    await _userdataApi.deleteAccount();
    await _authApi.deleteAccount();
  }

  Future<void> logout() async => await _authApi.signOut();
}
