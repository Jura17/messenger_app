import 'package:equatable/equatable.dart';

sealed class UsersEvent extends Equatable {
  const UsersEvent();

  @override
  List<Object?> get props => [];
}

final class BlockUser extends UsersEvent {
  final String uid;

  const BlockUser(this.uid);

  @override
  List<Object?> get props => [uid];
}

final class UnblockUser extends UsersEvent {
  final String uid;

  const UnblockUser(this.uid);

  @override
  List<Object?> get props => [uid];
}

final class WatchUsers extends UsersEvent {}
