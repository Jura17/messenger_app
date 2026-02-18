import 'package:equatable/equatable.dart';

sealed class CurrentUserEvent extends Equatable {
  const CurrentUserEvent();

  @override
  List<Object?> get props => [];
}

final class WatchCurrentUser extends CurrentUserEvent {
  final String uid;

  const WatchCurrentUser(this.uid);
  @override
  List<Object?> get props => [uid];
}
