import 'package:flutter/material.dart';
import 'package:messenger_app/core/theme/custom_colors.dart';
import 'package:messenger_app/features/chat/presentation/screens/chat_screen.dart';

class UserTile extends StatelessWidget {
  const UserTile({
    super.key,
    required this.email,
    required this.receiverEmail,
    required this.receiverID,
    required this.updateUnread,
    required this.unreadMessagesCount,
  });

  final String email;
  final String receiverEmail;
  final String receiverID;
  final void Function() updateUnread;
  final int unreadMessagesCount;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              receiverEmail: receiverEmail,
              receiverID: receiverID,
              updateUnread: updateUnread,
            ),
          ),
        );
      },
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(Icons.person, color: Theme.of(context).colorScheme.inversePrimary),
            Text(
              email,
              style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
            ),
            Spacer(),
            if (unreadMessagesCount > 0)
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.lightGreen),
                child: Text(
                  unreadMessagesCount.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
