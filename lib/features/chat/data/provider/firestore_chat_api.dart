import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:messenger_app/features/chat/data/models/chat_preview.dart';

import 'package:messenger_app/features/chat/data/models/message.dart';
import 'package:messenger_app/features/chat/data/provider/chat_api.dart';

class FirestoreChatApi implements ChatApi {
  final FirebaseFirestore firestoreDb;

  FirestoreChatApi(this.firestoreDb);

  @override
  Stream<List<Message>> getMessages(String chatPartnerId, User? currentUser) {
    if (currentUser == null) throw Exception('No authenticated user');

    final currentUserId = currentUser.uid;
    // construct a chatroom ID for the two users
    List<String> userIDs = [currentUserId, chatPartnerId];
    userIDs.sort();
    final String chatroomId = userIDs.join('_');

    return firestoreDb
        .collection('chatrooms')
        .doc(chatroomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((messageDoc) {
              return Message.fromDocument(messageDoc);
            }).toList());
  }

  Stream<List<ChatPreview>> watchChatroom(User? currentUser) {
    if (currentUser == null) throw Exception('No authenticated user');

    final currentUserId = currentUser.uid;

    return firestoreDb
        .collection('chatrooms')
        .where('participants', arrayContains: currentUserId)
        .orderBy('lastMessageTimestamp', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            final data = doc.data();
            return ChatPreview(
              chatroomId: doc.id,
              lastMessageText: data['lastMessageText'] ?? '',
              lastMessageTimestamp: data['lastMessageTimestamp'],
              lastMessageSenderId: data['lastMessageSenderId'] ?? '',
              participants: List<String>.from(data['participants'] ?? []),
            );
          }).toList(),
        );
  }

  @override
  Future<void> sendMessage(String chatPartnerId, message, User? currentUser) async {
    if (currentUser == null) throw Exception('No authenticated user');

    final String currentUserId = currentUser.uid;
    final String currentUserEmail = currentUser.email!;
    final Timestamp timestamp = Timestamp.now();

    // construct chat room ID for the two users (sorted to ensure uniqueness)
    List<String> userIds = [currentUserId, chatPartnerId];
    // sort the IDs to ensure the chatroom ID is the same for any 2 people
    userIds.sort();
    final String chatroomId = userIds.join('_');

    final docRef = firestoreDb.collection('chatrooms').doc(chatroomId).collection('messages').doc();

    // create a new message
    Message newMessage = Message(
      id: docRef.id,
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      receiverId: chatPartnerId,
      message: message,
      timestamp: timestamp,
    );

    // add new message to database
    await firestoreDb.collection('chatrooms').doc(chatroomId).collection('messages').add(newMessage.toMap());
    await firestoreDb.collection('chatrooms').doc(chatroomId).set({
      'participants': [currentUserId, chatPartnerId],
      'lastMessageText': newMessage.message,
      'lastMessageTimestamp': FieldValue.serverTimestamp(),
      'lastMessageSenderId': currentUserId,
    }, SetOptions(merge: true));
  }

  @override
  Future<void> markMessagesAsRead(String chatPartnerId, User? currentUser) async {
    if (currentUser == null) throw Exception('No authenticated user');

    final currentUserId = currentUser.uid;

    List<String> ids = [currentUserId, chatPartnerId];
    ids.sort();
    String chatRoomId = ids.join('_');

    final unreadMessagesQuery = firestoreDb
        .collection('chatrooms')
        .doc(chatRoomId)
        .collection('messages')
        .where('receiverId', isEqualTo: currentUserId)
        .where('isRead', isEqualTo: false);

    final unreadMessagesSnapshot = await unreadMessagesQuery.get();

    for (var message in unreadMessagesSnapshot.docs) {
      await message.reference.update({'isRead': true});
    }
  }

  @override
  Future<void> reportMessage(String messageId, String chatPartnerId, User? currentUser) async {
    final report = {
      'reportedBy': currentUser!.uid,
      'messageId': messageId,
      'messageOwnerId': chatPartnerId,
      'timestamp': FieldValue.serverTimestamp()
    };

    await firestoreDb.collection('reports').add(report);
  }
}
