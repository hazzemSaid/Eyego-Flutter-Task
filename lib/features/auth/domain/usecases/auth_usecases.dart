import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';
import 'usecase.dart';

class EmailParams extends Equatable {
  const EmailParams({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

class SignInWithEmail implements UseCase<AppUser, EmailParams> {
  const SignInWithEmail(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<AuthFailure, AppUser>> call(EmailParams params) {
    return _repository.signInWithEmail(
      email: params.email.trim(),
      password: params.password,
    );
  }
}

class RegisterParams extends Equatable {
  const RegisterParams({
    required this.name,
    required this.email,
    required this.password,
  });

  final String name;
  final String email;
  final String password;

  @override
  List<Object?> get props => [name, email, password];
}

class SignUpWithEmail implements UseCase<AppUser, RegisterParams> {
  const SignUpWithEmail(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<AuthFailure, AppUser>> call(RegisterParams params) {
    return _repository.signUpWithEmail(
      name: params.name.trim(),
      email: params.email.trim(),
      password: params.password,
    );
  }
}

class SignInWithGoogle implements UseCase<AppUser, NoParams> {
  const SignInWithGoogle(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<AuthFailure, AppUser>> call(NoParams params) {
    return _repository.signInWithGoogle();
  }
}

class SignOut implements UseCase<Unit, NoParams> {
  const SignOut(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<AuthFailure, Unit>> call(NoParams params) {
    return _repository.signOut();
  }
}
