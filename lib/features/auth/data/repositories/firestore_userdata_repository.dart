import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messenger_app/features/auth/data/models/userdata.dart';
import 'package:messenger_app/features/auth/data/repositories/userdata_repository.dart';

class FirestoreUserdataRepository implements UserdataRepository {
  FirestoreUserdataRepository(this._firestoreDb);

  final FirebaseFirestore _firestoreDb;

  @override
  Future<void> createUser(String uid, String email) async {
    final newUser = Userdata(uid: uid, email: email);
    await _firestoreDb.collection('users').doc(uid).set(newUser.toMap());
  }

  @override
  Future<List<Userdata>> getAllUsers() {
    // TODO: implement getAllUsers
    throw UnimplementedError();
  }

  @override
  Future<Userdata?> getUser(String uid) {
    // TODO: implement getUser
    throw UnimplementedError();
  }

  @override
  Future<void> updateLastLogin(String uid) {
    // TODO: implement updateLastLogin
    throw UnimplementedError();
  }
}
