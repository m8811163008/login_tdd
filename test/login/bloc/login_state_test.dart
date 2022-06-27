import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:login_ttd/login/bloc/login_bloc.dart';
import 'package:login_ttd/login/models/password.dart';
import 'package:login_ttd/login/models/username.dart';

void main() {
  group('LoginState', () {
    const tUsernameOrPassword = 'abc';
    final Username username = Username.dirty(tUsernameOrPassword);
    final Password password = Password.dirty(tUsernameOrPassword);
    final FormzStatus tStatus = FormzStatus.pure;
    test('must support object comparison', () {
      expect(LoginState(), LoginState());
    });

    test('should return same object with empty copywith', () {
      expect(LoginState().copyWith(), LoginState());
    });
    test('should return same object with copywith by username', () {
      expect(LoginState().copyWith(username: username),
          LoginState(username: username));
    });
    test('should return same object with copywith by password', () {
      expect(LoginState().copyWith(password: password),
          LoginState(password: password));
    });
    test('should return same object with copywith by status', () {
      expect(LoginState().copyWith(formzStatus: tStatus),
          LoginState(formzStatus: tStatus));
    });
  });
}
