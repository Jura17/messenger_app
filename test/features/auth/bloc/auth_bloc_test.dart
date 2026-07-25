import 'package:bloc_test/bloc_test.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_app/features/auth/domain/auth_exceptions.dart';
import 'package:messenger_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:messenger_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:messenger_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:messenger_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:messenger_app/features/auth/data/models/mock_user.dart';

import 'package:messenger_app/features/users/domain/repositories/userdata_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockUserdataRepository extends Mock implements UserdataRepository {}

void main() {
  late MockAuthRepository mockAuthRepo;
  late MockUserdataRepository mockUserdataRepo;
  late AuthBloc authBloc;
  final mockUser = MockUser(email: 'user@test.com', uid: '123');

  setUp(() {
    mockAuthRepo = MockAuthRepository();
    mockUserdataRepo = MockUserdataRepository();
    authBloc = AuthBloc(authRepo: mockAuthRepo, userRepo: mockUserdataRepo);
  });

  tearDown(() => authBloc.close());

  blocTest<AuthBloc, AuthState>(
    'emit [Unauthenticated] when AppStarted and no user is signed in',
    build: () {
      // When the app starts we have no user and (due to the empty mock repo object) no stream
      when(() => mockAuthRepo.onAuthChanged()).thenAnswer((_) => Stream.value(null));
      return authBloc;
    },
    act: (bloc) => bloc.add(AppStarted()),
    expect: () => [Unauthenticated()],
  );

  blocTest<AuthBloc, AuthState>(
    'emits [Authenticated] when AppStarted and user is signed in',
    build: () {
      when(() => mockAuthRepo.onAuthChanged()).thenAnswer((_) => Stream.value(mockUser));
      return authBloc;
    },
    act: (bloc) => bloc.add(AppStarted()),
    expect: () => [Authenticated(mockUser)],
  );

  blocTest<AuthBloc, AuthState>(
    'emits [Unauthenticated] when LogoutRequested is added',
    build: () {
      // since only _authRepo.logout() is called inside _onLogoutRequested() we only need to stub that
      when(() => mockAuthRepo.logout()).thenAnswer((_) async {});
      return authBloc;
    },
    act: (bloc) => bloc.add(LogoutRequested()),
    expect: () => [Unauthenticated()],
  );

  blocTest(
    'emits [Unauthenticated] when DeletionRequested is added',
    build: () {
      when(() => mockAuthRepo.getCurrentUser()).thenReturn(mockUser);
      when(() => mockAuthRepo.deleteAccount()).thenAnswer((_) async => {});
      when(() => mockUserdataRepo.deleteAccount(mockUser)).thenAnswer((_) async => {});
      return authBloc;
    },
    act: (bloc) => bloc.add(DeletionRequested()),
    expect: () => [Unauthenticated()],
  );

  blocTest<AuthBloc, AuthState>(
    'emits [Authenticated(needsReauthentication: true)] when re-authenticate is required on account deletion request',
    seed: () => Authenticated(mockUser),
    build: () {
      // use thenReturn instead of thenAnswer when the answer is synchronous
      when(() => mockAuthRepo.getCurrentUser()).thenReturn(mockUser);
      when(() => mockAuthRepo.deleteAccount()).thenThrow(RequiresRecentLoginException());
      return authBloc;
    },
    act: (bloc) => bloc.add(DeletionRequested()),
    expect: () => [Authenticated(mockUser, needsReauthentication: true)],
  );
  // late FakeAuthRepository fakeAuthRepo;
  // late FakeUserdataRepository fakeUserRepo;
  // group(
  //   'auth bloc tests',
  //   () {
  //     setUp(() {
  //       fakeAuthRepo = FakeAuthRepository();
  //       fakeUserRepo = FakeUserdataRepository();
  //     });

  //     tearDown(() {
  //       fakeAuthRepo.dispose();
  //       fakeUserRepo.dispose();
  //     });

  //     blocTest<AuthBloc, AuthState>(
  //       'emit [Unauthenticated] when AppStarted and no user is signed in',
  //       build: () => AuthBloc(authRepo: fakeAuthRepo, userRepo: fakeUserRepo),
  //       act: (bloc) async {
  //         bloc.add(AppStarted());
  //         await Future.delayed(const Duration(milliseconds: 50));
  //         fakeAuthRepo.logout();
  //       },
  //       expect: () {
  //         return [isA<Unauthenticated>()];
  //       },
  //     );
  //     blocTest<AuthBloc, AuthState>(
  //       'emits [Authenticated] when AppStarted and user is signed in',
  //       build: () => AuthBloc(authRepo: fakeAuthRepo, userRepo: fakeUserRepo),
  //       act: (bloc) async {
  //         bloc.add(AppStarted());
  //         await Future.delayed(const Duration(milliseconds: 50));
  //         // simulate Firebase emitting a user
  //         await fakeAuthRepo.signIn('test@email.com', '123456');
  //       },
  //       expect: () => [isA<Authenticated>()],
  //     );

  //     blocTest<AuthBloc, AuthState>(
  //       'emits [Unauthenticated] when LogoutRequested is added',
  //       build: () => AuthBloc(authRepo: fakeAuthRepo, userRepo: fakeUserRepo),
  //       act: (bloc) async {
  //         bloc.add(LogoutRequested());
  //         await Future.delayed(const Duration(milliseconds: 50));
  //       },
  //       expect: () => [isA<Unauthenticated>()],
  //     );

  //     blocTest<AuthBloc, AuthState>(
  //       'emits [Unauthenticated] when DeletionRequested is added',
  //       build: () => AuthBloc(authRepo: fakeAuthRepo, userRepo: fakeUserRepo),
  //       act: (bloc) async {
  //         await fakeAuthRepo.signIn('test@email.com', '123456');
  //         await Future.delayed(const Duration(milliseconds: 50));

  //         bloc.add(DeletionRequested());
  //         await Future.delayed(const Duration(milliseconds: 50));
  //       },
  //       expect: () => [isA<Unauthenticated>()],
  //     );

  //     blocTest<AuthBloc, AuthState>(
  //       'emits [Authenticated(needsReauthentication: true)] when re-authenticate is required on account deletion request',
  //       build: () {
  //         fakeAuthRepo.requiresRecentLogin = true;
  //         return AuthBloc(authRepo: fakeAuthRepo, userRepo: fakeUserRepo);
  //       },
  //       seed: () => Authenticated(MockUser(uid: '123', email: 'test@email.com')),
  //       act: (bloc) async {
  //         await fakeAuthRepo.signIn('test@email.com', '123456');
  //         await Future.delayed(const Duration(milliseconds: 50));
  //         bloc.add(DeletionRequested());
  //       },
  //       expect: () => [
  //         isA<Authenticated>().having(
  //           (s) => s.needsReauthentication,
  //           'needsReauthentication',
  //           true,
  //         ),
  //       ],
  //     );
  //   },
  // );
}
