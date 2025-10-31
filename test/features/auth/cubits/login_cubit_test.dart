import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_app/features/auth/cubits/login_cubit.dart';
import 'package:messenger_app/features/auth/data/repositories/mock_auth_repository.dart';
import 'package:messenger_app/features/users/data/repositories/mock_userdata_repository.dart';

void main() {
  group('login cubit tests', () {
    blocTest<LoginCubit, LoginState>(
      'emits [loading, success] when login succeeds',
      build: () {
        final mockAuthRepo = MockAuthRepository();
        final mockUserRepo = MockUserdataRepository();
        return LoginCubit(authRepo: mockAuthRepo, userdataRepo: mockUserRepo);
      },
      act: (cubit) async {
        cubit.emailChanged('test@email.com');
        cubit.passwordChanged('123456');
        await cubit.logIn();
      },
      expect: () {
        return [
          const LoginState(email: 'test@email.com', password: '', status: LoginStatus.initial),
          const LoginState(email: 'test@email.com', password: '123456', status: LoginStatus.initial),
          const LoginState(email: 'test@email.com', password: '123456', status: LoginStatus.loading),
          const LoginState(email: 'test@email.com', password: '123456', status: LoginStatus.success),
        ];
      },
    );

    blocTest<LoginCubit, LoginState>(
      'emits [loading, failure] when login fails',
      build: () {
        final mockAuthRepo = MockAuthRepository()..shouldFail = true;
        final mockUserRepo = MockUserdataRepository();
        return LoginCubit(authRepo: mockAuthRepo, userdataRepo: mockUserRepo);
      },
      act: (cubit) async {
        cubit.emailChanged('test@wrong-email.com');
        cubit.passwordChanged('123456');
        await cubit.logIn();
      },
      expect: () {
        return [
          const LoginState(email: 'test@wrong-email.com', password: '', status: LoginStatus.initial),
          const LoginState(email: 'test@wrong-email.com', password: '123456', status: LoginStatus.initial),
          const LoginState(email: 'test@wrong-email.com', password: '123456', status: LoginStatus.loading),
          const LoginState(
              email: 'test@wrong-email.com',
              password: '123456',
              status: LoginStatus.failure,
              errorMessage: 'Invalid credentials'),
        ];
      },
    );
    blocTest<LoginCubit, LoginState>(
      'emits [loading, failure] when login fails, due to empty fields',
      build: () {
        final mockAuthRepo = MockAuthRepository()..shouldFail = true;
        final mockUserRepo = MockUserdataRepository();
        return LoginCubit(authRepo: mockAuthRepo, userdataRepo: mockUserRepo);
      },
      act: (cubit) async {
        cubit.emailChanged('test@email.com');
        await cubit.logIn();
      },
      skip: 1,
      expect: () {
        return [
          const LoginState(
              email: 'test@email.com',
              password: '',
              status: LoginStatus.failure,
              errorMessage: 'Email and password cannot be empty.'),
        ];
      },
    );
    blocTest<LoginCubit, LoginState>(
      'emits [loading, failure] when login fails, due to unknown error',
      build: () {
        final mockAuthRepo = MockAuthRepository()..throwUnknownError = true;
        final mockUserRepo = MockUserdataRepository();
        return LoginCubit(authRepo: mockAuthRepo, userdataRepo: mockUserRepo);
      },
      act: (cubit) async {
        cubit.emailChanged('test@email.com');
        cubit.passwordChanged('123456');
        await cubit.logIn();
      },
      skip: 2,
      expect: () {
        return [
          const LoginState(
            email: 'test@email.com',
            password: '123456',
            status: LoginStatus.loading,
          ),
          predicate<LoginState>(
              (state) => state.status == LoginStatus.failure && state.errorMessage!.contains('Unexpected error: ')),
        ];
      },
    );
  });
}
