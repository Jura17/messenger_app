import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_app/features/auth/bloc/auth_bloc.dart';

import 'package:messenger_app/features/auth/bloc/auth_state.dart';

import 'package:messenger_app/features/auth/presentation/screens/login_or_register.dart';
import 'package:messenger_app/features/chat/presentation/screens/home_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthInitial) {
            return LoginOrRegister();
          } else if (state is AuthError) {
            // TODO: implement better error handling here
            return const LoginOrRegister();
          } else if (state is Unauthenticated) {
            return const LoginOrRegister();
          } else if (state is Authenticated) {
            return HomeScreen();
          }
          throw Exception("Some unknown auth problem in AuthGate...");
        },
      ),
    );
  }
}
