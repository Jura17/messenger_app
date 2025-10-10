import 'package:equatable/equatable.dart';

sealed class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

final class BlockUser extends UserEvent {
  final String uid;

  const BlockUser(this.uid);

  @override
  List<Object?> get props => [uid];
}

final class UnblockUser extends UserEvent {
  final String uid;

  const UnblockUser(this.uid);

  @override
  List<Object?> get props => [uid];
}

final class WatchPermittedUsers extends UserEvent {}

final class WatchBlockedUsers extends UserEvent {}
