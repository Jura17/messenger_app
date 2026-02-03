import 'package:firebase_auth/firebase_auth.dart';
import 'package:messenger_app/features/chat/data/models/chat_preview.dart';
import 'package:messenger_app/features/chat/data/models/message.dart';
import 'package:messenger_app/features/chat/data/provider/firestore_chat_api.dart';
import 'package:messenger_app/features/chat/data/repositories/chat_repository.dart';

class FirestoreChatRepository implements ChatRepository {
  final FirestoreChatApi chatApi;

  FirestoreChatRepository(this.chatApi);

  @override
  Stream<List<Message>> watchChatroomMessages(String chatPartnerId, User? currentUser) {
    final messageStream = chatApi.getMessages(chatPartnerId, currentUser);
    return messageStream;
  }

  @override
  Stream<int> watchUnreadMessageCount(String chatPartnerId, User? currentUser) {
    return chatApi.watchUnreadMessageCount(chatPartnerId, currentUser);
  }

  @override
  Future<void> sendMessage(String chatPartnerId, String message, User? currentUser) async {
    await chatApi.sendMessage(chatPartnerId, message, currentUser);
  }

  @override
  Stream<List<ChatPreview>> watchChatroom(User? currentUser) {
    return chatApi.watchChatroom(currentUser);
  }

  @override
  Future<void> markMessagesAsRead(String chatPartnerId, User? currentUser) async {
    await chatApi.markMessagesAsRead(chatPartnerId, currentUser);
  }

  @override
  Future<void> reportMessage(String messageId, String chatPartnerId, User? currentUser) async {
    await chatApi.reportMessage(messageId, chatPartnerId, currentUser);
  }
}
