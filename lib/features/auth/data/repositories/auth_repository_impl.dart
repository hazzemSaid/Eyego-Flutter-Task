import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/firebase_error_mapper.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remote, this._local);

  final AuthRemoteDataSource _remote;
  final AuthLocalDataSource _local;

  @override
  Stream<AppUser?> authStateChanges() => _remote.authStateChanges();

  @override
  AppUser? get currentUser => _remote.currentUser?.toEntity();

  @override
  AppUser? get cachedUser => _local.getCachedUser()?.toEntity();

  @override
  Future<Either<AuthFailure, AppUser>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _remote.signInWithEmail(
        email: email,
        password: password,
      );
      await _local.saveUser(user);
      return Right(user.toEntity());
    } on FirebaseAuthException catch (e) {
      return Left(FirebaseErrorMapper.map(e));
    } catch (e) {
      return Left(AuthFailure.unknown(e.toString()));
    }
  }

  @override
  Future<Either<AuthFailure, AppUser>> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final user = await _remote.signUpWithEmail(
        name: name,
        email: email,
        password: password,
      );
      await _local.saveUser(user);
      return Right(user.toEntity());
    } on FirebaseAuthException catch (e) {
      return Left(FirebaseErrorMapper.map(e));
    } catch (e) {
      return Left(AuthFailure.unknown(e.toString()));
    }
  }

  @override
  Future<Either<AuthFailure, AppUser>> signInWithGoogle() async {
    try {
      final user = await _remote.signInWithGoogle();
      await _local.saveUser(user);
      return Right(user.toEntity());
    } on FirebaseAuthException catch (e) {
      return Left(FirebaseErrorMapper.map(e));
    } on GoogleSignInException catch (e) {
      return Left(FirebaseErrorMapper.mapGoogle(e));
    } catch (e) {
      return Left(FirebaseErrorMapper.mapGoogleGeneric(e));
    }
  }

  @override
  Future<Either<AuthFailure, Unit>> signOut() async {
    try {
      await _remote.signOut();
      await _local.clearUser();
      return const Right(unit);
    } catch (e) {
      return Left(AuthFailure.unknown(e.toString()));
    }
  }
}
