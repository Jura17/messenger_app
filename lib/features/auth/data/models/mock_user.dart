import 'package:messenger_app/features/auth/domain/entities/auth_user.dart';
import 'package:mocktail/mocktail.dart';

class MockUser extends Mock implements AuthUser {
  @override
  final String uid;
  @override
  final String? email;

  MockUser({required this.uid, required this.email});
}
