import 'package:messenger_app/features/auth/data/models/user_data.dart';

abstract class UserdataRepository {
  Future<void> createUser(String uid, String email);
  Future<void> updateLastLogin(String uid);
  Future<Userdata?> getUser(String uid);
  Future<List<Userdata>> getAllUsers();
  Future<void> deleteAccount(String uid);
}
