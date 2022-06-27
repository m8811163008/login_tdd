import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:login_ttd/authentication/bloc/authentication_bloc.dart';

void main() {
  group('AuthenticationEvent', () {
    group('AuthenticationStatusChanged', () {
      test('should both class instances are equal', () async {
        expect(AuthenticationStatusChanged(AuthenticationStatus.unknown),
            AuthenticationStatusChanged(AuthenticationStatus.unknown));
      });
    });
    group('AuthenticationLogoutRequested', () {
      test('support value comparisons', () {
        expect(
            AuthenticationLogoutRequested(), AuthenticationLogoutRequested());
      });
    });
  });
}
