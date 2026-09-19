import '../../domain/entities/app_user.dart';

class UserModel extends AppUser {
  const UserModel({
    required super.id,
    required super.email,
    super.displayName,
    super.photoUrl,
    super.emailVerified = false,
  });

  factory UserModel.fromFirebase({
    required String uid,
    required String? email,
    String? displayName,
    String? photoUrl,
    bool emailVerified = false,
  }) {
    return UserModel(
      id: uid,
      email: email ?? '',
      displayName: displayName,
      photoUrl: photoUrl,
      emailVerified: emailVerified,
    );
  }

  AppUser toEntity() => AppUser(
        id: id,
        email: email,
        displayName: displayName,
        photoUrl: photoUrl,
        emailVerified: emailVerified,
      );
}
