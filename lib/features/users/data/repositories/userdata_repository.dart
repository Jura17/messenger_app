import 'package:messenger_app/features/users/data/models/user_data.dart';

abstract class UserdataRepository {
  Future<void> createUser(String uid, String email);
  Stream<List<Userdata>> getAllPermittedUsersStream();
  // Stream<List<Userdata>> getAllPermittedUsersStreamWithUnreadCount();
  Future<Userdata?> getUser(String uid);
  Future<void> updateLastLogin(String uid);
  Stream<List<Userdata>> getBlockedUsersStream();
  // Future<void> markMessagesAsRead(String receiverId);
  Future<void> blockUser(String uid);
  Future<void> unblockUser(String uid);
  Future<void> deleteAccount();
}
