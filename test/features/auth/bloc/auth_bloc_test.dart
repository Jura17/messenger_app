import 'package:bloc_test/bloc_test.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:messenger_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:messenger_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:messenger_app/features/auth/data/models/mock_user.dart';
import 'package:messenger_app/features/auth/data/repositories/fake_auth_repository.dart';
import 'package:messenger_app/features/users/data/repositories/fake_userdata_repository.dart';

void main() {
  late FakeAuthRepository fakeAuthRepo;
  late FakeUserdataRepository fakeUserRepo;
  group(
    'auth bloc tests',
    () {
      setUp(() {
        fakeAuthRepo = FakeAuthRepository();
        fakeUserRepo = FakeUserdataRepository();
      });

      tearDown(() {
        fakeAuthRepo.dispose();
        fakeUserRepo.dispose();
      });

      blocTest<AuthBloc, AuthState>(
        'emit [Unauthenticated] when AppStarted and no user is signed in',
        build: () => AuthBloc(authRepo: fakeAuthRepo, userRepo: fakeUserRepo),
        act: (bloc) async {
          bloc.add(AppStarted());
          await Future.delayed(const Duration(milliseconds: 50));
          fakeAuthRepo.logout();
        },
        expect: () {
          return [isA<Unauthenticated>()];
        },
      );
      blocTest<AuthBloc, AuthState>(
        'emits [Authenticated] when AppStarted and user is signed in',
        build: () => AuthBloc(authRepo: fakeAuthRepo, userRepo: fakeUserRepo),
        act: (bloc) async {
          bloc.add(AppStarted());
          await Future.delayed(const Duration(milliseconds: 50));
          // simulate Firebase emitting a user
          await fakeAuthRepo.signIn('test@email.com', '123456');
        },
        expect: () => [isA<Authenticated>()],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [Unauthenticated] when LogoutRequested is added',
        build: () => AuthBloc(authRepo: fakeAuthRepo, userRepo: fakeUserRepo),
        act: (bloc) async {
          bloc.add(LogoutRequested());
          await Future.delayed(const Duration(milliseconds: 50));
        },
        expect: () => [isA<Unauthenticated>()],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [Unauthenticated] when DeletionRequested is added',
        build: () => AuthBloc(authRepo: fakeAuthRepo, userRepo: fakeUserRepo),
        act: (bloc) async {
          await fakeAuthRepo.signIn('test@email.com', '123456');
          await Future.delayed(const Duration(milliseconds: 50));

          bloc.add(DeletionRequested());
          await Future.delayed(const Duration(milliseconds: 50));
        },
        expect: () => [isA<Unauthenticated>()],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [Authenticated(needsReauthentication: true)] when re-authenticate is required on account deletion request',
        build: () {
          fakeAuthRepo.requiresRecentLogin = true;
          return AuthBloc(authRepo: fakeAuthRepo, userRepo: fakeUserRepo);
        },
        seed: () => Authenticated(MockUser(uid: '123', email: 'test@email.com')),
        act: (bloc) async {
          await fakeAuthRepo.signIn('test@email.com', '123456');
          await Future.delayed(const Duration(milliseconds: 50));
          bloc.add(DeletionRequested());
        },
        expect: () => [
          isA<Authenticated>().having(
            (s) => s.needsReauthentication,
            'needsReauthentication',
            true,
          ),
        ],
      );
    },
  );
}
