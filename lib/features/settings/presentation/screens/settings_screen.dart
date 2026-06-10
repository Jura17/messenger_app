import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:messenger_app/features/auth/presentation/bloc/auth_bloc.dart';

import 'package:messenger_app/features/auth/presentation/bloc/auth_state.dart';

import 'package:messenger_app/features/settings/presentation/widgets/settings_options.dart';

import 'package:messenger_app/features/users/presentation/cubits/current_user_cubit.dart';
import 'package:messenger_app/features/users/presentation/cubits/current_user_cubit_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    final authBlocState = context.read<AuthBloc>().state;
    final currentUserState = context.read<CurrentUserCubit>().state;
    String? currentUserEmail;
    String? username;

    if (authBlocState is Authenticated) {
      currentUserEmail = authBlocState.user.email;
    }

    if (currentUserState is CurrentUserCubitLoaded) {
      username = currentUserState.currentUser.username;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
          style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
        ),
      ),
      body: Center(
        child: BlocBuilder<CurrentUserCubit, CurrentUserCubitState>(
          builder: (context, state) {
            if (state is CurrentUserCubitLoading) {
              return CircularProgressIndicator();
            }
            if (state is CurrentUserCubitError) {
              debugPrint(state.message);
              return Text(state.message);
            }
            if (state is CurrentUserCubitLoaded) {
              username = state.currentUser.username;
              return SettingsOptions(
                authBloc: authBloc,
                username: username,
                currentUserEmail: currentUserEmail,
              );
            }
            return Text("Unknown error");
          },
        ),
      ),
    );
  }
}
