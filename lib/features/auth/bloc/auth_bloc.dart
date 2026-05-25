import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_app/features/auth/bloc/auth_event.dart';
import 'package:messenger_app/features/auth/bloc/auth_state.dart';

import 'package:messenger_app/features/auth/domain/repositories/auth_repository.dart';

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
    on<ReauthenticationDoneOrCancelled>(_onReauthentcationDoneOrCancelled);
  }

  // Event handlers
  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    return emit.onEach<User?>(
      _authRepo.onAuthChanged(),
      // if Firebase says we have a user -> emit Authenticated
      onData: (user) => user != null ? emit(Authenticated(user)) : emit(Unauthenticated()),
      onError: (_, __) => AuthError("Error loading auth state"),
    );
  }

  Future<void> _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) async {
    try {
      await _authRepo.logout();
      emit(Unauthenticated());
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message ?? 'Logout failed'));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onDeletionRequested(DeletionRequested event, Emitter<AuthState> emit) async {
    try {
      final currentUser = _authRepo.getCurrentUser();
      await _authRepo.deleteAccount();
      await _userRepo.deleteAccount(currentUser);
      emit(Unauthenticated());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        final currentState = state;
        if (currentState is Authenticated) {
          emit(Authenticated(currentState.user, needsReauthentication: true));
        }
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onReauthentcationDoneOrCancelled(ReauthenticationDoneOrCancelled event, Emitter<AuthState> emit) async {
    final user = _authRepo.getCurrentUser();
    if (user != null) {
      emit(Authenticated(user));
    }
  }
}
