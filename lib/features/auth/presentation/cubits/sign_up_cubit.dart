import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_app/features/auth/domain/entities/auth_user.dart';
import 'package:messenger_app/features/auth/presentation/cubits/sign_up_state.dart';
import 'package:messenger_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:messenger_app/features/auth/data/models/error_handling_authentication.dart';
import 'package:messenger_app/features/users/domain/repositories/userdata_repository.dart';

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
    emit(state.copyWith(status: SignUpStatus.loading, errorMessage: null));
    try {
      if (state.username.length < 3) {
        throw SignUpWithEmailAndPasswordFailure.fromCode('username-too-short');
      }
      if (state.username.length > 20) {
        throw SignUpWithEmailAndPasswordFailure.fromCode('username-too-long');
      }

      if (state.email.isEmpty || state.password.isEmpty) {
        throw SignUpWithEmailAndPasswordFailure.fromCode('empty-fields');
      }

      if (state.password != state.confirmPassword) {
        throw SignUpWithEmailAndPasswordFailure.fromCode('passwords-do-not-match');
      }

      AuthUser user = await _authRepo.signUp(email: state.email, username: state.username, password: state.password);
      await _userdataRepo.createUser(user.uid, state.username, state.email);
    } on SignUpWithEmailAndPasswordFailure catch (e) {
      emit(state.copyWith(status: SignUpStatus.failure, errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(status: SignUpStatus.failure, errorMessage: 'Unexpected error: $e'));
    }
  }
}
