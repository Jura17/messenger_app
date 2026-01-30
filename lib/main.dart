import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:messenger_app/core/theme/theme_cubit.dart';

import 'package:messenger_app/features/auth/bloc/auth_bloc.dart';
import 'package:messenger_app/features/auth/bloc/auth_event.dart';
import 'package:messenger_app/features/auth/data/provider/auth_api.dart';
import 'package:messenger_app/features/auth/data/provider/firebase_auth_api.dart';
import 'package:messenger_app/features/auth/data/repositories/auth_repository.dart';
import 'package:messenger_app/features/auth/data/repositories/firebase_auth_repository.dart';

import 'package:messenger_app/features/chat/bloc/chat_bloc.dart';

import 'package:messenger_app/features/chat/data/provider/firestore_chat_api.dart';
import 'package:messenger_app/features/chat/data/repositories/chat_repository.dart';
import 'package:messenger_app/features/chat/data/repositories/firestore_chat_repository.dart';
import 'package:messenger_app/features/users/bloc/user_bloc.dart';

import 'package:messenger_app/features/users/data/provider/firestore_userdata_api.dart';
import 'package:messenger_app/features/users/data/provider/userdata_api.dart';

import 'package:messenger_app/features/users/data/repositories/firestore_userdata_repository.dart';
import 'package:messenger_app/features/users/data/repositories/userdata_repository.dart';
import 'package:messenger_app/firebase_options.dart';
import 'package:messenger_app/main_app.dart';

import 'package:shared_preferences/shared_preferences.dart';

// TODO: show chatrooms/conversations with actual contacts of current user
// TODO: add Search function to filter chat list by email address or username
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final prefs = await SharedPreferences.getInstance();

  final firebaseAuth = FirebaseAuth.instance;
  final firestoreDb = FirebaseFirestore.instance;

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthApi>(create: (_) => FirebaseAuthApi(firebaseAuth)),
        RepositoryProvider<UserdataApi>(create: (context) => FirestoreUserdataApi(firestoreDb)),
        RepositoryProvider<AuthRepository>(create: (context) {
          final authApi = context.read<AuthApi>();
          return FirebaseAuthRepository(authApi);
        }),
        RepositoryProvider<ChatRepository>(create: (context) {
          final chatApi = FirestoreChatApi(firestoreDb);
          return FirestoreChatRepository(chatApi);
        }),
        RepositoryProvider<UserdataRepository>(create: (context) {
          final userdataApi = context.read<UserdataApi>();
          return FirestoreUserdataRepository(userdataApi);
        })
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) {
              final authRepo = context.read<AuthRepository>();
              final userRepo = context.read<UserdataRepository>();
              final authBloc = AuthBloc(authRepo: authRepo, userRepo: userRepo);
              authBloc.add(AppStarted());
              return authBloc;
            },
          ),
          BlocProvider<UserBloc>(
            create: (context) {
              final userRepo = context.read<UserdataRepository>();
              final authRepo = context.read<AuthRepository>();
              final userBloc = UserBloc(authRepo: authRepo, userRepo: userRepo);
              return userBloc;
            },
          ),
          BlocProvider<ChatBloc>(
            create: (context) {
              final chatRepo = context.read<ChatRepository>();
              final authRepo = context.read<AuthRepository>();
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
