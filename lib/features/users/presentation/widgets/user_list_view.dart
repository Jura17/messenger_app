import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_app/features/auth/bloc/auth_bloc.dart';
import 'package:messenger_app/features/auth/bloc/auth_state.dart';

import 'package:messenger_app/features/users/bloc/user_bloc.dart';

import 'package:messenger_app/features/users/bloc/user_state.dart';

import 'package:messenger_app/features/users/presentation/widgets/user_tile.dart';

class UserListView extends StatefulWidget {
  const UserListView({super.key});

  @override
  State<UserListView> createState() => _UserListViewState();
}

class _UserListViewState extends State<UserListView> {
  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;

    String? currentUserEmail;

    if (authState is Authenticated) {
      currentUserEmail = authState.user.email;
    }

    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserError) {
          return Center(
            child: Text(
              state.errorText,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        }

        if (state is UsersLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (state is UsersLoaded) {
          return ListView(
            children: state.permittedUsers.map<Widget>(
              (userData) {
                if (userData.email == currentUserEmail) return SizedBox.shrink();
                return UserTile(
                  email: userData.email,
                  chatPartnerEmail: userData.email,
                  chatPartnerId: userData.uid,
                );
              },
            ).toList(),
          );
        }

        return SizedBox.shrink();
      },
    );
  }
}
