import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveUser(UserModel user);
  Future<void> clearUser();
  UserModel? getCachedUser();
}
