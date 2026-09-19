import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/auth_usecases.dart';
import '../../domain/usecases/usecase.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required AuthRepository repository,
    required SignInWithEmail signInWithEmail,
    required SignUpWithEmail signUpWithEmail,
    required SignInWithGoogle signInWithGoogle,
    required SignOut signOut,
  })  : _repository = repository,
        _signInWithEmail = signInWithEmail,
        _signUpWithEmail = signUpWithEmail,
        _signInWithGoogle = signInWithGoogle,
        _signOut = signOut,
        super(const AuthState()) {
    _checkCachedUser();
    _subscription = _repository.authStateChanges().listen(_onAuthChanged);
  }

  final AuthRepository _repository;
  final SignInWithEmail _signInWithEmail;
  final SignUpWithEmail _signUpWithEmail;
  final SignInWithGoogle _signInWithGoogle;
  final SignOut _signOut;

  StreamSubscription<AppUser?>? _subscription;

  void _checkCachedUser() {
    final cached = _repository.cachedUser;
    if (cached != null && cached.isNotEmpty) {
      emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: cached,
        errorMessage: () => null,
      ));
    }
  }

  void _onAuthChanged(AppUser? user) {
    if (user == null || user.isEmpty) {
      if (state.status == AuthStatus.authenticated) {
        emit(state.copyWith(
          status: AuthStatus.unauthenticated,
          user: user,
          errorMessage: () => null,
        ));
      }
    } else {
      emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        errorMessage: () => null,
        isGoogleLoading: false,
      ));
    }
  }

  Future<void> loginEmail({
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(status: AuthStatus.loading, errorMessage: () => null));
    final result = await _signInWithEmail(
      EmailParams(email: email, password: password),
    );
    result.fold(
      (failure) => emit(state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: () => failure.message,
      )),
      (user) => emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        errorMessage: () => null,
      )),
    );
  }

  Future<void> registerEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(status: AuthStatus.loading, errorMessage: () => null));
    final result = await _signUpWithEmail(
      RegisterParams(name: name, email: email, password: password),
    );
    result.fold(
      (failure) => emit(state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: () => failure.message,
      )),
      (user) => emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        errorMessage: () => null,
      )),
    );
  }

  Future<void> loginGoogle() async {
    emit(state.copyWith(
      isGoogleLoading: true,
      errorMessage: () => null,
    ));
    final result = await _signInWithGoogle(const NoParams());
    result.fold(
      (failure) => emit(state.copyWith(
        isGoogleLoading: false,
        errorMessage: () => failure.message,
      )),
      (user) => emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        isGoogleLoading: false,
        errorMessage: () => null,
      )),
    );
  }

  Future<void> logout() async {
    await _signOut(const NoParams());
    emit(state.copyWith(
      status: AuthStatus.unauthenticated,
      errorMessage: () => null,
    ));
  }

  void clearError() => emit(state.copyWith(errorMessage: () => null));

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
