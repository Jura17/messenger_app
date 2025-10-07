import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:messenger_app/core/theme/theme_provider.dart';

import 'package:messenger_app/features/auth/presentation/screens/auth_gate.dart';
import 'package:messenger_app/firebase_options.dart';
import 'package:provider/provider.dart';

// TODO: implement BloC
// TODO: Don't show all registered users; show chatrooms/conversations of current user
// TODO: add Search function to find users by email address or username
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AuthGate(),
      debugShowCheckedModeBanner: false,
      theme: context.watch<ThemeProvider>().themeData,
    );
  }
}
