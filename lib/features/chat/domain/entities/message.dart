class Message {
  final String id;
  final String senderId;
  final String senderEmail;
  final String receiverId;
  final String message;
  final DateTime dateTime;
  final bool isRead;

  Message({
    required this.id,
    required this.senderId,
    required this.senderEmail,
    required this.receiverId,
    required this.message,
    required this.dateTime,
    this.isRead = false,
  });
}
