import 'package:equatable/equatable.dart';

sealed class UserdataEvent extends Equatable {
  const UserdataEvent();

  @override
  List<Object?> get props => [];
}

final class WatchUserdata extends UserdataEvent {
  final String uid;

  const WatchUserdata(this.uid);
  @override
  List<Object?> get props => [uid];
}
