import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_app/features/auth/domain/entities/auth_user.dart';

import 'package:messenger_app/features/auth/presentation/cubits/sign_up_cubit.dart';
import 'package:messenger_app/features/auth/presentation/cubits/sign_up_state.dart';
import 'package:messenger_app/features/auth/data/repositories/fake_auth_repository.dart';
import 'package:messenger_app/features/users/data/repositories/fake_userdata_repository.dart';
import 'package:messenger_app/features/users/data/repositories/mock_userdata_repository.dart';
import 'package:mocktail/mocktail.dart';

import '../../chat/bloc/unread_bloc_test.dart';

void main() {
  late MockAuthRepository mockAuthRepository;
  late MockUserdataRepository mockUserdataRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockUserdataRepository = MockUserdataRepository();
  });

  group(
    'sign up cubit tests',
    () {
      blocTest<SignUpCubit, SignUpState>(
        'emit [initial, loading] when sign-up succeeds',
        build: () {
          when(() => mockAuthRepository.signUp(email: 'user@test.com', username: 'John Test', password: '123456'))
              .thenAnswer((_) async => AuthUser(uid: '123'));
          when(() => mockUserdataRepository.createUser('123', 'John Test', 'user@test.com'))
              .thenAnswer((_) async => {});
          return SignUpCubit(authRepo: mockAuthRepository, userdataRepo: mockUserdataRepository);
        },
        act: (cubit) async {
          cubit.emailChanged('user@test.com');
          cubit.usernameChanged('John Test');
          cubit.passwordChanged('123456');
          cubit.confirmPasswordChanged('123456');
          await cubit.signUp();
        },
        expect: () => [
          SignUpState(email: 'user@test.com'),
          SignUpState(email: 'user@test.com', username: 'John Test'),
          SignUpState(email: 'user@test.com', username: 'John Test', password: '123456'),
          SignUpState(email: 'user@test.com', username: 'John Test', password: '123456', confirmPassword: '123456'),
          SignUpState(
            email: 'user@test.com',
            username: 'John Test',
            password: '123456',
            confirmPassword: '123456',
            status: SignUpStatus.loading,
          ),
        ],
      );
    },
  );
  // group('sign up cubit tests', () {
  //   blocTest<SignUpCubit, SignUpState>(
  //     'emits [loading, success] when signing up succeeds',
  //     build: () {
  //       final mockAuthRepo = FakeAuthRepository();
  //       final mockUserRepo = FakeUserdataRepository();
  //       final signUpCubit = SignUpCubit(authRepo: mockAuthRepo, userdataRepo: mockUserRepo);
  //       return signUpCubit;
  //     },
  //     act: (cubit) async {
  //       cubit.emailChanged('test@mail.com');
  //       cubit.passwordChanged('123456');
  //       cubit.confirmPasswordChanged('123456');
  //       await cubit.signUp();
  //     },
  //     skip: 3,
  //     expect: () {
  //       return [
  //         const SignUpState(
  //             email: 'test@mail.com', password: '123456', confirmPassword: '123456', status: SignUpStatus.loading),
  //       ];
  //     },
  //   );

  //   blocTest(
  //     'emits [loading, failure] when signing up fails due to invalid credentials',
  //     build: () {
  //       final mockAuthRepo = FakeAuthRepository()..shouldFail = true;
  //       final mockUserRepo = FakeUserdataRepository();
  //       final signUpCubit = SignUpCubit(authRepo: mockAuthRepo, userdataRepo: mockUserRepo);
  //       return signUpCubit;
  //     },
  //     act: (cubit) async {
  //       cubit.emailChanged('wrong@mail.com');
  //       cubit.passwordChanged('123456');
  //       cubit.confirmPasswordChanged('123456');
  //       await cubit.signUp();
  //     },
  //     skip: 3,
  //     expect: () {
  //       return [
  //         const SignUpState(
  //           email: 'wrong@mail.com',
  //           password: '123456',
  //           confirmPassword: '123456',
  //           status: SignUpStatus.loading,
  //         ),
  //         const SignUpState(
  //           email: 'wrong@mail.com',
  //           password: '123456',
  //           confirmPassword: '123456',
  //           status: SignUpStatus.failure,
  //           errorMessage: 'Invalid credentials',
  //         ),
  //       ];
  //     },
  //   );
  //   blocTest(
  //     'emits [loading, failure] when signing up fails due to not matching passwords',
  //     build: () {
  //       final mockAuthRepo = FakeAuthRepository()..shouldFail = true;
  //       final mockUserRepo = FakeUserdataRepository();
  //       final signUpCubit = SignUpCubit(authRepo: mockAuthRepo, userdataRepo: mockUserRepo);
  //       return signUpCubit;
  //     },
  //     act: (cubit) async {
  //       cubit.emailChanged('wrong@mail.com');
  //       cubit.passwordChanged('123456');
  //       cubit.confirmPasswordChanged('1234567');
  //       await cubit.signUp();
  //     },
  //     skip: 2,
  //     expect: () {
  //       return [
  //         const SignUpState(
  //           email: 'wrong@mail.com',
  //           password: '123456',
  //           confirmPassword: '1234567',
  //           status: SignUpStatus.initial,
  //         ),
  //         const SignUpState(
  //           email: 'wrong@mail.com',
  //           password: '123456',
  //           confirmPassword: '1234567',
  //           status: SignUpStatus.failure,
  //           errorMessage: 'Passwords do not match.',
  //         ),
  //       ];
  //     },
  //   );
  //   blocTest(
  //     'emits [loading, failure] when signing up fails due to empty fields',
  //     build: () {
  //       final mockAuthRepo = FakeAuthRepository()..shouldFail = true;
  //       final mockUserRepo = FakeUserdataRepository();
  //       final signUpCubit = SignUpCubit(authRepo: mockAuthRepo, userdataRepo: mockUserRepo);
  //       return signUpCubit;
  //     },
  //     act: (cubit) async {
  //       cubit.passwordChanged('123456');
  //       cubit.confirmPasswordChanged('123456');
  //       await cubit.signUp();
  //     },
  //     skip: 1,
  //     expect: () {
  //       return [
  //         const SignUpState(
  //           email: '',
  //           password: '123456',
  //           confirmPassword: '123456',
  //           status: SignUpStatus.initial,
  //         ),
  //         const SignUpState(
  //           email: '',
  //           password: '123456',
  //           confirmPassword: '123456',
  //           status: SignUpStatus.failure,
  //           errorMessage: 'Email and password cannot be empty.',
  //         ),
  //       ];
  //     },
  //   );
  //   blocTest<SignUpCubit, SignUpState>(
  //     'emits [loading, failure] when signing up fails, due to unknown error',
  //     build: () {
  //       final mockAuthRepo = FakeAuthRepository()..throwUnknownError = true;
  //       final mockUserRepo = FakeUserdataRepository();
  //       return SignUpCubit(authRepo: mockAuthRepo, userdataRepo: mockUserRepo);
  //     },
  //     act: (cubit) async {
  //       cubit.emailChanged('test@email.com');
  //       cubit.passwordChanged('123456');
  //       cubit.confirmPasswordChanged('123456');
  //       await cubit.signUp();
  //     },
  //     skip: 3,
  //     expect: () {
  //       return [
  //         const SignUpState(
  //           email: 'test@email.com',
  //           password: '123456',
  //           confirmPassword: '123456',
  //           status: SignUpStatus.loading,
  //         ),
  //         predicate<SignUpState>(
  //             (state) => state.status == SignUpStatus.failure && state.errorMessage!.contains('Unexpected error: ')),
  //       ];
  //     },
  //   );
  // });
}
