import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _authInstance = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? getCurrentUser() {
    return _authInstance.currentUser;
  }

  Future<UserCredential> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _authInstance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // save user info if it doesn't already exist
      _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<UserCredential> signUpWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredentials =
          await _authInstance.createUserWithEmailAndPassword(email: email, password: password);

      _firestore.collection('users').doc(userCredentials.user!.uid).set({
        'uid': userCredentials.user!.uid,
        'email': email,
      });

      return userCredentials;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> signOut() async {
    return await _authInstance.signOut();
  }

  Future<void> deleteAccount() async {
    User? currentUser = getCurrentUser();
    if (currentUser != null) {
      await _firestore.collection('users').doc(currentUser.uid).delete();
      await currentUser.delete();
    }
  }
}
