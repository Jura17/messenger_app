import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messenger_app/core/theme/theme_provider.dart';
import 'package:messenger_app/features/auth/auth_service.dart';
import 'package:messenger_app/features/settings/presentation/screens/blocked_users_screen.dart';
import 'package:messenger_app/features/settings/presentation/widgets/settings_list_tile.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
          style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          spacing: 10,
          children: [
            // Dark mode
            SettingsListTile(
              title: "Dark Mode",
              action: CupertinoSwitch(
                value: Provider.of<ThemeProvider>(context, listen: false).isDarkMode,
                onChanged: (value) => Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),
              ),
              foregroundColor: Theme.of(context).colorScheme.inversePrimary,
            ),
            // Blocked Users
            SettingsListTile(
              title: "Blocked Users",
              action: IconButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => BlockedUsersScreen())),
                icon: Icon(
                  Icons.arrow_forward_rounded,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
              foregroundColor: Theme.of(context).colorScheme.inversePrimary,
              wholeSurfaceTapable: true,
            ),
            SettingsListTile(
              title: "Delete Account",
              action: IconButton(
                onPressed: () => accountDeletionRequest(context),
                icon: Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                ),
              ),
              foregroundColor: Colors.white,
              backgroundColor: Colors.red,
              fontWeight: FontWeight.bold,
              wholeSurfaceTapable: true,
            )
          ],
        ),
      ),
    );
  }

  void accountDeletionRequest(BuildContext context) async {
    bool confirm = await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
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
                    child: const Text("Delete"),
                  ),
                ],
              );
            }) ??
        false;

    if (confirm) {
      try {
        final authService = AuthService();
        Navigator.pop(context);
        await authService.deleteAccount();
      } catch (e) {
        debugPrint("Deleting account failed: $e");
      }
    }
  }
}
