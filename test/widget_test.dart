import 'package:eyego_flutter_task/core/utils/validators.dart';
import 'package:eyego_flutter_task/features/auth/domain/entities/app_user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Validators', () {
    test('rejects empty + invalid email', () {
      expect(Validators.email(null), isNotNull);
      expect(Validators.email('not-an-email'), isNotNull);
      expect(Validators.email('user@eyego.app'), isNull);
    });

    test('rejects short password', () {
      expect(Validators.password('123'), isNotNull);
      expect(Validators.password('secret123'), isNull);
    });

    test('rejects short display name', () {
      expect(Validators.displayName('a'), isNotNull);
      expect(Validators.displayName('Ada'), isNull);
    });
  });

  group('AppUser', () {
    test('initials + displayLabel fallbacks', () {
      const user = AppUser(id: '1', email: 'ada@eyego.app', displayName: 'Ada L');
      expect(user.initials, 'AL');
      expect(user.displayLabel, 'Ada L');

      const emailOnly = AppUser(id: '2', email: 'bob@eyego.app');
      expect(emailOnly.displayLabel, 'bob');
      expect(AppUser.empty.isEmpty, isTrue);
    });
  });
}
