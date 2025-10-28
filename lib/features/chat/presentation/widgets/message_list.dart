import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:messenger_app/features/chat/bloc/chat_bloc.dart';

import 'package:messenger_app/features/chat/bloc/chat_state.dart';
import 'package:messenger_app/features/chat/data/models/message.dart';
import 'package:messenger_app/features/chat/data/models/message_with_date_time_marker.dart';

import 'package:messenger_app/features/chat/presentation/widgets/message_list_bubble.dart';

class MessageList extends StatelessWidget {
  const MessageList({
    super.key,
    required this.chatPartnerId,
    required this.scrollController,
  });

  final String chatPartnerId;
  final ScrollController scrollController;

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
          final preparedMessages = prepareMessages(state.messages!);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              controller: scrollController,
              itemCount: preparedMessages.length,
              itemBuilder: (context, index) {
                final messageItem = preparedMessages[index];

                final String time = DateFormat.Hm().format(messageItem.message.timestamp.toDate());
                final String date = formatChatDate(messageItem.message.timestamp.toDate());

                return Column(
                  children: [
                    if (messageItem.showDate)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          date,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    MessageListBubble(
                      message: messageItem.message,
                      time: messageItem.showTime ? time : null,
                    ),
                  ],
                );
              },
            ),
          );
        }
        return SizedBox.shrink();
      },
    );
  }

  String formatChatDate(DateTime datetime) {
    final now = DateTime.now();
    final difference = now.difference(datetime).inDays;
    if (difference == 0) return 'Today';
    if (difference == 1) return 'Yesterday';
    return DateFormat.MMMEd().format(datetime);
  }

  // decide if time & date needs to be shown in advance
  // (reason: ListView.builder renders them inconsistently when scrolling too fast)
  List<MessageWithDateTimeMarker> prepareMessages(List<Message> messages) {
    final result = <MessageWithDateTimeMarker>[];
    String? lastDate;
    String? lastTime;

    for (final message in messages) {
      final date = DateFormat.MMMEd().format(message.timestamp.toDate());
      final time = DateFormat.Hm().format(message.timestamp.toDate());
      final showDate = date != lastDate;
      final showTime = time != lastTime;
      lastDate = date;
      lastTime = time;
      result.add(
        MessageWithDateTimeMarker(
          message: message,
          showDate: showDate,
          showTime: showTime,
        ),
      );
    }

    return result;
  }
}
