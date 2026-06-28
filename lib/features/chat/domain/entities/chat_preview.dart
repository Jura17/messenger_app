class ChatPreview {
  final String chatroomId;
  final String lastMessageText;
  final DateTime lastMessageDateTime;
  final String lastMessageSenderId;
  final List<String> participants;

  ChatPreview({
    required this.chatroomId,
    required this.lastMessageText,
    required this.lastMessageDateTime,
    required this.lastMessageSenderId,
    required this.participants,
  });
}
