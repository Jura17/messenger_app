import 'package:equatable/equatable.dart';
import 'package:messenger_app/features/users/data/models/user_data.dart';

sealed class UserdataState extends Equatable {
  const UserdataState();

  @override
  List<Object?> get props => [];
}

final class UserdataInitial extends UserdataState {}

final class UserdataLoading extends UserdataState {}

final class UserdataLoaded extends UserdataState {
  final Userdata? userdata;

  const UserdataLoaded(this.userdata);
}

final class UserdataError extends UserdataState {
  final String errorText;
  const UserdataError(this.errorText);

  @override
  List<Object?> get props => [errorText];
}
