import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:messenger_app/features/auth/data/repositories/firebase_auth_repository.dart';
import 'package:messenger_app/features/auth/data/models/authentication_error_handling.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final FirebaseAuthRepository _authRepository;

  LoginCubit(this._authRepository) : super(const LoginState());

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
      await _authRepository.signIn(state.email, state.password);
      emit(state.copyWith(status: LoginStatus.success));
    } on LogInWithEmailAndPasswordFailure catch (e) {
      emit(state.copyWith(status: LoginStatus.failure, errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(status: LoginStatus.failure, errorMessage: "Unexpected error: $e"));
    }
  }
}
