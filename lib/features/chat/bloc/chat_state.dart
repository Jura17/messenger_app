import 'package:equatable/equatable.dart';
import 'package:messenger_app/features/chat/data/models/message.dart';

sealed class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

final class ChatInitial extends ChatState {}

// While connecting to Firestore stream
final class ChatLoading extends ChatState {}

// Core state: list of messages
final class ChatLoaded extends ChatState {
  final List<Message>? messages;

  const ChatLoaded(this.messages);

  @override
  List<Object?> get props => [messages];
}

// For showing snackbars / feedback only
final class MessageReported extends ChatState {}

// to show unread badge
final class UnreadCountLoaded extends ChatState {
  final int count;

  const UnreadCountLoaded(this.count);

  @override
  List<Object?> get props => [count];
}

final class ChatError extends ChatState {
  final String errorText;

  const ChatError(this.errorText);

  @override
  List<Object?> get props => [errorText];
}
