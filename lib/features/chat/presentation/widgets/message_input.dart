import 'package:flutter/material.dart';

import 'package:messenger_app/features/chat/bloc/chat_bloc.dart';
import 'package:messenger_app/features/chat/bloc/chat_event.dart';

import 'package:messenger_app/features/chat/presentation/widgets/message_textfield.dart';

import 'package:provider/provider.dart';

class MessageInput extends StatefulWidget {
  const MessageInput({
    super.key,
    required this.receiverId,
    required this.scrollDown,
  });

  final void Function() scrollDown;
  final String receiverId;

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final TextEditingController _messageController = TextEditingController();
  // final ChatService chatService = ChatService();
  // final AuthService authService = AuthService();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: MessageTextfield(
            hintText: "Type a message...",
            controller: _messageController,
          ),
        ),
        IconButton(
          onPressed: () {
            sendMessage(context);
          },
          icon: const Icon(Icons.send),
        ),
        SizedBox(width: 15),
      ],
    );
  }

  void sendMessage(BuildContext context) async {
    if (_messageController.text.isEmpty) return;
    context.read<ChatBloc>().add(SendMessage(widget.receiverId, _messageController.text));
    // await chatService.sendMessage(widget.receiverID, _messageController.text);
    _messageController.clear();
    widget.scrollDown();
  }
}
