import 'package:cloud_firestore/cloud_firestore.dart';

class ChatPreview {
  final String chatroomId;
  final String lastMessageText;
  final Timestamp lastMessageTimestamp;
  final String lastMessageSenderId;
  final List<String> participants;

  ChatPreview({
    required this.chatroomId,
    required this.lastMessageText,
    required this.lastMessageTimestamp,
    required this.lastMessageSenderId,
    required this.participants,
  });
}
