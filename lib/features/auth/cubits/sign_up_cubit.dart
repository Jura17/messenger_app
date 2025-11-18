import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:messenger_app/features/auth/cubits/sign_up_state.dart';
import 'package:messenger_app/features/auth/data/repositories/auth_repository.dart';

import 'package:messenger_app/features/auth/data/models/authentication_error_handling.dart';

import 'package:messenger_app/features/users/data/repositories/userdata_repository.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final AuthRepository _authRepo;
  final UserdataRepository _userdataRepo;

  SignUpCubit({
    required AuthRepository authRepo,
    required UserdataRepository userdataRepo,
  })  : _authRepo = authRepo,
        _userdataRepo = userdataRepo,
        super(const SignUpState());

  void emailChanged(String value) => emit(state.copyWith(email: value, errorMessage: null));
  void usernameChanged(String value) => emit(state.copyWith(username: value, errorMessage: null));
  void passwordChanged(String value) => emit(state.copyWith(password: value, errorMessage: null));
  void confirmPasswordChanged(String value) => emit(state.copyWith(confirmPassword: value, errorMessage: null));

  Future<void> signUp() async {
    if (state.email.isEmpty || state.password.isEmpty) {
      emit(state.copyWith(
        status: SignUpStatus.failure,
        errorMessage: "Email and password cannot be empty.",
      ));
      return;
    }

    if (state.password != state.confirmPassword) {
      emit(state.copyWith(
        status: SignUpStatus.failure,
        errorMessage: "Passwords do not match.",
      ));
      return;
    }

    emit(state.copyWith(status: SignUpStatus.loading, errorMessage: null));

    try {
      User user = await _authRepo.signUp(email: state.email, username: state.username, password: state.password);

      await _userdataRepo.createUser(user.uid, state.username, state.email);
    } on SignUpWithEmailAndPasswordFailure catch (e) {
      emit(state.copyWith(status: SignUpStatus.failure, errorMessage: e.message));
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(status: SignUpStatus.failure, errorMessage: "Unexpected error: $e"));
    }
  }
}
