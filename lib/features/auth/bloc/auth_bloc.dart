import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_app/features/auth/bloc/auth_event.dart';
import 'package:messenger_app/features/auth/bloc/auth_state.dart';
import 'package:messenger_app/features/auth/data/repositories/auth_repository.dart';

import 'package:messenger_app/features/users/data/repositories/userdata_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepo;
  final UserdataRepository _userRepo;

  AuthBloc({
    required AuthRepository authRepo,
    required UserdataRepository userRepo,
  })  : _authRepo = authRepo,
        _userRepo = userRepo,
        super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LogoutRequested>(_onLogoutRequested);
    on<DeletionRequested>(_onDeletionRequested);
  }

  // Event handlers
  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    return emit.onEach<User?>(
      _authRepo.onAuthChanged(),
      onData: (user) => user != null ? emit(Authenticated(user)) : emit(Unauthenticated()),
      onError: (_, __) => AuthError("Error loading auth state"),
    );
  }

  Future<void> _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) async {
    try {
      await _authRepo.logout();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onDeletionRequested(DeletionRequested event, Emitter<AuthState> emit) async {
    try {
      await _authRepo.deleteAccount();
      await _userRepo.deleteAccount(_authRepo.getCurrentUser());
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
