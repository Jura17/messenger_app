import 'package:firebase_auth/firebase_auth.dart';
import 'package:messenger_app/features/users/data/models/user_data.dart';

abstract class UserdataRepository {
  Future<void> createUser(String uid, String username, String email);
  Stream<List<Userdata>> getAllPermittedUsersStream(User? currentUser);
  Future<Userdata?> getUserById(String uid);
  Future<void> updateLastLogin(String uid);
  Stream<List<Userdata>> getBlockedUsersStream(User? currentUser);
  Future<void> blockUser(String otherUserId, User? currentUser);
  Future<void> unblockUser(String otherUserId, User? currentUser);
  Future<void> deleteAccount(User? currentUser);
}
