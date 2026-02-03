import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import 'package:messenger_app/features/auth/data/repositories/auth_repository.dart';

Future<bool> showReauthenticationDialog(BuildContext context) async {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  return await showDialog<bool>(
        context: context,
        builder: (context) {
          final navigator = Navigator.of(context);
          String errorText = "";

          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              title: const Text("Re-authentication needed"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("This action is sensitive and requires recent authentication. Please login again to proceed."),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(labelText: "Email"),
                  ),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(labelText: "Password"),
                  ),
                  if (errorText.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      errorText,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    navigator.pop(false);
                  },
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () async {
                    try {
                      await context
                          .read<AuthRepository>()
                          .reauthenticateUser(emailController.text.trim(), passwordController.text.trim());
                      navigator.pop(true);
                    } catch (e) {
                      setState(() {
                        errorText = "Please check your login details";
                      });
                    }
                  },
                  child: const Text(
                    "Confirm",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            );
          });
        },
      ) ??
      false;
}

Future<bool> accountDeletionRequest(BuildContext context) async {
  bool confirm = await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              title: const Text("Confirm Delete"),
              content: Text("This will delete your account permanently. Are you sure you want to proceed?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text(
                    "Delete",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            );
          }) ??
      false;
  return confirm;
}
