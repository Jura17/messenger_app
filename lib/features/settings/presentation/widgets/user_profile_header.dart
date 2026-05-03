import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:messenger_app/features/settings/cubits/image_picker_cubit.dart';
import 'package:messenger_app/features/settings/cubits/image_picker_state.dart';

import 'package:messenger_app/features/users/cubits/current_user_cubit.dart';
import 'package:messenger_app/features/users/cubits/current_user_cubit_state.dart';

import 'package:messenger_app/utils/get_username_initials.dart';

class UserProfileHeader extends StatefulWidget {
  const UserProfileHeader({
    super.key,
    required this.username,
    required this.email,
  });

  final String? username;
  final String? email;

  @override
  State<UserProfileHeader> createState() => _UserProfileHeaderState();
}

class _UserProfileHeaderState extends State<UserProfileHeader> {
  late String? imagePath;

  @override
  void initState() {
    super.initState();
    // load locally saved profile image
    context.read<ImagePickerCubit>().loadSavedImagePathForCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    final usernameInitials = getUsernameInitials(widget.username);

    return Column(
      children: [
        GestureDetector(
          onTap: () async => context.read<ImagePickerCubit>().pickImage(),
          child: BlocBuilder<ImagePickerCubit, ImagePickerState>(builder: (context, state) {
            return CircleAvatar(
              radius: 50,
              backgroundColor: Theme.of(context).highlightColor,
              backgroundImage: state.imagePath == '' ? null : FileImage(File(state.imagePath)),
              child: state.imagePath == ''
                  ? Text(
                      usernameInitials ?? "PH",
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                    )
                  : null,
            );
          }),
        ),
        BlocBuilder<CurrentUserCubit, CurrentUserCubitState>(builder: (context, state) {
          if (state is CurrentUserCubitLoading) {
            return CircularProgressIndicator();
          }
          if (state is CurrentUserCubitError) {
            return Text(state.message);
          }
          if (state is CurrentUserCubitLoaded) {
            return Text(
              state.currentUser.username,
              style: Theme.of(context).textTheme.displaySmall,
            );
          }
          return Text("Unknown error");
        }),
        Text(widget.email!, style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }
}
