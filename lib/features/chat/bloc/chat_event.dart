import 'package:equatable/equatable.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class WatchMessages extends ChatEvent {
  final String chatPartnerId;

  const WatchMessages(this.chatPartnerId);

  @override
  List<Object?> get props => [chatPartnerId];
}

class WatchUnreadMessagesCount extends ChatEvent {
  final String chatPartnerId;

  const WatchUnreadMessagesCount(this.chatPartnerId);

  @override
  List<Object?> get props => [chatPartnerId];
}

class SendMessage extends ChatEvent {
  final String receiverId;
  final String message;

  const SendMessage(this.receiverId, this.message);

  @override
  List<Object?> get props => [receiverId, message];
}

class MarkMessagesAsRead extends ChatEvent {
  final String receiverId;

  const MarkMessagesAsRead(this.receiverId);

  @override
  List<Object?> get props => [receiverId];
}

class ReportMessage extends ChatEvent {
  final String messageOwnerId;
  final String messageId;

  const ReportMessage(this.messageOwnerId, this.messageId);

  @override
  List<Object?> get props => [messageOwnerId, messageId];
}
