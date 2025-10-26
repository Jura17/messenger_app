import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_app/features/chat/bloc/chat_event.dart';
import 'package:messenger_app/features/chat/bloc/chat_state.dart';
import 'package:messenger_app/features/chat/data/models/message.dart';
import 'package:messenger_app/features/chat/data/repositories/firestore_chat_repository.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final FirestoreChatRepository _chatRepo;

  ChatBloc({required FirestoreChatRepository chatRepo})
      : _chatRepo = chatRepo,
        super(ChatInitial()) {
    on<WatchMessages>(_onWatchMessages);
    on<WatchUnreadMessagesCount>(_onWatchUnreadMessagesCount);
    on<SendMessage>(_onSendMessage);
    on<MarkMessagesAsRead>(_onMarkMessagesAsRead);
    on<ReportMessage>(_onReportMessage);
  }

  Future<void> _onWatchMessages(WatchMessages event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    await emit.forEach<List<Message>>(
      _chatRepo.watchChatroomMessages(event.chatPartnerId),
      onData: (messages) => ChatLoaded(messages),
      onError: (error, stackTrace) => ChatError(error.toString()),
    );
  }

  Future<void> _onWatchUnreadMessagesCount(WatchUnreadMessagesCount event, Emitter<ChatState> emit) async {
    await emit.forEach<int>(
      _chatRepo.watchUnreadMessageCount(event.chatPartnerId),
      onData: (count) {
        return UnreadCountLoaded(count, event.chatPartnerId);
      },
      onError: (error, stackTrace) => ChatError(error.toString()),
    );
  }

  Future<void> _onSendMessage(SendMessage event, Emitter<ChatState> emit) async {
    try {
      await _chatRepo.sendMessage(event.chatPartnerId, event.message);
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> _onMarkMessagesAsRead(MarkMessagesAsRead event, Emitter<ChatState> emit) async {
    try {
      await _chatRepo.markMessagesAsRead(event.chatPartnerId);
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> _onReportMessage(ReportMessage event, Emitter<ChatState> emit) async {
    try {
      await _chatRepo.reportMessage(event.messageId, event.chatPartnerId);
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }
}
