import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:messenger_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:messenger_app/features/chat/presentation/bloc/unread_bloc.dart';
import 'package:messenger_app/features/chat/presentation/bloc/unread_event.dart';
import 'package:messenger_app/features/chat/presentation/bloc/unread_state.dart';
import 'package:mocktail/mocktail.dart';

class MockChatRepository extends Mock implements ChatRepository {}

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockChatRepository mockChatRepo;
  late MockAuthRepository mockAuthRepo;
  late UnreadBloc unreadBloc;

  setUp(() {
    mockChatRepo = MockChatRepository();
    mockAuthRepo = MockAuthRepository();
    unreadBloc = UnreadBloc(chatRepo: mockChatRepo, authRepo: mockAuthRepo);
  });

  tearDown(() => unreadBloc.close());

  blocTest(
    "emits [UnreadLoaded] with correct count when stream updates",
    // build the BloC and prepare the mock repo environment. No actions are taken yet. The BloC is sitting there doing nothing.
    build: () {
      // if watchUnreadMessageCount with the given user IDs is called on a ChatRepo object then return a stream from an
      // iterable that pretends to be a real stream of int values (the difference: no delay in between the values!)
      when(() => mockChatRepo.watchUnreadMessageCount('456', '123')).thenAnswer(
        (_) => Stream.fromIterable([2, 3]),
      );
      return unreadBloc;
    },
    // this is where we physically "push the button" and add an event to trigger the code we want to test
    // -> _onWatchUnreadMessageCount is called -> _chatRepo.watchUnreadMessageCount is called
    act: (bloc) {
      bloc.add(WatchUnreadMessagesCount('456', '123'));
    },
    expect: () => [
      UnreadLoaded(2, '456'),
      UnreadLoaded(3, '456'),
    ],
  );
}
