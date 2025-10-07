import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messenger_app/features/users/data/models/user_data.dart';
import 'package:messenger_app/features/users/data/repositories/userdata_repository.dart';

class FirestoreUserdataRepository implements UserdataRepository {
  final FirebaseFirestore firestoreDb;

  // accept mock db for testing
  FirestoreUserdataRepository({FirebaseFirestore? firestoreDb})
      : firestoreDb = firestoreDb ?? FirebaseFirestore.instance;

  @override
  Future<void> createUser(String uid, String email) async {}

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

  @override
  Future<void> deleteAccount(String uid) async {
    await firestoreDb.collection('users').doc(uid).delete();
  }
}
