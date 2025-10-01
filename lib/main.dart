import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:messenger_app/core/theme/light_theme.dart';
import 'package:messenger_app/core/theme/theme_provider.dart';
import 'package:messenger_app/features/auth/data/provider/auth_api.dart';
import 'package:messenger_app/features/auth/data/provider/firebase_auth_api.dart';
import 'package:messenger_app/features/auth/data/repos/firebase_auth_repository.dart';

import 'package:messenger_app/features/auth/presentation/screens/auth_gate.dart';
import 'package:messenger_app/features/notifications/notification_service.dart';
import 'package:messenger_app/firebase_options.dart';
import 'package:provider/provider.dart';

// TODO: Create UserData class incl. username
// TODO: implement BloC
// TODO: Don't show all registered users; show chatrooms/conversations of current user
// TODO: add Search function to find users by email address or username
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // final FirebaseAuth auth = FirebaseAuth.instance;
  // final FirebaseFirestore db = FirebaseFirestore.instance;
  // final AuthApi authApi = FirebaseAuthApi(auth: auth, db: db);
  // final FirebaseAuthRepository authRepo = FirebaseAuthRepository(authApi);

  // FirebaseAuthApi _api = FirebaseAuthApi(auth: auth, db: db);

  // runApp(MainApp(auth: _api));

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  final notificationService = NotificationService();
  await notificationService.requestPersmission();
  notificationService.setupInteractions();

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MainApp(),
    ),
  );
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("Handling a background message: ${message.messageId}");
  debugPrint("Message data: ${message.data}");
  debugPrint("Message notification: ${message.notification?.title}");
  debugPrint("Message notification: ${message.notification?.body}");
}

class MainApp extends StatelessWidget {
  const MainApp({
    super.key,
    // required this.auth,
  });

  // final FirebaseAuthApi auth;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthGate(
          // auth: auth,
          ),
      theme: context.watch<ThemeProvider>().themeData,
    );
  }
}
