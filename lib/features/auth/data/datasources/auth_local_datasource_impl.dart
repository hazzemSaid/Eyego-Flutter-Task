import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';
import 'auth_local_datasource.dart';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  AuthLocalDataSourceImpl({required SharedPreferences prefs}) : _prefs = prefs;

  final SharedPreferences _prefs;

  static const _keyId = 'auth_user_id';
  static const _keyEmail = 'auth_user_email';
  static const _keyName = 'auth_user_name';
  static const _keyPhoto = 'auth_user_photo';

  @override
  Future<void> saveUser(UserModel user) async {
    await Future.wait([
      _prefs.setString(_keyId, user.id),
      _prefs.setString(_keyEmail, user.email),
      _prefs.setString(_keyName, user.displayName ?? ''),
      _prefs.setString(_keyPhoto, user.photoUrl ?? ''),
    ]);
  }

  @override
  Future<void> clearUser() async {
    await Future.wait([
      _prefs.remove(_keyId),
      _prefs.remove(_keyEmail),
      _prefs.remove(_keyName),
      _prefs.remove(_keyPhoto),
    ]);
  }

  @override
  UserModel? getCachedUser() {
    final id = _prefs.getString(_keyId);
    if (id == null || id.isEmpty) return null;

    return UserModel(
      id: id,
      email: _prefs.getString(_keyEmail) ?? '',
      displayName: _prefs.getString(_keyName),
      photoUrl: _prefs.getString(_keyPhoto),
    );
  }
}
