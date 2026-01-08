import 'package:messenger_app/features/users/data/models/user_data.dart';

sealed class CurrentUserState {}

class CurrentUserInitial extends CurrentUserState {}

final class CurrentUserLoading extends CurrentUserState {}

final class CurrentUserLoaded extends CurrentUserState {
  final Userdata currentUser;

  CurrentUserLoaded(this.currentUser);
}

final class CurrentUserUnauthenticated extends CurrentUserState {}

final class CurrentUserError extends CurrentUserState {
  final String message;
  CurrentUserError(this.message);
}
