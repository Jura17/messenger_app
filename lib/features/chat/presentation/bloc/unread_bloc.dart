import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:messenger_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:messenger_app/features/chat/presentation/bloc/unread_state.dart';
import 'package:messenger_app/features/chat/presentation/bloc/unread_event.dart';

class UnreadBloc extends Bloc<UnreadEvent, UnreadState> {
  final ChatRepository _chatRepo;

  UnreadBloc({required ChatRepository chatRepo, required AuthRepository authRepo})
      : _chatRepo = chatRepo,
        super(UnreadInitial()) {
    on<WatchUnreadMessagesCount>(_onWatchUnreadMessagesCount);
  }

  Future<void> _onWatchUnreadMessagesCount(WatchUnreadMessagesCount event, Emitter<UnreadState> emit) async {
    await emit.forEach<int>(
      _chatRepo.watchUnreadMessageCount(event.chatPartnerId, event.currentUserId),
      onData: (count) {
        return UnreadLoaded(count, event.chatPartnerId);
      },
      onError: (error, stackTrace) => UnreadError(error.toString()),
    );
  }
}
