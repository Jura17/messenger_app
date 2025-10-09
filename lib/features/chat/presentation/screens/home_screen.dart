import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_app/features/auth/auth_service.dart';
import 'package:messenger_app/features/auth/bloc/auth_bloc.dart';
import 'package:messenger_app/features/auth/bloc/auth_event.dart';
import 'package:messenger_app/features/auth/bloc/auth_state.dart';

import 'package:messenger_app/features/chat/presentation/widgets/custom_drawer.dart';
import 'package:messenger_app/features/users/presentation/widgets/user_list_view.dart';
import 'package:messenger_app/features/chat/chat_service.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  // final _chatService = ChatService();
  // final _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    final currentState = authBloc.state;

    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      // drawer: CustomDrawer(),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextButton(
            onPressed: () {
              authBloc.add(LogoutRequested());
            },
            child: Text("Logout, ${currentState is Authenticated ? currentState.user.email : null}"),
          )
          // child: UserListView(
          //   chatService: _chatService,
          //   authService: _authService,
          // ),
          ),
    );
  }
}
