import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

// sealed = only classes in this file can extend this class
sealed class AuthState extends Equatable {
  const AuthState();

  @override
  // needed to define what "equality" actually means when two types are compared using Equatable
  List<Object?> get props => [];
}

// initial state before anything happens
final class AuthInitial extends AuthState {}

// while checking or signing in
// final class AuthLoading extends AuthState {}

// user successfully authenticated
final class Authenticated extends AuthState {
  final User user;
  const Authenticated(this.user);

  @override
  List<Object?> get props => [user];
}

// no user signed in
final class Unauthenticated extends AuthState {
  final String? message;
  const Unauthenticated([this.message]);

  @override
  List<Object?> get props => [message];
}

final class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}
