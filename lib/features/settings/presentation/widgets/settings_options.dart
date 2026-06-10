import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide BuildContext;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_app/core/theme/theme_cubit.dart';
import 'package:messenger_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:messenger_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:messenger_app/features/settings/cubits/image_picker_cubit.dart';

import 'package:messenger_app/features/settings/presentation/widgets/settings_list_tile.dart';
import 'package:messenger_app/features/settings/presentation/widgets/settings_list_tiles.dart';
import 'package:messenger_app/features/settings/presentation/widgets/user_profile_header.dart';
import 'package:messenger_app/features/users/domain/repositories/userdata_repository.dart';

class SettingsOptions extends StatelessWidget {
  const SettingsOptions({
    super.key,
    required this.authBloc,
    required this.username,
    required this.currentUserEmail,
  });

  final AuthBloc authBloc;
  final String? username;
  final String? currentUserEmail;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            Align(
              alignment: AlignmentGeometry.center,
              child: BlocProvider(
                create: (context) => ImagePickerCubit(
                  userdataRepo: context.read<UserdataRepository>(),
                  authRepo: context.read<AuthRepository>(),
                ),
                child: UserProfileHeader(username: username, email: currentUserEmail),
              ),
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
            SettingsListTiles(username: username, currentUserEmail: currentUserEmail, authBloc: authBloc),
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
}
