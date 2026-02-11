import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_app/features/auth/data/repositories/mock_auth_repository.dart';
import 'package:messenger_app/features/users/bloc/userdata_bloc.dart';
import 'package:messenger_app/features/users/bloc/userdata_event.dart';
import 'package:messenger_app/features/users/bloc/userdata_state.dart';
import 'package:messenger_app/features/users/data/repositories/mock_userdata_repository.dart';

void main() {
  late MockAuthRepository mockAuthRepository;
  late MockUserdataRepository mockUserdataRepository;
  late UserdataBloc userdataBloc;

  setUp(() async {
    mockAuthRepository = MockAuthRepository();
    mockUserdataRepository = MockUserdataRepository();
    userdataBloc = UserdataBloc(userRepo: mockUserdataRepository);

    await mockUserdataRepository.createUser('user_a', 'userA', 'a@test.com');
    await mockAuthRepository.signIn('a@test.com', '123456');
  });

  tearDown(() {
    mockAuthRepository.dispose();
    mockUserdataRepository.dispose();
    userdataBloc.close();
  });

  blocTest<UserdataBloc, UserdataState>(
    'emits [UserdataLoading, UserdataLoaded] with current user information when WatchUserStream is added',
    build: () => userdataBloc,
    act: (bloc) => bloc.add(WatchUserdata('user_a')),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      isA<UserdataLoading>(),
      isA<UserdataLoaded>().having(
        (stream) => stream.userdata!.email,
        'currently logged in user',
        contains('a@test.com'),
      ),
    ],
  );
}
