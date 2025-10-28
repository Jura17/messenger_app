import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_app/core/theme/custom_colors.dart';
import 'package:messenger_app/features/auth/data/repositories/firebase_auth_repository.dart';
import 'package:messenger_app/features/chat/bloc/chat_bloc.dart';
import 'package:messenger_app/features/chat/bloc/chat_event.dart';

import 'package:messenger_app/features/chat/data/repositories/firestore_chat_repository.dart';
import 'package:messenger_app/features/chat/presentation/screens/chat_screen.dart';

class UserTile extends StatefulWidget {
  const UserTile({
    super.key,
    required this.email,
    required this.chatPartnerEmail,
    required this.chatPartnerId,
  });

  final String email;
  final String chatPartnerEmail;
  final String chatPartnerId;

  @override
  State<UserTile> createState() => _UserTileState();
}

class _UserTileState extends State<UserTile> {
  @override
  Widget build(BuildContext context) {
    int unreadCount = 0;
    final authRepo = context.read<FirebaseAuthRepository>();
    final chatRepo = context.read<FirestoreChatRepository>();

    final currentUser = authRepo.getCurrentUser();

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
                chatPartnerEmail: widget.chatPartnerEmail,
                chatPartnerId: widget.chatPartnerId,
              ),
            ),
          ),
        );
      },
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(Icons.person, color: Theme.of(context).colorScheme.inversePrimary),
            Text(
              widget.email,
              style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
            ),
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
