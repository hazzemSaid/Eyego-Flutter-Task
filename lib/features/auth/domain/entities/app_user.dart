import 'package:equatable/equatable.dart';

class AppUser extends Equatable {
  const AppUser({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.emailVerified = false,
  });

  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final bool emailVerified;

  static const empty = AppUser(id: '', email: '');

  bool get isEmpty => this == empty;
  bool get isNotEmpty => !isEmpty;

  String get displayLabel {
    if (displayName?.trim().isNotEmpty ?? false) return displayName!.trim();
    if (email.contains('@')) return email.split('@').first;
    return 'EyeGo explorer';
  }

  String get initials {
    final label = displayLabel.trim();
    if (label.isEmpty) return 'EG';
    final parts = label.split(RegExp(r'\s+'));
    if (parts.length == 1) {
      return parts.first.substring(0, parts.first.length >= 2 ? 2 : 1).toUpperCase();
    }
    return (parts[0].substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
  }

  @override
  List<Object?> get props => [id, email, displayName, photoUrl, emailVerified];
}
