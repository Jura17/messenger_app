import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_app/features/auth/bloc/auth_bloc.dart';
import 'package:messenger_app/features/auth/bloc/auth_state.dart';
import 'package:messenger_app/features/chat/data/models/chat_preview.dart';
import 'package:messenger_app/features/chat/data/repositories/chat_repository.dart';

import 'package:messenger_app/features/users/bloc/user_bloc.dart';

import 'package:messenger_app/features/users/bloc/user_state.dart';

import 'package:messenger_app/features/users/presentation/widgets/chat_tile.dart';

class ChatListView extends StatefulWidget {
  const ChatListView({super.key});

  @override
  State<ChatListView> createState() => _ChatListViewState();
}

class _ChatListViewState extends State<ChatListView> {
  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final currentUser = authState is Authenticated ? authState.user : null;
    final previewsStream = context.read<ChatRepository>().watchChatroom(currentUser);

    return StreamBuilder(
      stream: previewsStream,
      builder: (context, snapshot) {
        final previews = snapshot.data ?? const <ChatPreview>[];

        // map previews by partnerId for quick lookup
        final previewByPartner = <String, ChatPreview>{};
        for (final preview in previews) {
          final partnerId = preview.participants.firstWhere((id) => id != currentUser?.uid, orElse: () => '');
          if (partnerId.isNotEmpty) previewByPartner[partnerId] = preview;
        }

        return BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserError) {
              return Center(
                child: Text(
                  state.errorText,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              );
            }

            if (state is UsersLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (state is UsersLoaded) {
              return ListView(
                children: state.permittedUsers.isEmpty
                    ? [
                        Center(
                          child: Text(
                            "There is no one to talk to just yet...",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                        SizedBox(height: 30),
                        Icon(Icons.no_accounts, size: 100)
                      ]
                    : state.permittedUsers.map<Widget>(
                        (userData) {
                          if (userData.email == currentUser?.email) return SizedBox.shrink();
                          final preview = previewByPartner[userData.uid];
                          return ChatTile(
                              chatPartnerName: userData.username,
                              chatPartnerId: userData.uid,
                              lastMessageText: preview?.lastMessageText ?? '',
                              lastMessageTimestamp: preview?.lastMessageTimestamp,
                              profileImage: userData.profileImage,
                              lastSeen: userData.lastSeen);
                        },
                      ).toList(),
              );
            }
            return SizedBox.shrink();
          },
        );
      },
    );
  }
}
