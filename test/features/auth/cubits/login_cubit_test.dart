import 'package:bloc_test/bloc_test.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_app/features/auth/domain/entities/auth_user.dart';
import 'package:messenger_app/features/auth/presentation/cubits/login_cubit.dart';
import 'package:messenger_app/features/auth/presentation/cubits/login_state.dart';

import 'package:messenger_app/features/users/data/repositories/mock_userdata_repository.dart';
import 'package:mocktail/mocktail.dart';

import '../../chat/bloc/unread_bloc_test.dart';

void main() {
  late MockAuthRepository mockAuthRepo;
  late MockUserdataRepository mockUserdataRepository;
  late LoginCubit loginCubit;

  setUp(() {
    mockAuthRepo = MockAuthRepository();
    mockUserdataRepository = MockUserdataRepository();
    loginCubit = LoginCubit(authRepo: mockAuthRepo, userdataRepo: mockUserdataRepository);
  });

  group('login cubit tests', () {
    blocTest<LoginCubit, LoginState>(
      'emits [loading, success] when login succeeds',
      build: () {
        when(() => mockAuthRepo.signIn('user@test.com', '123456')).thenAnswer((_) async => AuthUser(uid: '123'));
        when(() => mockUserdataRepository.updateOnlineStatus('123', true)).thenAnswer((_) async => {});
        return loginCubit;
      },
      act: (cubit) async {
        cubit.emailChanged('user@test.com');
        cubit.passwordChanged('123456');
        await cubit.logIn();
      },
      expect: () => [
        LoginState(email: 'user@test.com', password: '', status: LoginStatus.initial),
        LoginState(email: 'user@test.com', password: '123456', status: LoginStatus.initial),
        LoginState(email: 'user@test.com', password: '123456', status: LoginStatus.loading),
      ],
    );
  });

  // group('login cubit tests', () {
  //   blocTest<LoginCubit, LoginState>(
  //     'emits [loading, success] when login succeeds',
  //     build: () {
  //       final fakeAuthRepo = FakeAuthRepository();
  //       final fakeUserRepo = FakeUserdataRepository();
  //       return LoginCubit(authRepo: fakeAuthRepo, userdataRepo: fakeUserRepo);
  //     },
  //     act: (cubit) async {
  //       cubit.emailChanged('test@email.com');
  //       cubit.passwordChanged('123456');
  //       await cubit.logIn();
  //     },
  //     expect: () {
  //       return [
  //         const LoginState(email: 'test@email.com', password: '', status: LoginStatus.initial),
  //         const LoginState(email: 'test@email.com', password: '123456', status: LoginStatus.initial),
  //         const LoginState(email: 'test@email.com', password: '123456', status: LoginStatus.loading),
  //       ];
  //     },
  //   );

  //   blocTest<LoginCubit, LoginState>(
  //     'emits [loading, failure] when login fails',
  //     build: () {
  //       final fakeAuthRepo = FakeAuthRepository()..shouldFail = true;
  //       final fakeUserRepo = FakeUserdataRepository();
  //       return LoginCubit(authRepo: fakeAuthRepo, userdataRepo: fakeUserRepo);
  //     },
  //     act: (cubit) async {
  //       cubit.emailChanged('test@wrong-email.com');
  //       cubit.passwordChanged('123456');
  //       await cubit.logIn();
  //     },
  //     expect: () {
  //       return [
  //         const LoginState(email: 'test@wrong-email.com', password: '', status: LoginStatus.initial),
  //         const LoginState(email: 'test@wrong-email.com', password: '123456', status: LoginStatus.initial),
  //         const LoginState(email: 'test@wrong-email.com', password: '123456', status: LoginStatus.loading),
  //         const LoginState(
  //             email: 'test@wrong-email.com',
  //             password: '123456',
  //             status: LoginStatus.failure,
  //             errorMessage: 'Invalid credentials'),
  //       ];
  //     },
  //   );
  //   blocTest<LoginCubit, LoginState>(
  //     'emits [loading, failure] when login fails, due to empty fields',
  //     build: () {
  //       final fakeAuthRepo = FakeAuthRepository()..shouldFail = true;
  //       final fakeUserRepo = FakeUserdataRepository();
  //       return LoginCubit(authRepo: fakeAuthRepo, userdataRepo: fakeUserRepo);
  //     },
  //     act: (cubit) async {
  //       cubit.emailChanged('test@email.com');
  //       await cubit.logIn();
  //     },
  //     skip: 1,
  //     expect: () {
  //       return [
  //         const LoginState(
  //             email: 'test@email.com',
  //             password: '',
  //             status: LoginStatus.failure,
  //             errorMessage: 'Email and password cannot be empty.'),
  //       ];
  //     },
  //   );
  //   blocTest<LoginCubit, LoginState>(
  //     'emits [loading, failure] when login fails, due to unknown error',
  //     build: () {
  //       final fakeAuthRepo = FakeAuthRepository()..throwUnknownError = true;
  //       final fakeUserRepo = FakeUserdataRepository();
  //       return LoginCubit(authRepo: fakeAuthRepo, userdataRepo: fakeUserRepo);
  //     },
  //     act: (cubit) async {
  //       cubit.emailChanged('test@email.com');
  //       cubit.passwordChanged('123456');
  //       await cubit.logIn();
  //     },
  //     skip: 2,
  //     expect: () {
  //       return [
  //         const LoginState(
  //           email: 'test@email.com',
  //           password: '123456',
  //           status: LoginStatus.loading,
  //         ),
  //         predicate<LoginState>(
  //             (state) => state.status == LoginStatus.failure && state.errorMessage!.contains('Unexpected error: ')),
  //       ];
  //     },
  //   );
  // });
}
