import 'package:equatable/equatable.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

// check if user already logged in when app starts
final class AppStarted extends AuthEvent {}

final class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

final class SignUpRequested extends AuthEvent {
  final String email;
  final String password;

  const SignUpRequested(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

final class LogoutRequested extends AuthEvent {}
