import 'package:image_picker/image_picker.dart';
import 'package:messenger_app/features/auth/domain/entities/auth_user.dart';
import 'package:messenger_app/features/users/data/models/user_data.dart';

abstract interface class UserdataRepository {
  Future<void> createUser(String uid, String username, String email);
  Stream<List<Userdata>> getAllPermittedUsersStream(AuthUser? currentUser);
  Future<Userdata?> getUserById(String uid);
  Stream<Userdata?> watchCurrentUser(String uid);
  Future<void> saveProfileImage(XFile imageFile, AuthUser? currentUser);
  Future<void> updateOnlineStatus(String uid, bool onlineStatus);
  Stream<List<Userdata>> getBlockedUsersStream(AuthUser? currentUser);
  Future<void> blockUser(String otherUserId, AuthUser? currentUser);
  Future<void> unblockUser(String otherUserId, AuthUser? currentUser);
  Future<void> deleteAccount(AuthUser? currentUser);
}
