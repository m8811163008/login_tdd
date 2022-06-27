import 'package:flutter_test/flutter_test.dart';
import 'package:login_ttd/authentication/bloc/authentication_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_repository/user_repository.dart';

class MockUser extends Mock implements User {}

void main() {
  group('AuthenticationState', () {
    group('AuthenticationState.unknown', () {
      test('support value comparison', () {
        expect(AuthenticationState.unknown(), AuthenticationState.unknown());
      });
    });

    group('AuthenticationState.authenticated', () {
      test('support value comparison', () {
        final user = MockUser();
        expect(AuthenticationState.authenticated(user),
            AuthenticationState.authenticated(user));
      });
    });
    group('AuthenticationState.unauthenticated', () {
      test('supports value comparisons', () {
        expect(
          AuthenticationState.unauthenticated(),
          AuthenticationState.unauthenticated(),
        );
      });
    });
  });
}
