import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:messenger_app/features/auth/auth_service.dart';

import 'package:messenger_app/features/chat/presentation/widgets/message_list_bubble.dart';
import 'package:messenger_app/features/chat/service/chat_service.dart';

class MessageList extends StatelessWidget {
  const MessageList({
    super.key,
    required this.receiverEmail,
    required this.receiverID,
    required this.scrollController,
  });

  final String receiverEmail;
  final String receiverID;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    String? currentMessageTime;

    final ChatService chatService = ChatService();
    final AuthService authService = AuthService();
    String senderID = authService.getCurrentUser()!.uid;

    return StreamBuilder(
      stream: chatService.getMessages(senderID, receiverID),
      builder: (context, snapshot) {
        if (snapshot.hasError || snapshot.data == null) {
          return Text("An error occurred.");
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            controller: scrollController,
            children: snapshot.data!.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              final Timestamp timestamp = data['timestamp'];
              final String dateTime = DateFormat.Hm().format(timestamp.toDate());
              // only show the timestamp if it has changed
              if (dateTime == currentMessageTime) {
                currentMessageTime = null;
              } else {
                currentMessageTime = dateTime;
              }
              return MessageListBubble(doc: doc, time: currentMessageTime);
            }).toList(),
          ),
        );
      },
    );
  }
}
