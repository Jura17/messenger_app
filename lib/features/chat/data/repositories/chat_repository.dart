import 'package:messenger_app/features/chat/data/models/message.dart';

abstract class ChatRepository {
  Stream<List<Message>> watchChatroomMessages(String chatPartnerId);
  Stream<int> watchUnreadMessageCount(String chatPartnerId);
  Future<void> sendMessage(String receiverId, message);
  Future<void> markMessagesAsRead(String receiverId);
  Future<void> reportMessage(String messageId, String userId);
}
