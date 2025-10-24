import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:messenger_app/features/auth/cubits/sign_up_state.dart';
import 'package:messenger_app/features/auth/data/repositories/firebase_auth_repository.dart';
import 'package:messenger_app/features/auth/data/models/authentication_error_handling.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final FirebaseAuthRepository _authRepository;

  SignUpCubit(this._authRepository) : super(const SignUpState());

  void emailChanged(String value) => emit(state.copyWith(email: value, errorMessage: null));
  void passwordChanged(String value) => emit(state.copyWith(password: value, errorMessage: null));
  void confirmPasswordChanged(String value) => emit(state.copyWith(confirmPassword: value, errorMessage: null));

  Future<void> signUp() async {
    if (state.email.isEmpty || state.password.isEmpty) {
      emit(state.copyWith(
        status: SignUpStatus.failure,
        errorMessage: "Email and Password cannot be empty.",
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
      await _authRepository.signUp(state.email, state.password);
      emit(state.copyWith(status: SignUpStatus.success));
    } on SignUpWithEmailAndPasswordFailure catch (e) {
      emit(state.copyWith(status: SignUpStatus.failure, errorMessage: e.message));
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(status: SignUpStatus.failure, errorMessage: "Unexpected error: $e"));
    }
  }
}
