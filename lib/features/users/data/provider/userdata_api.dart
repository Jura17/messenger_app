import 'package:messenger_app/features/users/data/models/user_data.dart';

abstract class UserdataApi {
  Future<void> createUser(String uid, String email);
  Stream<List<Map<String, dynamic>>> getAllUsersStream();
  // Stream<List<Map<String, dynamic>>> getAllPermittedUsersStream();
  Stream<List<String>> getBlockedUserIdsStream();
  Future<Userdata?> getUser(String uid);
  Future<void> updateLastLogin();
  // Stream<List<Map<String, dynamic>>> getBlockedUsers(String uid);
  Future<void> blockUser(String uid);
  Future<void> unblockUser(String uid);
  Future<void> deleteAccount();
}
