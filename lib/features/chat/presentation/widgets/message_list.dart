import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:messenger_app/features/chat/bloc/chat_bloc.dart';

import 'package:messenger_app/features/chat/bloc/chat_state.dart';

import 'package:messenger_app/features/chat/presentation/widgets/message_list_bubble.dart';

class MessageList extends StatefulWidget {
  const MessageList({
    super.key,
    required this.chatPartnerId,
    required this.scrollController,
  });

  final String chatPartnerId;
  final ScrollController scrollController;

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  String? previousMessageTime;
  String? displayedMessageTime;
  String? previousDate;
  String? displayedDate;

  // TODO: Fix bug that makes time and date disappear on message sent
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if (state is ChatLoading) {
          return CircularProgressIndicator();
        }
        if (state is ChatError) {
          return Text(state.errorText);
        }

        if (state is ChatLoaded && state.messages != null) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              controller: widget.scrollController,
              children: state.messages!.map((message) {
                final Timestamp timestamp = message.timestamp;
                final String dateTime = DateFormat.Hm().format(timestamp.toDate());
                final String date = DateFormat.MMMEd().format(timestamp.toDate());

                // only show the message time if it has changed
                if (dateTime != previousMessageTime) {
                  displayedMessageTime = dateTime;
                  previousMessageTime = dateTime;
                } else {
                  displayedMessageTime = null;
                }

                // only show date if it has changed
                if (date != previousDate) {
                  displayedDate = date;
                  previousDate = date;
                } else {
                  displayedDate = null;
                }

                return Column(
                  children: [
                    if (displayedDate != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          displayedDate.toString(),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    MessageListBubble(
                      message: message,
                      time: displayedMessageTime,
                    ),
                  ],
                );
              }).toList(),
            ),
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}
