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

  // TODO: maybe move this to chat api
  @override
  Stream<int> watchUnreadMessageCount(String chatPartnerId) {
    final currentUser = chatApi.authRepo.getCurrentUser();
    if (currentUser == null) throw Exception('No authenticated user');

    final currentUserId = currentUser.uid;

    // build consistent chatroom ID
    List<String> userIds = [currentUserId, chatPartnerId];
    userIds.sort();
    final String chatroomId = userIds.join('_');

    // watch only unread messages
    return chatApi.firestoreDb
        .collection('chatrooms')
        .doc(chatroomId)
        .collection('messages')
        .where('receiverId', isEqualTo: currentUserId)
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) {
      final count = snapshot.docs.length;

      return count;
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
