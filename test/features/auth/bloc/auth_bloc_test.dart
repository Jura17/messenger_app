import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_app/features/auth/bloc/auth_bloc.dart';
import 'package:messenger_app/features/auth/cubits/login_cubit.dart';
import 'package:messenger_app/features/auth/cubits/sign_up_cubit.dart';

import 'package:messenger_app/features/auth/data/repositories/auth_repository.dart';

import 'package:messenger_app/features/auth/data/repositories/mock_auth_repository.dart';
import 'package:messenger_app/features/users/data/repositories/mock_userdata_repository.dart';
import 'package:messenger_app/features/users/data/repositories/userdata_repository.dart';

void main() {
  group('authentication tests', () {
    late AuthRepository mockAuthRepo;
    late UserdataRepository mockUserdataRepo;
    late AuthBloc authBloc;
    late LoginCubit loginCubit;
    late SignUpCubit signUpCubit;

    setUp(() {
      mockAuthRepo = MockAuthRepository();
      mockUserdataRepo = MockUserdataRepository();

      authBloc = AuthBloc(authRepo: mockAuthRepo, userRepo: mockUserdataRepo);
      loginCubit = LoginCubit(authRepo: mockAuthRepo, userdataRepo: mockUserdataRepo);
      signUpCubit = SignUpCubit(authRepo: mockAuthRepo, userdataRepo: mockUserdataRepo);
    });

    tearDown(() async {
      await authBloc.close();
      await loginCubit.close();
      await signUpCubit.close();
    });

    // test('description', body)
  });
  testWidgets('auth bloc ...', (tester) async {
    // TODO: Implement test
  });
}
