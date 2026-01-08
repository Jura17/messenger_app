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
  final List<Userdata> permittedUsers;
  final List<Userdata> blockedUsers;

  const UsersLoaded(this.permittedUsers, this.blockedUsers);
}

final class UserActionSuccess extends UserState {
  final String text;
  const UserActionSuccess(this.text);

  @override
  List<Object?> get props => [text];
}

final class UserError extends UserState {
  final String errorText;
  const UserError(this.errorText);

  @override
  List<Object?> get props => [errorText];
}
