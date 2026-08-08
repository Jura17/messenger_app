import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_app/features/users/domain/entities/app_user_data.dart';
import 'package:messenger_app/features/users/presentation/bloc/current_user_event.dart';
import 'package:messenger_app/features/users/presentation/bloc/current_user_state.dart';
import 'package:messenger_app/features/users/domain/repositories/userdata_repository.dart';

class CurrentUserBloc extends Bloc<CurrentUserEvent, CurrentUserState> {
  final UserdataRepository _userRepo;

  CurrentUserBloc({
    required UserdataRepository userRepo,
  })  : _userRepo = userRepo,
        super(CurrentUserInitial()) {
    on<WatchCurrentUser>(_onWatchCurrentUser);
  }

  Future<void> _onWatchCurrentUser(WatchCurrentUser event, Emitter<CurrentUserState> emit) async {
    emit(CurrentUserLoading());
    return emit.forEach<AppUserData?>(
      _userRepo.watchCurrentUser(event.uid),
      onData: (userdata) {
        return CurrentUserLoaded(userdata);
      },
      onError: (error, stackTrace) {
        return CurrentUserError(error.toString());
      },
    );
  }

  @override
  Future<void> close() {
    debugPrint("current user bloc closed");
    return super.close();
  }
}
