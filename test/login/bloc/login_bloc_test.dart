import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:login_ttd/login/bloc/login_bloc.dart';
import 'package:login_ttd/login/models/models.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

void main() {
  late AuthenticationRepository mockAuthenticationRepository;
  setUp(() {
    mockAuthenticationRepository = MockAuthenticationRepository();
  });

  group('loginBloc', () {
    late LoginBloc sut;
    setUp(() {
      sut = LoginBloc(authenticationRepository: mockAuthenticationRepository);
    });
    test('init State is LoginState', () {
      expect(sut.state, LoginState());
    });

    group('LoginSubmitted', () {
      const tUsername = 'userName';
      const tPassword = 'password';
      blocTest<LoginBloc, LoginState>(
        'should emit [submissionInProgress, submissionSuccess]',
        build: () => sut,
        setUp: () {
          when(() => mockAuthenticationRepository.login(
                  username: any(named: "username"),
                  password: any(named: "password")))
              .thenAnswer((_) => Future.value('what?'));
        },
        act: (bloc) {
          bloc
            ..add(LoginUsernameChanged(tUsername))
            ..add(LoginPasswordChanged(tPassword))
            ..add(LoginSubmitted());
        },
        verify: (_) {
          mockAuthenticationRepository.login(
              username: tUsername, password: tPassword);
        },
        expect: () => <LoginState>[
          LoginState(
              username: Username.dirty(tUsername),
              formzStatus: FormzStatus.invalid),
          LoginState(
            username: Username.dirty(tUsername),
            password: Password.dirty(tPassword),
            formzStatus: FormzStatus.valid,
          ),
          LoginState(
            username: Username.dirty(tUsername),
            password: Password.dirty(tPassword),
            formzStatus: FormzStatus.submissionInProgress,
          ),
          LoginState(
            username: Username.dirty(tUsername),
            password: Password.dirty(tPassword),
            formzStatus: FormzStatus.submissionSuccess,
          ),
        ],
      );

      blocTest<LoginBloc, LoginState>(
          'emit [submissionInProgress, submissionFailure] when login fails',
          build: () => sut,
          setUp: () {
            when(() => mockAuthenticationRepository.login(
                username: any(named: 'username'),
                password: any(named: 'password'))).thenThrow(Exception(''));
          },
          act: (bloc) {
            bloc
              ..add(const LoginPasswordChanged(tPassword))
              ..add(const LoginUsernameChanged(tUsername))
              ..add(const LoginSubmitted());
          },
          expect: () => <LoginState>[
                LoginState(
                    password: Password.dirty(tPassword),
                    formzStatus: FormzStatus.invalid),
                LoginState(
                    password: Password.dirty(tPassword),
                    username: Username.dirty(tUsername),
                    formzStatus: FormzStatus.valid),
                LoginState(
                    password: Password.dirty(tPassword),
                    username: Username.dirty(tUsername),
                    formzStatus: FormzStatus.submissionInProgress),
                LoginState(
                    password: Password.dirty(tPassword),
                    username: Username.dirty(tUsername),
                    formzStatus: FormzStatus.submissionFailure)
              ]);

      blocTest<LoginBloc, LoginState>(
        'emits [LoginInProgress, LoginFailure] when logIn fails',
        setUp: () {
          when(
            () => mockAuthenticationRepository.login(
              username: 'username',
              password: 'password',
            ),
          ).thenThrow(Exception('oops'));
        },
        build: () => sut,
        act: (bloc) {
          bloc
            ..add(const LoginUsernameChanged('username'))
            ..add(const LoginPasswordChanged('password'))
            ..add(const LoginSubmitted());
        },
        expect: () => const <LoginState>[
          LoginState(
            username: Username.dirty('username'),
            formzStatus: FormzStatus.invalid,
          ),
          LoginState(
            username: Username.dirty('username'),
            password: Password.dirty('password'),
            formzStatus: FormzStatus.valid,
          ),
          LoginState(
            username: Username.dirty('username'),
            password: Password.dirty('password'),
            formzStatus: FormzStatus.submissionInProgress,
          ),
          LoginState(
            username: Username.dirty('username'),
            password: Password.dirty('password'),
            formzStatus: FormzStatus.submissionFailure,
          ),
        ],
      );
    });
  });
}
