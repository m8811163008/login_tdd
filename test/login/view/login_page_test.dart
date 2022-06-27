import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:login_ttd/login/login.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

void main() {
  group('LoginPage', () {
    late AuthenticationRepository mockAuthenticationRepository;
    setUp(() {
      mockAuthenticationRepository = MockAuthenticationRepository();
    });

    test('route is MaterialPageRoute', () {
      expect(LoginPage.route(), isA<MaterialPageRoute<LoginPage>>());
    });

    testWidgets('renders a login form ', (widgetTester) async {
      await widgetTester.pumpWidget(RepositoryProvider.value(
        value: (_) => mockAuthenticationRepository,
        child: BlocProvider(
          create: (_) => LoginBloc(
            authenticationRepository: mockAuthenticationRepository,
          ),
          child: MaterialApp(
            home: Scaffold(
              body: LoginPage(),
            ),
          ),
        ),
      ));
      expect(find.byType(LoginPage), findsOneWidget);
    });
  });
}
