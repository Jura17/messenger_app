import 'package:equatable/equatable.dart';

sealed class UnreadEvent extends Equatable {
  const UnreadEvent();

  @override
  List<Object?> get props => [];
}

class WatchUnreadMessagesCount extends UnreadEvent {
  final String chatPartnerId;
  final String currentUserId;

  const WatchUnreadMessagesCount(this.chatPartnerId, this.currentUserId);

  @override
  List<Object?> get props => [chatPartnerId];
}
