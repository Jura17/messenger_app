import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_app/core/theme/custom_colors.dart';
import 'package:messenger_app/features/auth/data/repositories/firebase_auth_repository.dart';
import 'package:messenger_app/features/chat/bloc/chat_bloc.dart';
import 'package:messenger_app/features/chat/bloc/chat_event.dart';
import 'package:messenger_app/features/chat/data/models/chat_preview.dart';
import 'package:messenger_app/features/chat/data/models/message.dart';

import 'package:messenger_app/features/chat/data/repositories/firestore_chat_repository.dart';
import 'package:messenger_app/features/chat/presentation/screens/chat_screen.dart';

class ChatTile extends StatefulWidget {
  const ChatTile({
    super.key,
    required this.chatPartnerEmail,
    required this.chatPartnerId,
  });

  final String chatPartnerEmail;
  final String chatPartnerId;

  @override
  State<ChatTile> createState() => _ChatTileState();
}

class _ChatTileState extends State<ChatTile> {
  @override
  Widget build(BuildContext context) {
    int unreadCount = 0;

    Message? mostRecentMessage;
    final authRepo = context.read<FirebaseAuthRepository>();
    final chatRepo = context.read<FirestoreChatRepository>();

    final currentUser = authRepo.getCurrentUser();

    final Stream<int> unreadCountStream =
        context.watch<FirestoreChatRepository>().watchUnreadMessageCount(widget.chatPartnerId, currentUser);

    final Stream<List<ChatPreview>> chatRoomStream =
        context.watch<FirestoreChatRepository>().watchChatroom(currentUser);

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
                chatPartnerEmail: widget.chatPartnerEmail,
                chatPartnerId: widget.chatPartnerId,
              ),
            ),
          ),
        );
      },
      child: Container(
        height: 85,
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
              child: Center(child: Text("TW")),
            ),
            SizedBox(width: 10),
            StreamBuilder(
                stream: chatRoomStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    debugPrint(snapshot.error.toString());
                    debugPrint("Error fetching chatroom preview");
                    return SizedBox.shrink();
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (snapshot.data != null) {
                    final previews = snapshot.data!;
                    print(previews);
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.chatPartnerEmail,
                        style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
                      ),
                      Text(
                        mostRecentMessage != null ? mostRecentMessage.message : "Most recent message",
                        style: TextStyle(color: Theme.of(context).colorScheme.primary),
                      ),
                    ],
                  );
                }),
            Spacer(),
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

                // show unread count as green circle
                if (unreadCount != 0) {
                  return Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.lightGreen),
                    child: Text(
                      snapshot.data.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }
                return SizedBox.shrink();
              },
            )
          ],
        ),
      ),
    );
  }
}
