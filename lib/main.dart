import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:messenger_app/core/theme/theme_provider.dart';
import 'package:messenger_app/features/auth/bloc/auth_bloc.dart';
import 'package:messenger_app/features/auth/bloc/auth_event.dart';
import 'package:messenger_app/features/auth/data/provider/firebase_auth_api.dart';
import 'package:messenger_app/features/auth/data/repositories/firebase_auth_repository.dart';

import 'package:messenger_app/features/auth/presentation/screens/auth_gate.dart';

import 'package:messenger_app/features/chat/data/provider/firestore_chat_api.dart';
import 'package:messenger_app/features/chat/data/repositories/firestore_chat_repository.dart';
import 'package:messenger_app/features/users/bloc/user_bloc.dart';

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
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final firebaseAuth = FirebaseAuth.instance;
    final firestoreDb = FirebaseFirestore.instance;

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => FirebaseAuthApi(firebaseAuth)),
        RepositoryProvider(create: (context) {
          final authApi = context.read<FirebaseAuthApi>();
          return FirestoreUserdataApi(firestoreDb, authApi);
        }),
        RepositoryProvider(create: (context) {
          final authApi = context.read<FirebaseAuthApi>();
          final userdataApi = context.read<FirestoreUserdataApi>();
          return FirebaseAuthRepository(authApi, userdataApi);
        }),
        RepositoryProvider(create: (context) {
          final authRepo = context.read<FirebaseAuthRepository>();
          return FirestoreChatRepository(FirestoreChatApi(firestoreDb, authRepo));
        }),
        RepositoryProvider(create: (context) {
          final authApi = context.read<FirebaseAuthApi>();
          final userdataApi = context.read<FirestoreUserdataApi>();
          return FirestoreUserdataRepository(userdataApi, authApi);
        })
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) {
              final authRepo = context.read<FirebaseAuthRepository>();
              final authBloc = AuthBloc(authRepo: authRepo);
              authBloc.add(AppStarted());
              return authBloc;
            },
          ),
          BlocProvider<UserBloc>(
            create: (context) {
              final userRepo = context.read<FirestoreUserdataRepository>();
              final userBloc = UserBloc(userRepo: userRepo);
              return userBloc;
            },
          ),
        ],
        child: MaterialApp(
          home: const AuthGate(),
          debugShowCheckedModeBanner: false,
          theme: context.watch<ThemeProvider>().themeData,
        ),
      ),
    );
  }
}
