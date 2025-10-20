import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:messenger_app/features/chat/presentation/widgets/custom_drawer.dart';
import 'package:messenger_app/features/users/bloc/user_bloc.dart';
import 'package:messenger_app/features/users/bloc/user_event.dart';
import 'package:messenger_app/features/users/presentation/widgets/user_list_view.dart';

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
      appBar: AppBar(title: Text("Home")),
      drawer: CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: UserListView(),
      ),
    );
  }
}
