import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_app/core/theme/custom_colors.dart';
import 'package:messenger_app/features/auth/data/repositories/firebase_auth_repository.dart';
import 'package:messenger_app/features/chat/bloc/chat_bloc.dart';
import 'package:messenger_app/features/chat/bloc/chat_event.dart';

import 'package:messenger_app/features/chat/data/repositories/firestore_chat_repository.dart';
import 'package:messenger_app/features/chat/presentation/screens/chat_screen.dart';
import 'package:messenger_app/utils/format_chat_date.dart';
import 'package:messenger_app/utils/get_username_initials.dart';

class ChatTile extends StatefulWidget {
  const ChatTile({
    super.key,
    required this.chatPartnerName,
    required this.chatPartnerId,
    required this.lastMessageText,
    required this.lastMessageTimestamp,
  });

  final String chatPartnerName;
  final String chatPartnerId;
  final String lastMessageText;
  final Timestamp? lastMessageTimestamp;

  @override
  State<ChatTile> createState() => _ChatTileState();
}

class _ChatTileState extends State<ChatTile> {
  @override
  Widget build(BuildContext context) {
    int unreadCount = 0;

    final authRepo = context.read<FirebaseAuthRepository>();
    final chatRepo = context.read<FirestoreChatRepository>();

    final currentUser = authRepo.getCurrentUser();
    final usernameInitials = getUsernameInitials(widget.chatPartnerName);

    final Stream<int> unreadCountStream =
        context.watch<FirestoreChatRepository>().watchUnreadMessageCount(widget.chatPartnerId, currentUser);

    return GestureDetector(
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) {
                final chatBloc = ChatBloc(chatRepo: chatRepo, authRepo: authRepo);
                chatBloc.add(WatchMessages(widget.chatPartnerId));
                return chatBloc;
              },
              child: ChatScreen(
                chatPartnerEmail: widget.chatPartnerName,
                chatPartnerId: widget.chatPartnerId,
              ),
            ),
          ),
        );
      },
      child: Container(
        height: 100,
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Row(
          children: [
            Container(
              height: double.infinity,
              width: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.secondary,
              ),
              child: Center(child: Text(usernameInitials ?? "PH")),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.chatPartnerName,
                    style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
                  ),
                  Text(
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    widget.lastMessageText.isEmpty ? "No messages between you two yet." : widget.lastMessageText,
                    style: widget.lastMessageText.isEmpty
                        ? TextStyle(color: Theme.of(context).colorScheme.primary).copyWith(fontStyle: FontStyle.italic)
                        : TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                ],
              ),
            ),
            StreamBuilder<int>(
              stream: unreadCountStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  debugPrint("Error fetching unread count");
                  return SizedBox.shrink();
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                if (snapshot.data != null) {
                  unreadCount = snapshot.data!;
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // show last message
                    if (widget.lastMessageTimestamp != null)
                      Text(formatChatDate(widget.lastMessageTimestamp!.toDate())),
                    // show unread count as highlighted circle
                    if (unreadCount != 0)
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).highlightColor),
                        child: Text(
                          snapshot.data.toString(),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
