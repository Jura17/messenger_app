import 'package:equatable/equatable.dart';

sealed class UnreadState extends Equatable {}

final class UnreadInitial extends UnreadState {
  @override
  List<Object?> get props => [];
}

final class UnreadLoading extends UnreadState {
  @override
  List<Object?> get props => [];
}

final class UnreadLoaded extends UnreadState {
  final int count;
  final String chatPartnerId;

  UnreadLoaded(this.count, this.chatPartnerId);

  @override
  List<Object?> get props => [count, chatPartnerId];
}

final class UnreadError extends UnreadState {
  final String message;

  UnreadError(this.message);

  @override
  List<Object?> get props => [message];
}
