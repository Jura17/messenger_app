import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messenger_app/features/users/data/models/user_data.dart';
import 'package:messenger_app/features/users/data/provider/userdata_api.dart';

class FirestoreUserdataApi implements UserdataApi {
  final FirebaseFirestore firestoreDb;

  FirestoreUserdataApi(this.firestoreDb);

  @override
  Future<void> createUser(String uid, String email) async {
    final newUser = Userdata(uid: uid, email: email);
    await firestoreDb.collection('users').doc(uid).set(newUser.toMap());
  }

  @override
  Future<List<Userdata>> getAllUsers() async {
    final userDocs = await firestoreDb.collection('users').get();

    List<Userdata> users = [];

    for (var user in userDocs.docs) {
      users.add(Userdata.fromMap(user.data()));
    }
    return users;
  }

  @override
  Future<Userdata?> getUser(String uid) async {
    final userDoc = await firestoreDb.collection('users').doc(uid).get();

    if (userDoc.exists) {
      final data = userDoc.data();
      if (data != null) return Userdata.fromMap(data);
    }
    return null;
  }

  @override
  Future<void> updateLastLogin(String uid) {
    // TODO: implement updateLastLogin
    throw UnimplementedError();
  }
}
