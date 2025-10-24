import 'package:flutter/material.dart';
import 'package:messenger_app/features/settings/presentation/widgets/blocked_user_tile.dart';
import 'package:messenger_app/features/users/bloc/user_state.dart';

class BlockedUserListView extends StatelessWidget {
  const BlockedUserListView({
    super.key,
    required this.currentUserEmail,
    required this.state,
  });

  final String? currentUserEmail;
  final UsersLoaded state;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: state.blockedUsers.length,
      itemBuilder: (context, index) {
        final userData = state.blockedUsers[index];
        if (userData.email == currentUserEmail) {
          return SizedBox.shrink();
        }

        return BlockedUserTile(
          key: ValueKey(userData.uid),
          user: userData,
        );
      },
    );
  }
}
