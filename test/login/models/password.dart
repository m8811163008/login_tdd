import 'package:flutter_test/flutter_test.dart';
import 'package:login_ttd/login/models/password.dart';

void main() {
  group('constructors', () {
    const tPassword = 'mock password';
    test('create correct instance with pure constructor', () {
      Password password = Password.pure();
      expect(password.value, '');
      expect(password.pure, true);
    });

    test('create correct instance with dirty constructor', () {
      Password password = Password.dirty(tPassword);
      expect(password.value, tPassword);
      expect(password.pure, false);
    });
  });

  group('validators', () {
    test('should return error when password is empty', () {
      expect(Password.dirty('').error, PasswordValidationError.empty);
    });

    test('should return password when password is not empty ', () {
      expect(Password.dirty('abc').error, isNull);
    });
  });
}
