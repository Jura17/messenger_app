import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:messenger_app/features/users/bloc/user_bloc.dart';
import 'package:messenger_app/features/users/bloc/user_event.dart';
import 'package:messenger_app/features/users/presentation/widgets/chat_list_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(WatchUsers());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chats")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16.0),
        child: ChatListView(),
      ),
    );
  }
}
