import 'package:flutter/material.dart';
import 'package:messenger_app/features/auth/auth_service.dart';
import 'package:messenger_app/features/settings/presentation/widgets/blocked_user_tile.dart';
import 'package:messenger_app/features/chat/chat_service.dart';

class BlockedUsersScreen extends StatelessWidget {
  BlockedUsersScreen({super.key});

  // final chatService = ChatService();
  final authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final currentUserId = authService.getCurrentUser()!.uid;

    // TODO: Add BlocBuilder in body
    return Scaffold(
      appBar: AppBar(
        title: Text("Blocked Users"),
        actions: [],
      ),
      // body: StreamBuilder<List<Map<String, dynamic>>>(
      //     stream: chatService.getBlockedUsers(currentUserId),
      //     builder: (context, snapshot) {
      //       if (snapshot.hasError) {
      //         return const Center(
      //           child: Text("Error loading blocked users..."),
      //         );
      //       }
      //       if (snapshot.connectionState == ConnectionState.waiting) {
      //         return const CircularProgressIndicator();
      //       }
      //       final blockedUsers = snapshot.data ?? [];
      //       if (blockedUsers.isEmpty) {
      //         return const Center(
      //           child: Text("No blocked users"),
      //         );
      //       }

      //       return ListView.builder(
      //         itemCount: blockedUsers.length,
      //         itemBuilder: (context, index) {
      //           final user = blockedUsers[index];
      //           return BlockedUserTile(user: user);
      //         },
      //       );
      //     }),
    );
  }
}
