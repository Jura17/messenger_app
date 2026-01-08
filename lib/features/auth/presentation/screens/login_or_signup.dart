import 'package:flutter/material.dart';

import 'package:messenger_app/features/auth/presentation/screens/login_screen.dart';
import 'package:messenger_app/features/auth/presentation/screens/sign_up_screen.dart';

class LoginOrSignup extends StatefulWidget {
  const LoginOrSignup({super.key});

  @override
  State<LoginOrSignup> createState() => _LoginOrSignupState();
}

class _LoginOrSignupState extends State<LoginOrSignup> {
  bool showLogin = true;

  @override
  Widget build(BuildContext context) {
    return showLogin
        ? LoginScreen(
            onTap: toggleScreens,
          )
        : SignUpScreen(
            onTap: toggleScreens,
          );
  }

  void toggleScreens() {
    setState(() {
      showLogin = !showLogin;
    });
  }
}
