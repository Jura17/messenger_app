import 'package:firebase_auth/firebase_auth.dart';
import 'package:messenger_app/features/chat/data/models/message.dart';

abstract class ChatRepository {
  Stream<List<Message>> watchChatroomMessages(String chatPartnerId, User? currentUser);
  Stream<int> watchUnreadMessageCount(String chatPartnerId, User? currentUser);
  Future<void> sendMessage(String chatPartnerId, String message, User? currentUser);
  Future<void> markMessagesAsRead(String chatPartnerId, User? currentUser);
  Future<void> reportMessage(String messageId, String chatPartnerId, User? currentUser);
}
