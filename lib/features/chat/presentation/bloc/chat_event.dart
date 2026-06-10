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
  final String chatPartnerId;
  final String message;

  const SendMessage(this.chatPartnerId, this.message);

  @override
  List<Object?> get props => [chatPartnerId, message];
}

class MarkMessagesAsRead extends ChatEvent {
  final String chatPartnerId;

  const MarkMessagesAsRead(this.chatPartnerId);

  @override
  List<Object?> get props => [chatPartnerId];
}

class ReportMessage extends ChatEvent {
  final String chatPartnerId;
  final String messageId;

  const ReportMessage(this.chatPartnerId, this.messageId);

  @override
  List<Object?> get props => [chatPartnerId, messageId];
}
