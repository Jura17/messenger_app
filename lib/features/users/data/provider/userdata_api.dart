import 'package:firebase_auth/firebase_auth.dart';
import 'package:messenger_app/features/users/data/models/user_data.dart';

abstract class UserdataApi {
  Future<void> createUser(String uid, String username, String email);
  Stream<List<Map<String, dynamic>>> getAllUsersStream();
  Stream<List<String>> getBlockedUserIdsStream(User? currentUser);
  Future<Userdata?> getUser(String otherUserId);
  Future<void> updateLastLogin(String otherUserId);
  Future<void> blockUser(String uid, User? currentUser);
  Future<void> unblockUser(String uid, User? currentUser);
  Future<void> deleteAccount(User? currentUser);
}
