import 'package:messenger_app/features/chat/data/models/message.dart';
import 'package:messenger_app/features/chat/data/provider/firestore_chat_api.dart';
import 'package:messenger_app/features/chat/data/repositories/chat_repository.dart';

class FirestoreChatRepository implements ChatRepository {
  final FirestoreChatApi chatApi;

  FirestoreChatRepository(this.chatApi);

  @override
  Stream<List<Message>> watchChatroomMessages(String chatPartnerId) {
    final messageStream = chatApi.getMessages(chatPartnerId);
    return messageStream;
  }

  @override
  Stream<int> watchUnreadMessageCount(String chatPartnerId) {
    final currentUser = chatApi.authRepo.getCurrentUser();
    if (currentUser == null) throw Exception('No authenticated user');
    final currentUserId = currentUser.uid;

    final messagesStream = chatApi.getMessages(chatPartnerId);

    // We're returning a stream that emits integers over time
    return messagesStream.map((messages) {
      final numOfunread =
          messages.where((message) => message.receiverId == currentUserId && message.isRead == false).length;

      return numOfunread;
    });
  }

  @override
  Future<void> markMessagesAsRead(String receiverId) async {
    await chatApi.markMessagesAsRead(receiverId);
  }

  @override
  Future<void> reportMessage(String messageId, String userId) async {
    await chatApi.reportMessage(messageId, userId);
  }

  @override
  Future<void> sendMessage(String receiverID, message) async {
    await chatApi.sendMessage(receiverID, message);
  }
}
