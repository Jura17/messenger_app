import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_app/features/auth/bloc/auth_event.dart';
import 'package:messenger_app/features/auth/bloc/auth_state.dart';

import 'package:messenger_app/features/auth/data/repositories/firebase_auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuthRepository _authRepo;

  AuthBloc({required FirebaseAuthRepository authRepo})
      : _authRepo = authRepo,
        super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<SignUpRequested>(_onSignUpRequested);
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  // Event handlers
  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final currentUser = _authRepo.getCurrentUser();
      if (currentUser != null) {
        emit(Authenticated(currentUser));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignUpRequested(SignUpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final newUser = await _authRepo.signUp(event.email, event.password);
      emit(Authenticated(newUser));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await _authRepo.signIn(event.email, event.password);
      emit(Authenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _authRepo.logout();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
