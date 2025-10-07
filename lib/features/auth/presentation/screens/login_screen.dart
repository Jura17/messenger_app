import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_app/features/auth/bloc/auth_bloc.dart';
import 'package:messenger_app/features/auth/bloc/auth_event.dart';

import 'package:messenger_app/features/auth/presentation/widgets/custom_button.dart';
import 'package:messenger_app/features/auth/presentation/widgets/custom_textfield.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final void Function()? onTap;

  LoginScreen({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.message,
            size: 60,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 50),
          Text(
            "Welcome back",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 25),
          CustomTextfield(
            hintText: "Email",
            controller: _emailController,
          ),
          SizedBox(height: 10),
          CustomTextfield(
            hintText: "Password",
            obscureText: true,
            controller: _passwordController,
          ),
          const SizedBox(height: 25),
          CustomButton(
            text: "Login",
            onTap: () => login(context),
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Not a member? ",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              GestureDetector(
                onTap: onTap,
                child: Text(
                  "Register now",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void login(BuildContext context) async {
    // final authService = AuthService();
    final authBloc = context.read<AuthBloc>();

    try {
      authBloc.add(LoginRequested(_emailController.text, _passwordController.text));
      // await authService.signInWithEmailPassword(
      //   _emailController.text,
      //   _passwordController.text,
      // );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(e.toString()),
        ),
      );
    }
  }
}
