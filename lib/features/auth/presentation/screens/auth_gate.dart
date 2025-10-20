import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_app/features/auth/bloc/auth_bloc.dart';

import 'package:messenger_app/features/auth/bloc/auth_state.dart';

import 'package:messenger_app/features/auth/presentation/screens/login_or_register.dart';
import 'package:messenger_app/features/chat/presentation/screens/home_screen.dart';
import 'package:messenger_app/features/users/bloc/user_bloc.dart';

import 'package:messenger_app/features/users/data/repositories/firestore_userdata_repository.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AuthInitial) {
            debugPrint("Auth initial");
            return LoginOrRegister();
          } else if (state is AuthError) {
            debugPrint("AuthError");
            // TODO: implement better error handling here
            return const LoginOrRegister();
            // return Center(child: Text(state.message));
          } else if (state is Unauthenticated) {
            debugPrint("Unauthenticated");
            return const LoginOrRegister();
          } else if (state is Authenticated) {
            final userRepo = context.read<FirestoreUserdataRepository>();

            return BlocProvider(
              create: (_) => UserBloc(userRepo: userRepo),
              child: HomeScreen(),
            );
          }
          throw Exception("Some unknown auth problem in AuthGate...");
        },
      ),
    );
  }
}
