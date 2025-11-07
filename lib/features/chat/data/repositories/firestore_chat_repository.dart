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

  // TODO: maybe move this to chat api
  @override
  Stream<int> watchUnreadMessageCount(String chatPartnerId, User? currentUser) {
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

  @override
  Future<void> sendMessage(String chatPartnerId, String message, User? currentUser) async {
    await chatApi.sendMessage(chatPartnerId, message, currentUser);
  }
}
