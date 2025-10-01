import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:messenger_app/features/auth/data/provider/auth_api.dart';

class FirebaseAuthApi extends AuthApi {
  final FirebaseAuth auth;
  final FirebaseFirestore db;

  FirebaseAuthApi({
    required this.auth,
    required this.db,
  });

  @override
  Stream<User?> onAuthChanged() => auth.authStateChanges();

  @override
  User? getCurrentUser() {
    return auth.currentUser;
  }

  @override
  Future<UserCredential> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);

      db.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  @override
  Future<UserCredential> signUpWithEmailPassword({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: email, password: password);

      db.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        // 'username': userCredential.user!.displayName,
        'email': email,
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  @override
  Future<void> signOut() async {
    return await auth.signOut();
  }
}
