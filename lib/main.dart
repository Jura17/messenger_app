import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:messenger_app/core/theme/theme_cubit.dart';

import 'package:messenger_app/features/auth/bloc/auth_bloc.dart';
import 'package:messenger_app/features/auth/bloc/auth_event.dart';
import 'package:messenger_app/features/auth/data/provider/firebase_auth_api.dart';
import 'package:messenger_app/features/auth/data/repositories/firebase_auth_repository.dart';

import 'package:messenger_app/features/chat/bloc/chat_bloc.dart';

import 'package:messenger_app/features/chat/data/provider/firestore_chat_api.dart';
import 'package:messenger_app/features/chat/data/repositories/firestore_chat_repository.dart';
import 'package:messenger_app/features/users/bloc/user_bloc.dart';

import 'package:messenger_app/features/users/data/provider/firestore_userdata_api.dart';

import 'package:messenger_app/features/users/data/repositories/firestore_userdata_repository.dart';
import 'package:messenger_app/firebase_options.dart';
import 'package:messenger_app/main_app.dart';

import 'package:shared_preferences/shared_preferences.dart';

// TODO: Don't show all registered users; show chatrooms/conversations of current user
// TODO: add Search function to find users by email address or username
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final prefs = await SharedPreferences.getInstance();

  final firebaseAuth = FirebaseAuth.instance;
  final firestoreDb = FirebaseFirestore.instance;

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => FirebaseAuthApi(firebaseAuth)),
        RepositoryProvider(create: (context) => FirestoreUserdataApi(firestoreDb)),
        RepositoryProvider(create: (context) {
          final authApi = context.read<FirebaseAuthApi>();
          return FirebaseAuthRepository(authApi);
        }),
        RepositoryProvider(create: (context) {
          final chatApi = FirestoreChatApi(firestoreDb);
          return FirestoreChatRepository(chatApi);
        }),
        RepositoryProvider(create: (context) {
          final userdataApi = context.read<FirestoreUserdataApi>();
          return FirestoreUserdataRepository(userdataApi);
        })
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) {
              final authRepo = context.read<FirebaseAuthRepository>();
              final userRepo = context.read<FirestoreUserdataRepository>();
              final authBloc = AuthBloc(authRepo: authRepo, userRepo: userRepo);
              authBloc.add(AppStarted());
              return authBloc;
            },
          ),
          BlocProvider<UserBloc>(
            create: (context) {
              final userRepo = context.read<FirestoreUserdataRepository>();
              final authRepo = context.read<FirebaseAuthRepository>();
              final userBloc = UserBloc(authRepo: authRepo, userRepo: userRepo);
              return userBloc;
            },
          ),
          BlocProvider<ChatBloc>(
            create: (context) {
              final chatRepo = context.read<FirestoreChatRepository>();
              final authRepo = context.read<FirebaseAuthRepository>();
              final chatBloc = ChatBloc(chatRepo: chatRepo, authRepo: authRepo);
              return chatBloc;
            },
          ),
          BlocProvider<ThemeCubit>(create: (_) => ThemeCubit(prefs))
        ],
        child: MainApp(),
      ),
    ),
  );
}
