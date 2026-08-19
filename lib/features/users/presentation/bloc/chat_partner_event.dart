import 'package:equatable/equatable.dart';

sealed class ChatPartnerEvent extends Equatable {
  const ChatPartnerEvent();

  @override
  List<Object?> get props => [];
}

final class WatchChatPartner extends ChatPartnerEvent {
  final String uid;

  const WatchChatPartner(this.uid);
  @override
  List<Object?> get props => [uid];
}
