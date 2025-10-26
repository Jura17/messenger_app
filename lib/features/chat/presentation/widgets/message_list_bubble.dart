import 'package:flutter/material.dart';
import 'package:messenger_app/core/theme/custom_colors.dart';
import 'package:messenger_app/core/theme/theme_provider.dart';

import 'package:messenger_app/features/auth/bloc/auth_bloc.dart';
import 'package:messenger_app/features/auth/bloc/auth_state.dart';
import 'package:messenger_app/features/chat/bloc/chat_bloc.dart';
import 'package:messenger_app/features/chat/bloc/chat_event.dart';

import 'package:messenger_app/features/chat/data/models/message.dart';
import 'package:messenger_app/features/users/bloc/user_bloc.dart';
import 'package:messenger_app/features/users/bloc/user_event.dart';
import 'package:provider/provider.dart';

class MessageListBubble extends StatelessWidget {
  const MessageListBubble({
    super.key,
    required this.message,
    required this.time,
  });

  final Message message;
  final String? time;

  @override
  Widget build(BuildContext context) {
    bool isCurrentUser = false;

    final isDarkMode = context.read<ThemeProvider>().isDarkMode;
    final authBlocState = context.read<AuthBloc>().state;

    if (authBlocState is Authenticated) {
      isCurrentUser = message.senderId == authBlocState.user.uid;
    }

    var alignment = isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    const roundness = 20.0;
    var borderRadius = isCurrentUser
        ? BorderRadius.only(
            topLeft: Radius.circular(roundness),
            topRight: Radius.circular(roundness),
            bottomLeft: Radius.circular(roundness))
        : BorderRadius.only(
            topLeft: Radius.circular(roundness),
            topRight: Radius.circular(roundness),
            bottomRight: Radius.circular(roundness));

    return GestureDetector(
      onLongPress: () {
        if (!isCurrentUser) {
          _showMessageOptions(context, message.id, message.senderId);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: Align(
          alignment: alignment,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.66),
            child: Container(
              decoration: BoxDecoration(
                  color: isCurrentUser
                      ? AppColors.lightGreen
                      : (isDarkMode ? Theme.of(context).colorScheme.tertiary : Theme.of(context).colorScheme.tertiary),
                  borderRadius: borderRadius),
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    message.message,
                    style: TextStyle(color: isCurrentUser ? Colors.white : (isDarkMode ? Colors.white : Colors.black)),
                  ),
                  if (time != null)
                    Text(
                      time!,
                      style:
                          TextStyle(color: isCurrentUser ? Colors.white : (isDarkMode ? Colors.white : Colors.black)),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showMessageOptions(BuildContext context, String messageId, String userId) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.flag),
                title: const Text('Report message'),
                onTap: () {
                  Navigator.pop(context);
                  _reportMessage(context, messageId, userId);
                },
              ),
              ListTile(
                leading: const Icon(Icons.block),
                title: const Text('Block user'),
                onTap: () {
                  Navigator.pop(context);
                  _blockUser(context, userId);
                },
              ),
              ListTile(
                leading: const Icon(Icons.cancel),
                title: const Text('Cancel'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  void _reportMessage(BuildContext context, String messageId, String userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Report message"),
        content: const Text("Are you sure you want to report this message?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              context.read<ChatBloc>().add(ReportMessage(userId, messageId));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Message reported.")),
              );
            },
            child: const Text("Report"),
          ),
        ],
      ),
    );
  }

  void _blockUser(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Block user"),
        content: const Text("Are you sure you want to block this user?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              context.read<UserBloc>().add(BlockUser(userId));
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("User blocked.")),
              );
            },
            child: const Text("Block"),
          ),
        ],
      ),
    );
  }
}
