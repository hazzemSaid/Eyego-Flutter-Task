import 'package:equatable/equatable.dart';

import '../../domain/entities/app_user.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated }

class AuthState extends Equatable {
  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
    this.isGoogleLoading = false,
  });

  final AuthStatus status;
  final AppUser? user;
  final String? errorMessage;
  final bool isGoogleLoading;

  bool get isLoading => status == AuthStatus.loading;

  AuthState copyWith({
    AuthStatus? status,
    AppUser? user,
    String? Function()? errorMessage,
    bool? isGoogleLoading,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      isGoogleLoading: isGoogleLoading ?? this.isGoogleLoading,
    );
  }

  @override
  List<Object?> get props => [status, user, errorMessage, isGoogleLoading];
}
