import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'failures.dart';

abstract final class FirebaseErrorMapper {
  static AuthFailure map(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return const AuthFailure('That email address looks invalid.');
      case 'user-disabled':
        return const AuthFailure('This account has been disabled.');
      case 'user-not-found':
        return AuthFailure.userNotFound();
      case 'wrong-password':
      case 'invalid-credential':
        return AuthFailure.invalidCredentials();
      case 'email-already-in-use':
        return AuthFailure.emailInUse();
      case 'weak-password':
        return AuthFailure.weakPassword();
      case 'operation-not-allowed':
        return const AuthFailure('This sign-in method is not enabled.');
      case 'network-request-failed':
        return AuthFailure.network();
      case 'too-many-requests':
        return const AuthFailure(
            'Too many attempts. Please wait a moment and retry.');
      case 'user-cancelled':
      case 'auth-error':
        return AuthFailure(e.message ?? 'Authentication failed.');
      default:
        return AuthFailure.unknown(e.message);
    }
  }

  static AuthFailure mapGoogle(GoogleSignInException e) {
    switch (e.code) {
      case GoogleSignInExceptionCode.canceled:
        return AuthFailure.cancelled();
      default:
        return AuthFailure.unknown(e.description);
    }
  }

  static AuthFailure mapGoogleGeneric(Object e) {
    final text = e.toString().toLowerCase();
    if (text.contains('cancel')) return AuthFailure.cancelled();
    if (text.contains('network')) return AuthFailure.network();
    return AuthFailure.unknown(e.toString());
  }
}
