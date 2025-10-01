import 'package:flutter/material.dart';
import 'package:messenger_app/features/auth/auth_service.dart';

import 'package:messenger_app/features/chat/presentation/widgets/custom_drawer.dart';
import 'package:messenger_app/features/chat/presentation/widgets/user_list_view.dart';
import 'package:messenger_app/features/chat/service/chat_service.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final _chatService = ChatService();
  final _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      drawer: CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: UserListView(
          chatService: _chatService,
          authService: _authService,
        ),
      ),
    );
  }
}
