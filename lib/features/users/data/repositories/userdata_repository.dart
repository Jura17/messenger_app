import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messenger_app/features/users/data/models/user_data.dart';

abstract class UserdataRepository {
  Future<void> createUser(String uid, String username, String email);
  Stream<List<Userdata>> getAllPermittedUsersStream(User? currentUser);
  Future<Userdata?> getUserById(String uid);
  Stream<Userdata?> watchCurrentUser(String uid);
  Future<void> saveProfileImage(XFile imageFile, User? currentUser);
  Future<void> updateOnlineStatus(String uid, bool onlineStatus);
  Stream<List<Userdata>> getBlockedUsersStream(User? currentUser);
  Future<void> blockUser(String otherUserId, User? currentUser);
  Future<void> unblockUser(String otherUserId, User? currentUser);
  Future<void> deleteAccount(User? currentUser);
}
