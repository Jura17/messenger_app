import 'package:flutter/material.dart';
import 'package:messenger_app/features/auth/auth_service.dart';

import 'package:messenger_app/features/chat/presentation/widgets/user_tile.dart';
import 'package:messenger_app/features/chat/service/chat_service.dart';

class UserListView extends StatefulWidget {
  const UserListView({
    super.key,
    required ChatService chatService,
    required AuthService authService,
  })  : _chatService = chatService,
        _authService = authService;

  final ChatService _chatService;
  final AuthService _authService;

  @override
  State<UserListView> createState() => _UserListViewState();
}

class _UserListViewState extends State<UserListView> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget._chatService.getPermittedUsers(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Error while loading users: ${snapshot.error}");
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: const CircularProgressIndicator());
        }

        return ListView(
          children: snapshot.data!.map<Widget>((userData) {
            if (userData["email"] != widget._authService.getCurrentUser()?.email) {
              return UserTile(
                email: userData["email"],
                unreadMessagesCount: userData["unreadCount"],
                receiverEmail: userData["email"],
                receiverID: userData["uid"],
                updateUnread: updateUnread,
              );
            } else {
              return Container();
            }
          }).toList(),
        );
      },
    );
  }

  void updateUnread() {
    setState(() {});
  }
}
