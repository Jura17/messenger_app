import 'dart:async';

import 'package:messenger_app/features/auth/domain/entities/auth_user.dart';
import 'package:messenger_app/features/chat/domain/entities/chat_preview.dart';
import 'package:messenger_app/features/chat/domain/entities/message.dart';
import 'package:messenger_app/features/chat/domain/repositories/chat_repository.dart';

class FakeChatRepository implements ChatRepository {
  final _unreadMessagesStream = StreamController<List<Message>>.broadcast();
  final List<Message> _fakeMessageDb = [
    Message(
        id: 'm1',
        senderId: '123',
        senderEmail: 'user@test.com',
        receiverId: '456',
        message: 'Hey there!',
        dateTime: DateTime.now()),
    Message(
        id: 'm2',
        senderId: '123',
        senderEmail: 'user@test.com',
        receiverId: '456',
        message: 'This is a test message.',
        dateTime: DateTime.now(),
        isRead: false),
    Message(
        id: 'm3',
        senderId: '456',
        senderEmail: 'user2@test.com',
        receiverId: '123',
        message: 'Nice one.',
        dateTime: DateTime.now(),
        isRead: false),
  ];

  @override
  Future<void> markMessagesAsRead(String chatPartnerId, AuthUser? currentUser) {
    // TODO: implement markMessagesAsRead
    throw UnimplementedError();
  }

  @override
  Future<void> reportMessage(String messageId, String chatPartnerId, AuthUser? currentUser) {
    // TODO: implement reportMessage
    throw UnimplementedError();
  }

  @override
  Future<void> sendMessage(String chatPartnerId, String message, AuthUser? currentUser) {
    // TODO: implement sendMessage
    throw UnimplementedError();
  }

  @override
  Stream<List<ChatPreview>> watchChatroom(AuthUser? currentUser) {
    // TODO: implement watchChatroom
    throw UnimplementedError();
  }

  @override
  Stream<List<Message>> watchChatroomMessages(String chatPartnerId, AuthUser? currentUser) {
    // TODO: implement watchChatroomMessages
    throw UnimplementedError();
  }

  @override
  Stream<int> watchUnreadMessageCount(String chatPartnerId, String? currentUserId) {
    if (currentUserId == null) throw Exception('No authenticated user');

    _unreadMessagesStream.sink.add(_fakeMessageDb);
    return _unreadMessagesStream.stream.map((messages) {
      return messages.where((message) => message.isRead == false).length;
    });
  }
}
