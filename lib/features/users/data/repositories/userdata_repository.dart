import 'package:messenger_app/features/users/data/models/user_data.dart';

abstract class UserdataRepository {
  Future<void> createUser(String uid, String email);
  Stream<List<Userdata>> getAllPermittedUsers();
  Future<Userdata?> getUser(String uid);
  Future<void> updateLastLogin(String uid);
  // Stream<List<Userdata>> getBlockedUsers(String uid);
  Future<void> blockUser(String uid);
  Future<void> unblockUser(String uid);
  Future<void> deleteAccount();
}
