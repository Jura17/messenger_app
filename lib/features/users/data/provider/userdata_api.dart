import 'package:image_picker/image_picker.dart';
import 'package:messenger_app/features/auth/domain/entities/auth_user.dart';

import 'package:messenger_app/features/users/domain/entities/app_user_data.dart';

abstract class UserdataApi {
  Future<void> createUser(String uid, String username, String email);
  Stream<List<Map<String, dynamic>>> getAllUsersStream();
  Stream<List<String>> getBlockedUserIdsStream(AuthUser? currentUser);
  Stream<AppUserData?> watchUser(String uid);
  Future<AppUserData?> getUserById(String otherUserId);
  Future<void> saveProfileImage(XFile imageFile, AuthUser? currentUser);
  Future<void> updateOnlineStatus(String uid, bool isOnline);
  Future<void> blockUser(String uid, AuthUser? currentUser);
  Future<void> unblockUser(String uid, AuthUser? currentUser);
  Future<void> deleteAccount(AuthUser? currentUser);
}
