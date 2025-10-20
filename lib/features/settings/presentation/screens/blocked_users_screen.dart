import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:messenger_app/features/auth/bloc/auth_bloc.dart';
import 'package:messenger_app/features/auth/bloc/auth_state.dart';
import 'package:messenger_app/features/settings/presentation/widgets/blocked_user_list_view.dart';

import 'package:messenger_app/features/users/bloc/user_bloc.dart';

import 'package:messenger_app/features/users/bloc/user_state.dart';

class BlockedUsersScreen extends StatelessWidget {
  const BlockedUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authBlocState = context.read<AuthBloc>().state;
    String? currentUserEmail;

    if (authBlocState is Authenticated) {
      currentUserEmail = authBlocState.user.email;
    }

    return Scaffold(
      appBar: AppBar(title: Text("Blocked Users")),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserError) {
            return Center(
              child: Text(
                state.errorText,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          }

          if (state is UsersLoaded) {
            if (state.blockedUsers.isEmpty) {
              return const Center(
                child: Text("No blocked users"),
              );
            }
            return BlockedUserListView(
              currentUserEmail: currentUserEmail,
              state: state,
            );
          }

          if (state is UsersLoading) {
            return Center(child: CircularProgressIndicator());
          }

          return SizedBox.shrink();
        },
      ),
    );
  }
}
