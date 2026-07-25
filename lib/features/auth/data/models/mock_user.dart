import 'package:messenger_app/features/auth/domain/entities/auth_user.dart';

class MockUser implements AuthUser {
  @override
  final String uid;
  @override
  final String? email;

  MockUser({required this.uid, required this.email});
}
