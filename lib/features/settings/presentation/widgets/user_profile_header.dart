import 'package:flutter/material.dart';

import 'package:messenger_app/utils/get_username_initials.dart';

class UserProfileHeader extends StatelessWidget {
  const UserProfileHeader({
    super.key,
    required this.username,
    required this.email,
  });

  final String? username;
  final String? email;

  @override
  Widget build(BuildContext context) {
    final usernameInitials = getUsernameInitials(username);

    return Column(
      children: [
        Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).highlightColor,
          ),
          child: Center(
              child: Text(
            usernameInitials ?? "PH",
            style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Theme.of(context).colorScheme.tertiary),
          )),
        ),
        Text(
          username ?? "Current User",
          style: Theme.of(context).textTheme.displaySmall,
        ),
        Text(email!, style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }
}
