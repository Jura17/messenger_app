import 'package:equatable/equatable.dart';
import 'package:messenger_app/features/users/domain/entities/app_user_data.dart';

sealed class UsersState extends Equatable {
  const UsersState();

  @override
  List<Object?> get props => [];
}

final class UsersInitial extends UsersState {}

final class UsersLoading extends UsersState {}

final class UsersLoaded extends UsersState {
  final List<AppUserData> permittedUsers;
  final List<AppUserData> blockedUsers;

  // Which properties determine whether two instances of this state are considered equal? ==> permittedUsers and blockedUsers!
  const UsersLoaded(this.permittedUsers, this.blockedUsers);

  @override
  List<Object?> get props => [permittedUsers, blockedUsers];
}

final class UsersActionSuccess extends UsersState {
  final String text;
  const UsersActionSuccess(this.text);

  @override
  List<Object?> get props => [text];
}

final class UsersError extends UsersState {
  final String errorText;
  const UsersError(this.errorText);

  @override
  List<Object?> get props => [errorText];
}
