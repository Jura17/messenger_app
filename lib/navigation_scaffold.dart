import 'package:flutter/material.dart';

import 'package:messenger_app/features/chat/presentation/screens/home_screen.dart';
import 'package:messenger_app/features/settings/presentation/screens/settings_screen.dart';

class NavigationScaffold extends StatefulWidget {
  const NavigationScaffold({super.key});

  @override
  State<NavigationScaffold> createState() => _NavigationScaffoldState();
}

class _NavigationScaffoldState extends State<NavigationScaffold> {
  int _activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeScreen(),
      SettingsScreen(),
    ];

    return Scaffold(
      body: pages[_activeIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) => setState(() {
          _activeIndex = value;
        }),
        currentIndex: _activeIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Chats'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
