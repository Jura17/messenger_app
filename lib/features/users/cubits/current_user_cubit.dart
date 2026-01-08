import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_app/features/auth/data/repositories/auth_repository.dart';
import 'package:messenger_app/features/users/cubits/current_user_state.dart';
import 'package:messenger_app/features/users/data/repositories/userdata_repository.dart';

class CurrentUserCubit extends Cubit<CurrentUserState> {
  final UserdataRepository _userdataRepo;
  final AuthRepository _authRepo;

  CurrentUserCubit({
    required AuthRepository authRepo,
    required UserdataRepository userdataRepo,
  })  : _authRepo = authRepo,
        _userdataRepo = userdataRepo,
        super(CurrentUserInitial());

  Future<void> loadCurrentUser() async {
    final currentFirebaseUser = _authRepo.getCurrentUser();

    if (currentFirebaseUser == null) {
      emit(CurrentUserUnauthenticated());
      return;
    }

    emit(CurrentUserLoading());

    // firestore user document might need some time to get created even though the firebase user is already authenticated
    // retry fetching user 5 times
    try {
      for (int i = 0; i < 5; i++) {
        final user = await _userdataRepo.getUserById(currentFirebaseUser.uid);
        if (user != null) {
          emit(CurrentUserLoaded(user));
          return;
        }
        await Future.delayed(const Duration(milliseconds: 300));
      }

      emit(CurrentUserError('User document not found'));
    } catch (e) {
      emit(CurrentUserError(e.toString()));
    }
  }
}
