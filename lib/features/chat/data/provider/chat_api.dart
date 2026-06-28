import 'package:messenger_app/features/auth/domain/entities/auth_user.dart';
import 'package:messenger_app/features/chat/domain/entities/message.dart';

abstract class ChatApi {
  Stream<List<Message>> getMessages(String chatPartnerId, AuthUser? currentUser);
  Future<void> sendMessage(String chatPartnerId, message, AuthUser? currentUser);
  Stream<int> watchUnreadMessageCount(String chatPartnerId, AuthUser? currentUser);
  Future<void> markMessagesAsRead(String chatPartnerId, AuthUser? currentUser);
  Future<void> reportMessage(String messageId, String userId, AuthUser? currentUser);
}
