import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_app/features/auth/bloc/auth_bloc.dart';
import 'package:messenger_app/features/auth/bloc/auth_event.dart';
import 'package:messenger_app/features/auth/bloc/auth_state.dart';
import 'package:messenger_app/features/settings/presentation/dialogs/settings_dialogs.dart';
import 'package:messenger_app/features/settings/presentation/screens/blocked_users_screen.dart';
import 'package:messenger_app/features/settings/presentation/widgets/settings_list_tile.dart';
import 'package:messenger_app/features/users/cubits/current_user_cubit.dart';

class SettingsListTiles extends StatelessWidget {
  const SettingsListTiles({
    super.key,
    required this.username,
    required this.currentUserEmail,
    required this.authBloc,
  });

  final String? username;
  final String? currentUserEmail;
  final AuthBloc authBloc;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            listenWhen: (previous, current) => current is Authenticated && current.needsReauthentication,
            listener: (context, state) async {
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
    );
  }
}
