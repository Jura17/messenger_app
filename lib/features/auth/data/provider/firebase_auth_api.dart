import 'package:firebase_auth/firebase_auth.dart';
import 'package:messenger_app/features/auth/data/provider/auth_api.dart';
import 'package:messenger_app/features/users/data/repositories/firestore_userdata_repository.dart';

class FirebaseAuthApi implements AuthApi {
  final FirebaseAuth auth;
  final FirestoreUserdataRepository userRepo;

  // accept mock auth & db for testing
  FirebaseAuthApi({FirebaseAuth? auth, FirestoreUserdataRepository? userRepo})
      : auth = auth ?? FirebaseAuth.instance,
        userRepo = userRepo ?? FirestoreUserdataRepository();

  @override
  Stream<User?> onAuthChanged() => auth.authStateChanges();

  @override
  User? getCurrentUser() {
    return auth.currentUser;
  }

  @override
  Future<User> signUpWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: email, password: password);
      // create firestore user
      userRepo.createUser(userCredential.user!.uid, email);
      return userCredential.user!;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  @override
  Future<User> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
      userRepo.updateLastLogin(userCredential.user!.uid);

      return userCredential.user!;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
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
      await userRepo.deleteAccount(currentUser.uid);
      await currentUser.delete();
    }
  }
}
