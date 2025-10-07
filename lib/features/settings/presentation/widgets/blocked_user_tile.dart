import 'package:flutter/material.dart';
import 'package:messenger_app/features/chat/service/chat_service.dart';

class BlockedUserTile extends StatelessWidget {
  const BlockedUserTile({
    super.key,
    required this.user,
  });

  final Map<String, dynamic> user;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        _showUnblockBox(context, user['uid']);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            const Icon(Icons.person),
            Text(user['email']),
          ],
        ),
      ),
    );
  }

  void _showUnblockBox(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Unblock User"),
        content: const Text("Are you sure you want to unblock this user?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              final chatService = ChatService();
              chatService.unblockUser(userId);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("User unblocked!")));
            },
            child: const Text("Unblock"),
          ),
        ],
      ),
    );
  }
}
