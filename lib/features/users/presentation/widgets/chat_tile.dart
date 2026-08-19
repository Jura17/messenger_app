import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_app/features/auth/domain/entities/auth_user.dart';
import 'package:messenger_app/features/auth/domain/repositories/auth_repository.dart';

import 'package:messenger_app/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:messenger_app/features/chat/presentation/bloc/chat_event.dart';
import 'package:messenger_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:messenger_app/features/chat/presentation/bloc/unread_bloc.dart';

import 'package:messenger_app/features/chat/presentation/bloc/unread_state.dart';

import 'package:messenger_app/features/chat/presentation/screens/chat_screen.dart';
import 'package:messenger_app/features/users/presentation/bloc/chat_partner_bloc.dart';
import 'package:messenger_app/features/users/presentation/bloc/chat_partner_event.dart';

import 'package:messenger_app/features/users/domain/repositories/userdata_repository.dart';
import 'package:messenger_app/utils/format_chat_date.dart';
import 'package:messenger_app/utils/get_username_initials.dart';

class ChatTile extends StatefulWidget {
  const ChatTile({
    super.key,
    required this.currentUser,
    required this.chatPartnerName,
    required this.chatPartnerId,
    required this.lastMessageText,
    required this.lastMessageDateTime,
    required this.profileImage,
    required this.lastSeen,
  });

  final AuthUser currentUser;
  final String chatPartnerName;
  final String chatPartnerId;
  final String lastMessageText;
  final DateTime? lastMessageDateTime;
  final DateTime lastSeen;
  final String profileImage;

  @override
  State<ChatTile> createState() => _ChatTileState();
}

class _ChatTileState extends State<ChatTile> {
  @override
  Widget build(BuildContext context) {
    int unreadCount = 0;

    final chatRepo = context.read<ChatRepository>();
    final usernameInitials = getUsernameInitials(widget.chatPartnerName);

    return GestureDetector(
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MultiBlocProvider(
              providers: [
                BlocProvider(create: (BuildContext context) {
                  final chatBloc = ChatBloc(chatRepo: chatRepo, authRepo: context.read<AuthRepository>());
                  chatBloc.add(WatchMessages(widget.chatPartnerId));
                  return chatBloc;
                }),
                BlocProvider(create: (BuildContext context) {
                  final userdataBloc = ChatPartnerBloc(userRepo: context.read<UserdataRepository>());
                  userdataBloc.add(WatchChatPartner(widget.chatPartnerId));
                  return userdataBloc;
                }),
              ],
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
              child: Center(
                child: widget.profileImage.isNotEmpty
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(widget.profileImage),
                        radius: 25,
                      )
                    : Text(usernameInitials ?? 'User'),
              ),
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
            BlocBuilder<UnreadBloc, UnreadState>(
              builder: (context, state) {
                if (state is UnreadError) {
                  debugPrint(state.message);
                  return SizedBox.shrink();
                }
                if (state is UnreadLoading) {
                  return CircularProgressIndicator();
                }
                if (state is UnreadLoaded && state.chatPartnerId == widget.chatPartnerId) {
                  unreadCount = state.count;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // show last message
                      if (widget.lastMessageDateTime != null) Text(formatChatDate(widget.lastMessageDateTime!)),
                      // show unread count as highlighted circle
                      if (unreadCount != 0)
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).highlightColor),
                          child: Text(
                            unreadCount.toString(),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.tertiary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  );
                }
                return SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
