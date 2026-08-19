import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_app/features/auth/data/repositories/fake_auth_repository.dart';
import 'package:messenger_app/features/users/presentation/bloc/chat_partner_bloc.dart';
import 'package:messenger_app/features/users/presentation/bloc/chat_partner_event.dart';
import 'package:messenger_app/features/users/presentation/bloc/chat_partner_state.dart';
import 'package:messenger_app/features/users/data/repositories/fake_userdata_repository.dart';

void main() {
  late FakeAuthRepository mockAuthRepository;
  late FakeUserdataRepository mockUserdataRepository;
  late ChatPartnerBloc currentUserBloc;

  setUp(() async {
    mockAuthRepository = FakeAuthRepository();
    mockUserdataRepository = FakeUserdataRepository();
    currentUserBloc = ChatPartnerBloc(userRepo: mockUserdataRepository);

    await mockUserdataRepository.createUser('user_a', 'userA', 'a@test.com');
    await mockAuthRepository.signIn('a@test.com', '123456');
  });

  tearDown(() {
    mockAuthRepository.dispose();
    mockUserdataRepository.dispose();
    currentUserBloc.close();
  });

  blocTest<ChatPartnerBloc, ChatPartnerState>(
    'emits [CurrentUserLoading, CurrentUserLoaded] with current user information when WatchUserStream is added',
    build: () => currentUserBloc,
    act: (bloc) => bloc.add(WatchChatPartner('user_a')),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      isA<ChatPartnerLoading>(),
      isA<ChatPartnerLoaded>().having(
        (stream) => stream.userdata!.email,
        'currently logged in user',
        contains('a@test.com'),
      ),
    ],
  );
}
