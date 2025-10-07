import 'package:flutter/material.dart';
import 'package:messenger_app/features/auth/auth_service.dart';
import 'package:messenger_app/features/settings/presentation/screens/settings_screen.dart';
import 'package:messenger_app/features/chat/presentation/widgets/drawer_menu_item.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();
    final currentUser = auth.getCurrentUser()!.email;

    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(80.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.message,
                      color: Theme.of(context).colorScheme.primary,
                      size: 60,
                    ),
                    Text(currentUser!)
                  ],
                ),
              ),
            ),
            Divider(
              color: Theme.of(context).colorScheme.secondary,
              indent: 25,
              endIndent: 25,
            ),
            DrawerMenuItem(
              title: "H O M E",
              iconData: Icons.home,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            DrawerMenuItem(
              title: "S E T T I N G S",
              iconData: Icons.settings,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen()));
              },
            ),
            Spacer(),
            DrawerMenuItem(
              onTap: () {
                final authService = AuthService();
                authService.signOut();
              },
              title: "L O G O U T",
              iconData: Icons.logout,
            ),
          ],
        ),
      ),
    );
  }
}
