import 'package:flutter/material.dart';
import 'package:messenger_app/features/chat/presentation/widgets/message_list.dart';
import 'package:messenger_app/features/chat/presentation/widgets/user_input.dart';
import 'package:messenger_app/features/chat/service/chat_service.dart';

class ChatScreen extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;
  final void Function() updateUnread;

  const ChatScreen({
    super.key,
    required this.receiverEmail,
    required this.receiverID,
    required this.updateUnread,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FocusNode _textInputFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(milliseconds: 500),
      () {
        scrollDown();
        final chatService = ChatService();
        chatService.markMessagesAsRead(widget.receiverID);
        widget.updateUnread();
      },
    );

    _textInputFocusNode.addListener(() {
      if (_textInputFocusNode.hasFocus) {
        Future.delayed(
          const Duration(milliseconds: 500),
          () => scrollDown(),
        );
      }
    });
  }

  @override
  void dispose() {
    _textInputFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverEmail),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: MessageList(
                scrollController: _scrollController,
                receiverEmail: widget.receiverEmail,
                receiverID: widget.receiverID,
              ),
            ),
            UserInput(
              scrollDown: scrollDown,
              receiverID: widget.receiverID,
              focusNode: _textInputFocusNode,
            )
          ],
        ),
      ),
    );
  }

  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }
}
