import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_app/features/users/bloc/user_event.dart';
import 'package:messenger_app/features/users/bloc/user_state.dart';
import 'package:messenger_app/features/users/data/models/user_data.dart';
import 'package:messenger_app/features/users/data/repositories/firestore_userdata_repository.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final FirestoreUserdataRepository _userRepo;

  UserBloc({required FirestoreUserdataRepository userRepo})
      : _userRepo = userRepo,
        super(UsersInitial()) {
    on<BlockUser>(_onBlockUser);
    on<UnblockUser>(_onUnblockUser);
    on<WatchPermittedUsers>(_onWatchPermittedUsers);
    on<WatchBlockedUsers>(_onWatchBlockedUsers);
  }

  Future<void> _onBlockUser(BlockUser event, Emitter<UserState> emit) async {
    emit(UsersLoading());
    try {
      await _userRepo.blockUser(event.uid);
      emit(UserActionSuccess());
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onUnblockUser(UnblockUser event, Emitter<UserState> emit) async {
    emit(UsersLoading());
    try {
      await _userRepo.unblockUser(event.uid);
      emit(UserActionSuccess());
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onWatchPermittedUsers(WatchPermittedUsers _, Emitter<UserState> emit) async {
    emit(UsersLoading());
    // consumes the stream
    await emit.forEach<List<Userdata>>(
      _userRepo.getAllPermittedUsersStream(),
      onData: (users) => UsersLoaded(users),
      onError: (error, stackTrace) => UserError(error.toString()),
    );
  }

  Future<void> _onWatchBlockedUsers(WatchBlockedUsers _, Emitter<UserState> emit) async {
    emit(UsersLoading());
    // consumes the stream
    await emit.forEach<List<Userdata>>(
      _userRepo.getBlockedUsersStream(),
      onData: (users) => UsersLoaded(users),
      onError: (error, stackTrace) => UserError(error.toString()),
    );
  }
}
