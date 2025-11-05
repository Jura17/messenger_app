import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_app/features/auth/bloc/auth_bloc.dart';
import 'package:messenger_app/features/auth/bloc/auth_event.dart';
import 'package:messenger_app/features/auth/bloc/auth_state.dart';
import 'package:messenger_app/features/auth/data/repositories/mock_auth_repository.dart';
import 'package:messenger_app/features/users/data/repositories/mock_userdata_repository.dart';

void main() {
  late MockAuthRepository mockAuthRepo;
  late MockUserdataRepository mockUserRepo;
  group(
    'auth bloc tests',
    () {
      setUp(() {
        mockAuthRepo = MockAuthRepository();
        mockUserRepo = MockUserdataRepository();
      });

      tearDown(() {
        mockAuthRepo.dispose();
        mockUserRepo.dispose();
      });

      blocTest<AuthBloc, AuthState>(
        'emit [Unauthenticated] when AppStarted and no user is signed in',
        build: () => AuthBloc(authRepo: mockAuthRepo, userRepo: mockUserRepo),
        act: (bloc) async {
          bloc.add(AppStarted());
          await Future.delayed(const Duration(milliseconds: 50));
          mockAuthRepo.logout();
        },
        expect: () {
          return [isA<Unauthenticated>()];
        },
      );
      blocTest<AuthBloc, AuthState>(
        'emits [Authenticated] when AppStarted and user is signed in',
        build: () => AuthBloc(authRepo: mockAuthRepo, userRepo: mockUserRepo),
        act: (bloc) async {
          bloc.add(AppStarted());
          await Future.delayed(const Duration(milliseconds: 50));
          // simulate Firebase emitting a user
          await mockAuthRepo.signIn('test@email.com', '123456');
        },
        expect: () => [isA<Authenticated>()],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [Unauthenticated] when LogoutRequested is added',
        build: () => AuthBloc(authRepo: mockAuthRepo, userRepo: mockUserRepo),
        act: (bloc) async {
          bloc.add(LogoutRequested());
          await Future.delayed(const Duration(milliseconds: 50));
        },
        expect: () => [isA<Unauthenticated>()],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [Unauthenticated when DeletionRequested is added]',
        build: () => AuthBloc(authRepo: mockAuthRepo, userRepo: mockUserRepo),
        act: (bloc) async {
          await mockAuthRepo.signIn('test@email.com', '123456');
          await Future.delayed(const Duration(milliseconds: 50));

          bloc.add(DeletionRequested());
          await Future.delayed(const Duration(milliseconds: 50));
        },
        expect: () => [isA<Unauthenticated>()],
      );
    },
  );
}
