import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:messenger_app/features/auth/presentation/screens/login_or_register.dart';
import 'package:messenger_app/features/chat/presentation/screens/home_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({
    super.key,
    // required this.auth,
  });

  // final FirebaseAuthRepository auth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          // stream: auth.onAuthChanged(),
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return HomeScreen();
            } else {
              return const LoginOrRegister();
            }
          }),
    );
  }
}
