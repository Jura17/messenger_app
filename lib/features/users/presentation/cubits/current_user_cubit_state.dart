import 'package:messenger_app/features/users/data/models/user_data.dart';

sealed class CurrentUserCubitState {}

class CurrentUserCubitInitial extends CurrentUserCubitState {}

final class CurrentUserCubitLoading extends CurrentUserCubitState {}

final class CurrentUserCubitLoaded extends CurrentUserCubitState {
  final Userdata currentUser;

  CurrentUserCubitLoaded(this.currentUser);
}

final class CurrentUserCubitUnauthenticated extends CurrentUserCubitState {}

final class CurrentUserCubitError extends CurrentUserCubitState {
  final String message;
  CurrentUserCubitError(this.message);
}
