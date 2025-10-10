import 'package:equatable/equatable.dart';
import 'package:messenger_app/features/users/data/models/user_data.dart';

sealed class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

final class UsersInitial extends UserState {}

final class UsersLoading extends UserState {}

final class UsersLoaded extends UserState {
  final List<Userdata> users;

  const UsersLoaded(this.users);
}

final class UserActionSuccess extends UserState {
  final String? message;
  const UserActionSuccess([this.message]);

  @override
  List<Object?> get props => [message];
}

final class UserError extends UserState {
  final String errorMessage;
  const UserError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
