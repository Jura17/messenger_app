import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id;
  final String senderId;
  final String senderEmail;
  final String receiverId;
  final String message;
  final Timestamp timestamp;
  final bool isRead;

  Message({
    required this.id,
    required this.senderId,
    required this.senderEmail,
    required this.receiverId,
    required this.message,
    required this.timestamp,
    this.isRead = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderId': senderId,
      'senderEmail': senderEmail,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp,
      'isRead': isRead,
    };
  }

  factory Message.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Message(
      id: doc.id,
      senderId: doc['senderId'],
      senderEmail: doc['senderEmail'],
      receiverId: doc['receiverId'],
      message: doc['message'],
      timestamp: doc['timestamp'],
    );
  }
}
