import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:login_ttd/login/bloc/login_bloc.dart';
import 'package:login_ttd/login/view/login_form.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginBloc extends Mock implements LoginBloc {}

void main() {
  const String tUsername = 'tUsername';
  const String tPassword = 'tPassword';
  late LoginBloc mockLoginBloc;
  setUp(() {
    mockLoginBloc = MockLoginBloc();
  });

  void setUpInitialState() {
    when(() => mockLoginBloc.state).thenReturn(LoginState());
    when(() => mockLoginBloc.stream)
        .thenAnswer((_) => Stream.value(LoginState()));
  }

  Future<void> pumpLoginFormWidget(WidgetTester widgetTester) async {
    await widgetTester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: BlocProvider.value(
          value: mockLoginBloc,
          child: LoginForm(),
        ),
      ),
    ));
  }

  testWidgets(
      'adds LoginUsernameChanged event to LoginBloc when username is updated',
      (widgetTester) async {
    setUpInitialState();
    await pumpLoginFormWidget(widgetTester);
    await widgetTester.enterText(
        find.byKey(const Key('loginForm_usernameInput_textField')), tUsername);

    verify(() => mockLoginBloc.add(LoginUsernameChanged(tUsername))).called(1);
  });

  testWidgets('add PasswordChangedState when changing password field',
      (widgetTester) async {
    setUpInitialState();
    await pumpLoginFormWidget(widgetTester);
    await widgetTester.enterText(
        find.byKey(const Key('loginForm_passwordInput_textField')), tPassword);
    verify(() => mockLoginBloc.add(LoginPasswordChanged(tPassword))).called(1);
  });

  testWidgets('continue button is disable by default', (widgetTester) async {
    setUpInitialState();
    await pumpLoginFormWidget(widgetTester);
    final ElevatedButton button =
        widgetTester.widget(find.byType(ElevatedButton));
    expect(button.enabled, false);
  });

  testWidgets('loading indicator is shown when form submission is in progress',
      (widgetTester) async {
    when(() => mockLoginBloc.state)
        .thenReturn(LoginState(formzStatus: FormzStatus.submissionInProgress));
    when(() => mockLoginBloc.stream).thenAnswer((_) => Stream.value(
        LoginState(formzStatus: FormzStatus.submissionInProgress)));
    await pumpLoginFormWidget(widgetTester);

    expect(find.byType(ElevatedButton), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('continue button is enable when formzStatus is successful',
      (widgetTester) async {
    when(() => mockLoginBloc.state)
        .thenReturn(LoginState(formzStatus: FormzStatus.submissionSuccess));
    when(() => mockLoginBloc.stream).thenAnswer((_) =>
        Stream.value(LoginState(formzStatus: FormzStatus.submissionSuccess)));
    await pumpLoginFormWidget(widgetTester);
    final ElevatedButton button =
        widgetTester.widget(find.byType(ElevatedButton));
    expect(button.enabled, true);
  });

  testWidgets('LoginSubmitted added to LoginBloc when submit tapped ',
      (widgetTester) async {
    when(() => mockLoginBloc.state)
        .thenReturn(LoginState(formzStatus: FormzStatus.valid));
    when(() => mockLoginBloc.stream).thenAnswer(
        (_) => Stream.value(LoginState(formzStatus: FormzStatus.valid)));
    await pumpLoginFormWidget(widgetTester);
    await widgetTester.tap(find.byType(ElevatedButton));
    verify(() => mockLoginBloc.add(LoginSubmitted())).called(1);
  });

  testWidgets('show snackBar when submission failure', (widgetTester) async {
    whenListen(
        mockLoginBloc,
        Stream.fromIterable([
          LoginState(formzStatus: FormzStatus.submissionInProgress),
          LoginState(formzStatus: FormzStatus.submissionFailure),
        ]));
    when(() => mockLoginBloc.state)
        .thenReturn(LoginState(formzStatus: FormzStatus.submissionFailure));

    await pumpLoginFormWidget(widgetTester);

    await widgetTester.pump();
    expect(find.byType(SnackBar), findsOneWidget);
  });
}
