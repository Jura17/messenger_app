import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:messenger_app/features/chat/presentation/screens/home_screen.dart';
import 'package:messenger_app/features/settings/presentation/screens/settings_screen.dart';
import 'package:messenger_app/features/users/cubits/current_user_cubit.dart';

class NavigationScaffold extends StatefulWidget {
  const NavigationScaffold({super.key});

  @override
  State<NavigationScaffold> createState() => _NavigationScaffoldState();
}

class _NavigationScaffoldState extends State<NavigationScaffold> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed || state == AppLifecycleState.paused) {
      print("update");
      context.read<CurrentUserCubit>().updateLastSeen();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

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
