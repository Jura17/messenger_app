import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_app/features/users/bloc/user_bloc.dart';
import 'package:messenger_app/features/users/bloc/user_event.dart';
import 'package:messenger_app/features/users/bloc/user_state.dart';

import 'package:messenger_app/features/auth/data/repositories/mock_auth_repository.dart';
import 'package:messenger_app/features/users/data/repositories/mock_userdata_repository.dart';

void main() {
  late MockAuthRepository mockAuthRepo;
  late MockUserdataRepository mockUserRepo;
  late UserBloc userBloc;

  setUp(() async {
    mockAuthRepo = MockAuthRepository();
    mockUserRepo = MockUserdataRepository();
    userBloc = UserBloc(authRepo: mockAuthRepo, userRepo: mockUserRepo);

    // Populate the mock DB
    await mockUserRepo.createUser('main_uid', 'main@test.com');
    await mockUserRepo.createUser('user_a', 'a@test.com');
    await mockUserRepo.createUser('user_b', 'b@test.com');

    // Sign in a mock user
    await mockAuthRepo.signIn('main@test.com', '123456');
  });

  tearDown(() {
    mockUserRepo.dispose();
    userBloc.close();
  });

  blocTest<UserBloc, UserState>(
    'emits [UsersLoading, UsersLoaded] with all permitted users when WatchUsers is added',
    build: () => userBloc,
    act: (bloc) => bloc.add(WatchUsers()),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      isA<UsersLoading>(),
      isA<UsersLoaded>().having(
        (stream) => stream.permittedUsers.map((user) => user.uid),
        'permittedUsers',
        containsAll(['user_a', 'user_b']),
      ),
    ],
  );

  blocTest<UserBloc, UserState>(
    'emits [UsersLoading, UsersLoaded] where blocked user moves from permitted → blocked when BlockUser is added',
    build: () => userBloc,
    act: (bloc) async {
      bloc.add(WatchUsers());
      await Future.delayed(const Duration(milliseconds: 50));
      bloc.add(const BlockUser('user_a'));
    },
    wait: const Duration(milliseconds: 150),
    expect: () => [
      isA<UsersLoading>(),
      isA<UsersLoaded>(), // initial load
      isA<UsersLoading>(),
      isA<UsersLoaded>()
          .having((stream) => stream.blockedUsers.map((user) => user.uid), 'blockedUsers', contains('user_a'))
          .having(
              (stream) => stream.permittedUsers.map((user) => user.uid), 'permittedUsers', isNot(contains('user_a'))),
    ],
  );

  blocTest<UserBloc, UserState>(
    'emits [UsersLoading, UsersLoaded] where unblocked user moves from blocked -> permitted when UnblockUser is added',
    build: () => userBloc,
    act: (bloc) async {
      // block a user
      await mockUserRepo.blockUser('user_a', mockAuthRepo.getCurrentUser());
      bloc.add(WatchUsers());
      await Future.delayed(const Duration(milliseconds: 50));
      bloc.add(const UnblockUser('user_a'));
    },
    wait: const Duration(milliseconds: 150),
    expect: () => [
      isA<UsersLoading>(),
      isA<UsersLoaded>(), // after .add(WatchUsers)
      isA<UsersLoading>(),
      isA<UsersLoaded>()
          .having((stream) => stream.blockedUsers, 'blockedUsers', isEmpty)
          .having((stream) => stream.permittedUsers.map((user) => user.uid), 'permittedUsers', contains('user_a')),
    ],
  );

  blocTest<UserBloc, UserState>(
    'emits [UserError] when there is no current user',
    build: () {
      // no current user signed in
      final unauthRepo = MockAuthRepository();
      return UserBloc(authRepo: unauthRepo, userRepo: mockUserRepo);
    },
    act: (bloc) => bloc.add(WatchUsers()),
    expect: () => [isA<UsersLoading>(), isA<UserError>()],
  );
}
