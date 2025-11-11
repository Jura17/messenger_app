import 'package:flutter/material.dart';
import 'package:messenger_app/utils/get_username_initials.dart';

class UserSettingsTile extends StatelessWidget {
  const UserSettingsTile({
    super.key,
    required this.currentUserEmail,
    required this.username,
  });

  final String? currentUserEmail;
  final String? username;

  @override
  Widget build(BuildContext context) {
    final usernameInitials = getUsernameInitials(username);

    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.secondary,
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: double.infinity,
              width: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.tertiary,
              ),
              child: Center(child: Text(usernameInitials ?? "PH")),
            ),
            SizedBox(width: 15),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(username ?? "Current User"),
                Text(
                  currentUserEmail!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
            Spacer(),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.arrow_forward_ios_rounded,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
