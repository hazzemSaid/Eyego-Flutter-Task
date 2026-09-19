import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/app_user.dart';

abstract class AuthRepository {
  Stream<AppUser?> authStateChanges();

  AppUser? get currentUser;

  AppUser? get cachedUser;

  Future<Either<AuthFailure, AppUser>> signInWithEmail({
    required String email,
    required String password,
  });

  Future<Either<AuthFailure, AppUser>> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<AuthFailure, AppUser>> signInWithGoogle();

  Future<Either<AuthFailure, Unit>> signOut();
}
