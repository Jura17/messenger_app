import 'package:messenger_app/features/auth/domain/entities/auth_user.dart';
import 'package:messenger_app/features/chat/domain/entities/chat_preview.dart';
import 'package:messenger_app/features/chat/domain/entities/message.dart';

abstract interface class ChatRepository {
  Stream<List<Message>> watchChatroomMessages(String chatPartnerId, AuthUser? currentUser);
  Stream<int> watchUnreadMessageCount(String chatPartnerId, String? currentUserId);
  Future<void> sendMessage(String chatPartnerId, String message, AuthUser? currentUser);
  Stream<List<ChatPreview>> watchChatroom(AuthUser? currentUser);
  Future<void> markMessagesAsRead(String chatPartnerId, AuthUser? currentUser);
  Future<void> reportMessage(String messageId, String chatPartnerId, AuthUser? currentUser);
}
