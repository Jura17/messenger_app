import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_app/features/auth/bloc/auth_bloc.dart';

import 'package:messenger_app/features/auth/data/repositories/auth_repository.dart';

import 'package:messenger_app/features/auth/data/repositories/mock_auth_repository.dart';
import 'package:messenger_app/features/users/data/repositories/mock_userdata_repository.dart';
import 'package:messenger_app/features/users/data/repositories/userdata_repository.dart';

void main() {
  group('authentication tests', () {
    late AuthBloc authBloc;
    final AuthRepository mockAuthRepo = MockAuthRepository();
    final UserdataRepository mockUserdataRepo = MockUserdataRepository();

    setUp(() {
      authBloc = AuthBloc(
        authRepo: mockAuthRepo,
        userdataRepo: mockUserdataRepo,
      );
    });
  });
  testWidgets('auth bloc ...', (tester) async {
    // TODO: Implement test
  });
}
