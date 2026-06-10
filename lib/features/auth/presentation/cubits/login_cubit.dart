import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_app/features/auth/domain/entities/auth_user.dart';
import 'package:messenger_app/features/auth/presentation/cubits/login_state.dart';
import 'package:messenger_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:messenger_app/features/auth/data/models/error_handling_authentication.dart';
import 'package:messenger_app/features/users/domain/repositories/userdata_repository.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepo;
  final UserdataRepository _userdataRepo;

  LoginCubit({
    required AuthRepository authRepo,
    required UserdataRepository userdataRepo,
  })  : _authRepo = authRepo,
        _userdataRepo = userdataRepo,
        super(const LoginState());

  void emailChanged(String value) => emit(state.copyWith(email: value, errorMessage: null));
  void passwordChanged(String value) => emit(state.copyWith(password: value, errorMessage: null));

  Future<void> logIn() async {
    if (state.email.isEmpty || state.password.isEmpty) {
      emit(state.copyWith(
        status: LoginStatus.failure,
        errorMessage: "Email and password cannot be empty.",
      ));
      return;
    }

    emit(state.copyWith(status: LoginStatus.loading, errorMessage: null));

    try {
      AuthUser user = await _authRepo.signIn(state.email, state.password);
      await _userdataRepo.updateOnlineStatus(user.uid, true);
    } on LogInWithEmailAndPasswordFailure catch (e) {
      emit(state.copyWith(status: LoginStatus.failure, errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(status: LoginStatus.failure, errorMessage: "Unexpected error: $e"));
    }
  }
}
