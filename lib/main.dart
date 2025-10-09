import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:messenger_app/core/theme/theme_provider.dart';
import 'package:messenger_app/features/auth/bloc/auth_bloc.dart';
import 'package:messenger_app/features/auth/data/provider/firebase_auth_api.dart';
import 'package:messenger_app/features/auth/data/repositories/firebase_auth_repository.dart';

import 'package:messenger_app/features/auth/presentation/screens/auth_gate.dart';
import 'package:messenger_app/features/users/data/provider/firestore_userdata_api.dart';
import 'package:messenger_app/features/users/data/repositories/firestore_userdata_repository.dart';
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
    return BlocProvider(
      create: (context) {
        final auth = FirebaseAuth.instance;
        final firestoreDb = FirebaseFirestore.instance;
        final authApi = FirebaseAuthApi(auth);
        final userdataApi = FirestoreUserdataApi(firestoreDb, authApi);
        final userdataRepo = FirestoreUserdataRepository(userdataApi, authApi);
        final authRepo = FirebaseAuthRepository(authApi, userdataApi);
        final authBloc = AuthBloc(authRepo: authRepo);
        return authBloc;
      },
      child: MaterialApp(
        home: AuthGate(),
        debugShowCheckedModeBanner: false,
        theme: context.watch<ThemeProvider>().themeData,
      ),
    );
  }
}
