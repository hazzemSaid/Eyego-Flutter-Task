import '../constants/app_strings.dart';

abstract final class Validators {
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static const int minPasswordLength = 6;
  static const int minNameLength = 2;

  static String? email(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return AppStrings.emailRequired;
    if (!_emailRegex.hasMatch(v)) return AppStrings.emailInvalid;
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return AppStrings.passwordRequired;
    if (value.length < minPasswordLength) return AppStrings.passwordTooShort;
    return null;
  }

  static String? displayName(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return AppStrings.nameRequired;
    if (v.length < minNameLength) return AppStrings.nameTooShort;
    return null;
  }
}
