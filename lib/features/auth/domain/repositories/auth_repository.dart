import 'package:messenger_app/features/auth/domain/entities/auth_user.dart';

abstract interface class AuthRepository {
  Stream<AuthUser?> onAuthChanged();
  AuthUser? getCurrentUser();
  Future<AuthUser> signIn(String email, String password);
  Future<AuthUser> signUp({required email, required username, required password});
  Future<void> reauthenticateUser(String email, String password);
  Future<void> deleteAccount();
  Future<void> logout();
}
