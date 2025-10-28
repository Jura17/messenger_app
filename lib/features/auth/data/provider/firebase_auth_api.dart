import 'package:firebase_auth/firebase_auth.dart';
import 'package:messenger_app/features/auth/data/provider/auth_api.dart';

class FirebaseAuthApi implements AuthApi {
  final FirebaseAuth auth;

  FirebaseAuthApi(this.auth);

  @override
  Stream<User?> onAuthChanged() => auth.authStateChanges();

  @override
  User? getCurrentUser() {
    return auth.currentUser;
  }

  @override
  Future<UserCredential> signUpWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException {
      rethrow;
    }
  }

  @override
  Future<UserCredential> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);

      return userCredential;
    } on FirebaseAuthException {
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    return await auth.signOut();
  }

  @override
  Future<void> deleteAccount() async {
    User? currentUser = getCurrentUser();
    if (currentUser != null) {
      await currentUser.delete();
    }
  }
}
