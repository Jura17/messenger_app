import 'package:firebase_auth/firebase_auth.dart';
import 'package:messenger_app/features/users/data/models/user_data.dart';
import 'package:messenger_app/features/users/data/repositories/userdata_repository.dart';

class MockUserdataRepository implements UserdataRepository {
  @override
  Future<void> blockUser(String uid) {
    // TODO: implement blockUser
    throw UnimplementedError();
  }

  @override
  Future<void> createUser(String uid, String email) {
    // TODO: implement createUser
    throw UnimplementedError();
  }

  @override
  Future<void> deleteAccount() {
    // TODO: implement deleteAccount
    throw UnimplementedError();
  }

  @override
  Stream<List<Userdata>> getAllPermittedUsersStream(User? currentUser) {
    // TODO: implement getAllPermittedUsersStream
    throw UnimplementedError();
  }

  @override
  Stream<List<Userdata>> getBlockedUsersStream(User? currentUser) {
    // TODO: implement getBlockedUsersStream
    throw UnimplementedError();
  }

  @override
  Future<Userdata?> getUser(String uid) {
    // TODO: implement getUser
    throw UnimplementedError();
  }

  @override
  Future<void> unblockUser(String uid) {
    // TODO: implement unblockUser
    throw UnimplementedError();
  }

  @override
  Future<void> updateLastLogin(String uid) {
    // TODO: implement updateLastLogin
    throw UnimplementedError();
  }
}
