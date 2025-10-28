import 'package:firebase_auth/firebase_auth.dart';
import 'package:messenger_app/features/chat/data/models/message.dart';

abstract class ChatApi {
  Stream<List<Message>> getMessages(String chatPartnerId, User? currentUser);
  Future<void> sendMessage(String chatPartnerId, message, User? currentUser);
  Future<void> markMessagesAsRead(String chatPartnerId, User? currentUser);
  Future<void> reportMessage(String messageId, String userId, User? currentUser);
}
