import 'package:equatable/equatable.dart';
import 'package:messenger_app/features/users/domain/entities/app_user_data.dart';

sealed class ChatPartnerState extends Equatable {
  const ChatPartnerState();

  @override
  List<Object?> get props => [];
}

final class ChatPartnerInitial extends ChatPartnerState {}

final class ChatPartnerLoading extends ChatPartnerState {}

final class ChatPartnerLoaded extends ChatPartnerState {
  final AppUserData? userdata;

  const ChatPartnerLoaded(this.userdata);

  @override
  List<Object?> get props => [userdata];
}

final class ChatPartnerError extends ChatPartnerState {
  final String errorText;
  const ChatPartnerError(this.errorText);

  @override
  List<Object?> get props => [errorText];
}
