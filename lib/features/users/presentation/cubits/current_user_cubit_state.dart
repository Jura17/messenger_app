import 'package:messenger_app/features/users/domain/entities/app_user_data.dart';

sealed class CurrentUserCubitState {}

class CurrentUserCubitInitial extends CurrentUserCubitState {}

final class CurrentUserCubitLoading extends CurrentUserCubitState {}

final class CurrentUserCubitLoaded extends CurrentUserCubitState {
  final AppUserData currentUser;

  CurrentUserCubitLoaded(this.currentUser);
}

final class CurrentUserCubitUnauthenticated extends CurrentUserCubitState {}

final class CurrentUserCubitError extends CurrentUserCubitState {
  final String message;
  CurrentUserCubitError(this.message);
}
