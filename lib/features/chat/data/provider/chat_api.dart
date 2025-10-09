import 'package:messenger_app/features/chat/data/models/message.dart';

abstract class ChatApi {
  Stream<List<Message>> getMessages(String chatPartnerId);
  Future<void> sendMessage(String receiverId, message);
  Future<void> markMessagesAsRead(String receiverId);
  Future<void> reportMessage(String messageId, String userId);
}
