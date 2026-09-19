import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class AuthFailure extends Failure {
  const AuthFailure(super.message, {this.code});

  final String? code;

  factory AuthFailure.invalidCredentials() =>
      const AuthFailure('Incorrect email or password.', code: 'invalid');

  factory AuthFailure.userNotFound() =>
      const AuthFailure('No account found for this email.', code: 'not-found');

  factory AuthFailure.emailInUse() => const AuthFailure(
        'This email is already registered. Try logging in.',
        code: 'in-use',
      );

  factory AuthFailure.weakPassword() => const AuthFailure(
        'Password is too weak. Use at least 6 characters.',
        code: 'weak',
      );

  factory AuthFailure.network() => const AuthFailure(
        'No internet connection. Check your network and retry.',
        code: 'network',
      );

  factory AuthFailure.cancelled() =>
      const AuthFailure('Sign-in was cancelled.', code: 'cancelled');

  factory AuthFailure.unknown([String? details]) => AuthFailure(
        details ?? 'Something went wrong. Please try again.',
        code: 'unknown',
      );
}
