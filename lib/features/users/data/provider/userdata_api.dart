import 'package:firebase_auth/firebase_auth.dart';
import 'package:messenger_app/features/users/data/models/user_data.dart';

abstract class UserdataApi {
  Future<void> createUser(String uid, String username, String email);
  Stream<List<Map<String, dynamic>>> getAllUsersStream();
  Stream<List<String>> getBlockedUserIdsStream(User? currentUser);
  Stream<Userdata?> watchCurrentUser(String uid);
  Future<Userdata?> getUserById(String otherUserId);
  Future<String?> getProfileImage(String uid);
  Future<void> updateUser(String uid, Userdata updatedUser);
  Future<void> updateOnlineStatus(String uid, bool isOnline);
  Future<void> blockUser(String uid, User? currentUser);
  Future<void> unblockUser(String uid, User? currentUser);
  Future<void> deleteAccount(User? currentUser);
}
