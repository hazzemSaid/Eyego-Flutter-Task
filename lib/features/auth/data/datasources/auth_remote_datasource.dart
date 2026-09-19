import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Stream<UserModel?> authStateChanges();

  UserModel? get currentUser;

  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  });

  Future<UserModel> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  });

  Future<UserModel> signInWithGoogle();

  Future<void> signOut();
}
