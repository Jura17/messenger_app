import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:messenger_app/features/chat/data/repositories/firestore_chat_repository.dart';

import 'package:messenger_app/features/chat/presentation/widgets/message_list.dart';
import 'package:messenger_app/features/chat/presentation/widgets/message_input.dart';

class ChatScreen extends StatefulWidget {
  final String chatPartnerEmail;
  final String chatPartnerId;

  const ChatScreen({
    super.key,
    required this.chatPartnerEmail,
    required this.chatPartnerId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  // bool _showScrollToBottom = true;

  // void _scrollListener() {
  //   final maxScroll = _scrollController.position.maxScrollExtent;
  //   final offset = _scrollController.offset;

  //   if (offset < maxScroll && !_showScrollToBottom) {
  //     setState(() {
  //       _showScrollToBottom = true;
  //     });
  //   } else if (offset >= maxScroll && _showScrollToBottom) {
  //     setState(() {
  //       _showScrollToBottom = false;
  //     });
  //   }
  // }

  @override
  void initState() {
    super.initState();
    // _scrollController.addListener(_scrollListener);

    Future.delayed(
      const Duration(milliseconds: 500),
      () {
        scrollDown();
        context.read<FirestoreChatRepository>().markMessagesAsRead(widget.chatPartnerId);
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatPartnerEmail),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: MessageList(
                scrollController: _scrollController,
                chatPartnerId: widget.chatPartnerId,
              ),
            ),
            MessageInput(
              scrollDown: scrollDown,
              receiverId: widget.chatPartnerId,
            )
          ],
        ),
      ),
      floatingActionButton: GestureDetector(
        onTap: scrollDown,
        child: Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(bottom: 70),
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary, shape: BoxShape.circle),
          child: const Icon(
            Icons.expand_more,
            size: 30,
          ),
        ),
      ),
    );
  }

  void scrollDown() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }
}
