import 'package:messenger_app/features/chat/data/models/message.dart';

abstract class ChatApi {
  Stream<List<Message>> getMessages(String chatPartnerId);
  Future<void> sendMessage(String chatPartnerId, message);
  Future<void> markMessagesAsRead(String chatPartnerId);
  Future<void> reportMessage(String messageId, String userId);
}
