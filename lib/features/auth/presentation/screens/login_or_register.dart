import 'package:flutter/material.dart';
import 'package:messenger_app/features/auth/presentation/screens/login_screen.dart';
import 'package:messenger_app/features/auth/presentation/screens/register_screen.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool showLogin = true;

  @override
  Widget build(BuildContext context) {
    return showLogin
        ? LoginScreen(
            onTap: toggleScreens,
          )
        : RegisterScreen(
            onTap: toggleScreens,
          );
  }

  void toggleScreens() {
    setState(() {
      showLogin = !showLogin;
    });
  }
}
