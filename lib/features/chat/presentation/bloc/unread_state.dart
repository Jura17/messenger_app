sealed class UnreadState {}

final class UnreadInitial extends UnreadState {}

final class UnreadLoading extends UnreadState {}

final class UnreadLoaded extends UnreadState {
  final int count;
  final String chatPartnerId;

  UnreadLoaded(this.count, this.chatPartnerId);
}

final class UnreadError extends UnreadState {
  final String message;

  UnreadError(this.message);
}
