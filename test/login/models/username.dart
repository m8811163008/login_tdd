import 'package:flutter_test/flutter_test.dart';
import 'package:login_ttd/login/models/username.dart';

void main() {
  group('username', () {
    group('constructors', () {
      const tUserName = 'mock_username';
      test('should create valid instance with pure named constructor',
          () async {
        //arrange

        //act
        Username username = Username.pure();
        //verify interactions with mockObjects

        //assert
        expect(username.value, '');
        expect(username.pure, true);
      });
      test('dirty should create correct instance', () async {
        //arrange

        //act
        Username username = Username.dirty(tUserName);
        //verify interactions with mockObjects

        //assert
        expect(username.value, tUserName);
        expect(username.pure, false);
      });
    });

    group('validators', () {
      test('should return Username.empty when username is empty', () async {
        expect(Username.dirty('').error, UsernameValidationError.empty);
      });

      test('should return Username when username is not empty', () {
        expect(Username.dirty('abc').error, null);
      });
    });
  });
}
