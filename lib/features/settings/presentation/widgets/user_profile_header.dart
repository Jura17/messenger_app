import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_app/features/users/cubits/current_user_cubit.dart';
import 'package:messenger_app/features/users/cubits/current_user_state.dart';

import 'package:messenger_app/utils/get_username_initials.dart';

class UserProfileHeader extends StatefulWidget {
  const UserProfileHeader({
    super.key,
    required this.username,
    required this.email,
  });

  final String? username;
  final String? email;

  @override
  State<UserProfileHeader> createState() => _UserProfileHeaderState();
}

class _UserProfileHeaderState extends State<UserProfileHeader> {
  @override
  Widget build(BuildContext context) {
    final usernameInitials = getUsernameInitials(widget.username);

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            debugPrint("Selecting image...");
          },
          child: Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).highlightColor,
            ),
            child: Center(
              child: Text(
                usernameInitials ?? "PH",
                style:
                    Theme.of(context).textTheme.displaySmall?.copyWith(color: Theme.of(context).colorScheme.tertiary),
              ),
            ),
          ),
        ),
        BlocBuilder<CurrentUserCubit, CurrentUserState>(builder: (context, state) {
          if (state is CurrentUserLoading) {
            return CircularProgressIndicator();
          }
          if (state is CurrentUserError) {
            return Text(state.message);
          }
          if (state is CurrentUserLoaded) {
            return Text(
              state.currentUser.username,
              style: Theme.of(context).textTheme.displaySmall,
            );
          }
          return Text("Unknown error");
        }),
        // Text(
        //   widget.username ?? "Current User",
        //   style: Theme.of(context).textTheme.displaySmall,
        // ),
        Text(widget.email!, style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }
}

Future<void> pickImage() async {}
