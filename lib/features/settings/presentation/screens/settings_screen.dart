import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:messenger_app/core/theme/theme_cubit.dart';

import 'package:messenger_app/features/auth/bloc/auth_bloc.dart';
import 'package:messenger_app/features/auth/bloc/auth_event.dart';
import 'package:messenger_app/features/auth/bloc/auth_state.dart';
import 'package:messenger_app/features/auth/data/repositories/auth_repository.dart';

import 'package:messenger_app/features/settings/presentation/screens/blocked_users_screen.dart';
import 'package:messenger_app/features/settings/presentation/widgets/settings_list_tile.dart';
import 'package:messenger_app/features/settings/presentation/widgets/user_profile_header.dart';
import 'package:messenger_app/features/users/cubits/current_user_cubit.dart';
import 'package:messenger_app/features/users/cubits/current_user_state.dart';

// TODO: refactor SettingsScreen (too large!)
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

    if (currentUserState is CurrentUserLoaded) {
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
        child: BlocBuilder<CurrentUserCubit, CurrentUserState>(
          builder: (context, state) {
            if (state is CurrentUserLoading) {
              return CircularProgressIndicator();
            }
            if (state is CurrentUserError) {
              debugPrint(state.message);
              return Text(state.message);
            }
            if (state is CurrentUserLoaded) {
              username = state.currentUser.username;
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 10,
                    children: [
                      Align(
                        alignment: AlignmentGeometry.center,
                        child: UserProfileHeader(username: username, email: currentUserEmail),
                      ),
                      SizedBox(height: 40),
                      Row(
                        spacing: 5,
                        children: [
                          Icon(
                            Icons.person,
                            color: Theme.of(context).highlightColor,
                            size: 30,
                          ),
                          Text(
                            "User profile",
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        child: Column(
                          children: [
                            SettingsListTile(
                              title: "Username",
                              onTap: () {},
                              currentValue: username ?? "Current User",
                            ),
                            SettingsListTile(
                              title: "Email",
                              onTap: () {},
                              currentValue: currentUserEmail,
                            ),
                            SettingsListTile(
                              title: "Change password",
                              onTap: () => debugPrint("Change password..."),
                            ),
                            SettingsListTile(
                              title: "Blocked users",
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BlockedUsersScreen(),
                                ),
                              ),
                            ),
                            SettingsListTile(
                              title: "Logout",
                              onTap: () {
                                context.read<CurrentUserCubit>().updateOnlineStatus(false);
                                authBloc.add(LogoutRequested());
                              },
                            ),
                            BlocListener<AuthBloc, AuthState>(
                              listenWhen: (previous, current) =>
                                  current is Authenticated && current.needsReauthentication,
                              listener: (context, state) async {
                                debugPrint("Show reauthentication dialog");
                                final reauthenticationSucceeded = await showReauthenticationDialog(context);
                                if (!reauthenticationSucceeded) {
                                  authBloc.add(ReauthenticationDoneOrCancelled());
                                  return;
                                }

                                authBloc.add(DeletionRequested());
                              },
                              child: SettingsListTile(
                                title: "Delete account",
                                onTap: () async {
                                  final isDeleting = await accountDeletionRequest(context);

                                  if (isDeleting) {
                                    authBloc.add(DeletionRequested());
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40),
                      Row(
                        spacing: 5,
                        children: [
                          Icon(
                            Icons.color_lens,
                            color: Theme.of(context).highlightColor,
                            size: 30,
                          ),
                          Text(
                            "App theme",
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ],
                      ),
                      // Dark mode
                      SettingsListTile(
                        title: "Dark Mode",
                        action: CupertinoSwitch(
                          activeTrackColor: Theme.of(context).highlightColor,
                          value: context.watch<ThemeCubit>().state == ThemeMode.dark ? true : false,
                          onChanged: (_) => context.read<ThemeCubit>().toggleTheme(),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return Text("Unknown error");
          },
        ),
      ),
    );
  }

  Future<bool> accountDeletionRequest(BuildContext context) async {
    bool confirm = await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                title: const Text("Confirm Delete"),
                content: Text("This will delete your account permanently. Are you sure you want to proceed?"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: const Text(
                      "Delete",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              );
            }) ??
        false;
    return confirm;
  }
}

Future<bool> showReauthenticationDialog(BuildContext context) async {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  return await showDialog<bool>(
        context: context,
        builder: (context) {
          final navigator = Navigator.of(context);
          String errorText = "";

          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              title: const Text("Re-authentication needed"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("This action is sensitive and requires recent authentication. Please login again to proceed."),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(labelText: "Email"),
                  ),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(labelText: "Password"),
                  ),
                  // TODO: check docs about ...[] inside widget tree
                  if (errorText.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      errorText,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    navigator.pop(false);
                  },
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () async {
                    try {
                      await context
                          .read<AuthRepository>()
                          .reauthenticateUser(emailController.text.trim(), passwordController.text.trim());
                      navigator.pop(true);
                    } catch (e) {
                      setState(() {
                        errorText = "Please check your login details";
                      });
                      debugPrint("Login details error occurred");
                    }
                  },
                  child: const Text(
                    "Confirm",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            );
          });
        },
      ) ??
      false;
}
