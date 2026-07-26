import 'package:equatable/equatable.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

// check if user already logged in when app starts
final class AppStarted extends AuthEvent {}

final class LogoutRequested extends AuthEvent {}

final class DeletionRequested extends AuthEvent {}

final class ReauthenticationDoneOrCancelled extends AuthEvent {}
