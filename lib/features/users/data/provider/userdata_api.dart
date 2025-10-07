import 'package:messenger_app/features/users/data/models/user_data.dart';

abstract class UserdataApi {
  Future<void> createUser(String uid, String email);
  Future<List<Userdata>> getAllUsers(); // not sure if really needed
  Future<Userdata?> getUser(String uid);
  Future<void> updateLastLogin(String uid);
}
