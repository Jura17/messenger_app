import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:messenger_app/features/users/bloc/user_event.dart';
import 'package:messenger_app/features/users/bloc/user_state.dart';
import 'package:messenger_app/features/users/data/models/user_data.dart';
import 'package:messenger_app/features/users/data/repositories/firestore_userdata_repository.dart';
import 'package:rxdart/rxdart.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final FirestoreUserdataRepository _userRepo;

  UserBloc({required FirestoreUserdataRepository userRepo})
      : _userRepo = userRepo,
        super(UsersInitial()) {
    on<BlockUser>(_onBlockUser);
    on<UnblockUser>(_onUnblockUser);
    on<WatchUsers>(_onWatchUsers);
  }

  Future<void> _onBlockUser(BlockUser event, Emitter<UserState> emit) async {
    try {
      await _userRepo.blockUser(event.uid);
      add(WatchUsers());
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onUnblockUser(UnblockUser event, Emitter<UserState> emit) async {
    try {
      await _userRepo.unblockUser(event.uid);
      add(WatchUsers());
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onWatchUsers(WatchUsers _, Emitter<UserState> emit) async {
    emit(UsersLoading());

    final permittedStream = _userRepo.getAllPermittedUsersStream();
    final blockedStream = _userRepo.getBlockedUsersStream();

    // Combining both streams into one
    await emit.forEach(
      Rx.combineLatest2<List<Userdata>, List<Userdata>, UsersLoaded>(
        permittedStream,
        blockedStream,
        (permitted, blocked) => UsersLoaded(permitted, blocked),
      ),
      onData: (state) => state,
      onError: (error, stackTrace) => UserError(error.toString()),
    );
  }
}
