import 'package:flutter/material.dart';
import 'package:messenger_app/features/auth/auth_service.dart';

import 'package:messenger_app/features/auth/presentation/widgets/custom_button.dart';
import 'package:messenger_app/features/auth/presentation/widgets/custom_textfield.dart';

class RegisterScreen extends StatelessWidget {
  // final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final void Function()? onTap;

  RegisterScreen({
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
            "Let's create an account",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 25),
          // CustomTextfield(
          //   hintText: "Username",
          //   controller: _usernameController,
          // ),
          SizedBox(height: 10),
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
          SizedBox(height: 10),
          CustomTextfield(
            hintText: "Confirm password",
            obscureText: true,
            controller: _confirmPasswordController,
          ),
          const SizedBox(height: 25),
          CustomButton(
            text: "Register",
            onTap: () => register(context),
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Already a member? ",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              GestureDetector(
                onTap: onTap,
                child: Text(
                  "Login now",
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

  void register(BuildContext context) {
    final authService = AuthService();
    if (_passwordController.text == _confirmPasswordController.text) {
      try {
        authService.signUpWithEmailPassword(
          // username: _usernameController.text,
          email: _emailController.text,
          password: _passwordController.text,
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => const AlertDialog(
            title: Text("Passwords don't match!"),
          ),
        );
      }
    }
  }
}
