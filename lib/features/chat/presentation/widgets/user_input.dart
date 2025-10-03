import 'package:flutter/material.dart';
import 'package:messenger_app/features/auth/auth_service.dart';

import 'package:messenger_app/features/chat/presentation/widgets/message_textfield.dart';
import 'package:messenger_app/features/chat/service/chat_service.dart';

class UserInput extends StatefulWidget {
  const UserInput({
    super.key,
    required this.receiverID,
    required this.scrollDown,
  });

  final void Function() scrollDown;
  final String receiverID;

  @override
  State<UserInput> createState() => _UserInputState();
}

class _UserInputState extends State<UserInput> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService chatService = ChatService();
  final AuthService authService = AuthService();

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
          onPressed: sendMessage,
          icon: const Icon(Icons.send),
        ),
        SizedBox(width: 15),
      ],
    );
  }

  void sendMessage() async {
    if (_messageController.text.isEmpty) return;
    await chatService.sendMessage(widget.receiverID, _messageController.text);
    _messageController.clear();
    widget.scrollDown();
  }
}
