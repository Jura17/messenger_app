import 'package:messenger_app/features/auth/data/models/userdata.dart';

abstract class UserdataRepository {
  Future<void> createUser(String uid, String email);
  Future<void> updateLastLogin(String uid);
  Future<Userdata?> getUser(String uid);
  Future<List<Userdata>> getAllUsers();
}
