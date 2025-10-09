import 'package:messenger_app/features/chat/data/models/message.dart';

abstract class ChatRepository {
  Stream<List<Message>> watchChatroomMessages(String chatPartnerId);
  Stream<int> watchUnreadMessageCount(String chatPartnerId);
  Future<void> sendMessage(String receiverID, message);
  Future<void> markMessagesAsRead(String receiverID);
  Future<void> reportMessage(String messageId, String userId);
}
