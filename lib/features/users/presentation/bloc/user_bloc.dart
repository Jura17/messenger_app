import 'package:bloc_concurrency/bloc_concurrency.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:messenger_app/features/users/domain/entities/app_user_data.dart';

import 'package:messenger_app/features/users/presentation/bloc/user_event.dart';
import 'package:messenger_app/features/users/presentation/bloc/user_state.dart';

import 'package:messenger_app/features/users/domain/repositories/userdata_repository.dart';
import 'package:rxdart/rxdart.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final AuthRepository _authRepo;
  final UserdataRepository _userRepo;

  UserBloc({
    required AuthRepository authRepo,
    required UserdataRepository userRepo,
  })  : _authRepo = authRepo,
        _userRepo = userRepo,
        super(UsersInitial()) {
    on<BlockUser>(_onBlockUser);
    on<UnblockUser>(_onUnblockUser);
    // restartable(): cancels the previous event handler's subscription/work (in my case: emit.forEach(stream...) when another event arrives
    // ==> results in old user stream subscription being canceled when new WatchUsers event arrives
    on<WatchUsers>(_onWatchUsers, transformer: restartable());
  }

  Future<void> _onBlockUser(BlockUser event, Emitter<UserState> emit) async {
    try {
      await _userRepo.blockUser(event.uid, _authRepo.getCurrentUser());
      add(WatchUsers());
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onUnblockUser(UnblockUser event, Emitter<UserState> emit) async {
    try {
      await _userRepo.unblockUser(event.uid, _authRepo.getCurrentUser());
      add(WatchUsers());
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onWatchUsers(WatchUsers _, Emitter<UserState> emit) async {
    emit(UsersLoading());

    try {
      final currentUser = _authRepo.getCurrentUser();
      final permittedStream = _userRepo.getAllPermittedUsersStream(currentUser);
      final blockedStream = _userRepo.getBlockedUsersStream(currentUser);

      // Combining both streams into one
      await emit.forEach(
        Rx.combineLatest2<List<AppUserData>, List<AppUserData>, UsersLoaded>(
          permittedStream,
          blockedStream,
          (permitted, blocked) {
            return UsersLoaded(permitted, blocked);
          },
        ),
        onData: (state) => state,
        onError: (error, stackTrace) => UserError(error.toString()),
      );
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}
