import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:messenger_app/features/settings/cubits/image_picker_cubit.dart';
import 'package:messenger_app/features/settings/cubits/image_picker_state.dart';

import 'package:messenger_app/features/users/cubits/current_user_cubit.dart';
import 'package:messenger_app/features/users/cubits/current_user_cubit_state.dart';
import 'package:messenger_app/features/users/data/repositories/userdata_repository.dart';

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
  @override
  Widget build(BuildContext context) {
    final usernameInitials = getUsernameInitials(widget.username);

    return BlocProvider(
      create: (context) => ImagePickerCubit(userdataRepo: context.read<UserdataRepository>()),
      child: Column(
        children: [
          GestureDetector(
            onTap: () async => context.read<ImagePickerCubit>().pickImage(),
            child: Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).highlightColor,
              ),
              child: Center(
                // show image available show it, otherwise show username initials
                child: BlocBuilder<ImagePickerCubit, ImagePickerState>(builder: (context, state) {
                  if (state.pickedImage == null) {
                    return Text(
                      usernameInitials ?? "PH",
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall
                          ?.copyWith(color: Theme.of(context).colorScheme.tertiary),
                    );
                  }

                  if (state.pickedImage != null) {
                    return Image.file(File(state.imagePath));
                  }
                  return Container();
                }),
              ),
            ),
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
      ),
    );
  }
}
