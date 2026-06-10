import 'package:equatable/equatable.dart';
import 'package:messenger_app/features/users/data/models/user_data.dart';

sealed class CurrentUserState extends Equatable {
  const CurrentUserState();

  @override
  List<Object?> get props => [];
}

final class CurrentUserInitial extends CurrentUserState {}

final class CurrentUserLoading extends CurrentUserState {}

final class CurrentUserLoaded extends CurrentUserState {
  final Userdata? userdata;

  const CurrentUserLoaded(this.userdata);

  @override
  List<Object?> get props => [userdata];
}

final class CurrentUserError extends CurrentUserState {
  final String errorText;
  const CurrentUserError(this.errorText);

  @override
  List<Object?> get props => [errorText];
}
