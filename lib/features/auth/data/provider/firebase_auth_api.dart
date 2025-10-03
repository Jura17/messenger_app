import 'package:firebase_auth/firebase_auth.dart';
import 'package:messenger_app/features/auth/data/provider/auth_api.dart';
import 'package:messenger_app/features/auth/data/repositories/firestore_userdata_repository.dart';

class FirebaseAuthApi extends AuthApi {
  final FirebaseAuth auth;
  final FirestoreUserdataRepository userRepo;

  FirebaseAuthApi({required this.auth, required this.userRepo});

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
      // create firestore user
      userRepo.createUser(userCredential.user!.uid, email);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  @override
  Future<UserCredential> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
      userRepo.updateLastLogin(userCredential.user!.uid);

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
