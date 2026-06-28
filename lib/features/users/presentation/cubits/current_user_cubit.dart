import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:messenger_app/features/users/presentation/cubits/current_user_cubit_state.dart';
import 'package:messenger_app/features/users/domain/repositories/userdata_repository.dart';

class CurrentUserCubit extends Cubit<CurrentUserCubitState> {
  final UserdataRepository _userdataRepo;
  final AuthRepository _authRepo;

  CurrentUserCubit({
    required AuthRepository authRepo,
    required UserdataRepository userdataRepo,
  })  : _authRepo = authRepo,
        _userdataRepo = userdataRepo,
        super(CurrentUserCubitInitial());

  Future<void> loadCurrentUser() async {
    final currentUser = _authRepo.getCurrentUser();

    if (currentUser == null) {
      emit(CurrentUserCubitUnauthenticated());
      return;
    }

    emit(CurrentUserCubitLoading());

    // retry fetching user 5 times in case user document is not created yet and needs more time
    try {
      for (int i = 0; i < 5; i++) {
        final user = await _userdataRepo.getUserById(currentUser.uid);
        if (user != null) {
          emit(CurrentUserCubitLoaded(user));
          return;
        }
        await Future.delayed(const Duration(milliseconds: 300));
      }

      emit(CurrentUserCubitError('User document not found'));
    } catch (e) {
      emit(CurrentUserCubitError(e.toString()));
    }
  }

  Future<void> updateOnlineStatus(bool isOnline) async {
    final currentUser = _authRepo.getCurrentUser();

    if (currentUser == null) {
      emit(CurrentUserCubitUnauthenticated());
      return;
    }

    await _userdataRepo.updateOnlineStatus(currentUser.uid, isOnline);
  }
}
