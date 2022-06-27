import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:login_ttd/authentication/bloc/authentication_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_repository/user_repository.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  const user = User('id');
  late AuthenticationRepository mockAuthenticationRepository;
  late UserRepository mockUserRepository;

  setUp(() {
    mockAuthenticationRepository = MockAuthenticationRepository();
    when(() => mockAuthenticationRepository.status)
        .thenAnswer((_) => Stream.empty());
    mockUserRepository = MockUserRepository();
  });

  group('AuthenticationBloc', () {
    test('initial state should be AuthenticationStatus.unknown', () async {
      //arrange
      final sut = AuthenticationBloc(
          authenticationRepository: mockAuthenticationRepository,
          userRepository: mockUserRepository);
      //act

      //verify interactions with mockObjects

      //assert
      expect(sut.state.authenticationStatus, AuthenticationStatus.unknown);
      sut.close();
    });

    blocTest<AuthenticationBloc, AuthenticationState>(
      'emits [unauthenticated] when status is unauthenticated',
      build: () => AuthenticationBloc(
          authenticationRepository: mockAuthenticationRepository,
          userRepository: mockUserRepository),
      setUp: () {
        when(() => mockAuthenticationRepository.status).thenAnswer(
            (_) => Stream.value(AuthenticationStatus.unauthenticated));
      },
      act: (bloc) {
        bloc.add(
            AuthenticationStatusChanged(AuthenticationStatus.unauthenticated));
      },
      expect: () =>
          <AuthenticationState>[AuthenticationState.unauthenticated()],
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
        'emits [authenticated] when status is authenticated',
        build: () => AuthenticationBloc(
            authenticationRepository: mockAuthenticationRepository,
            userRepository: mockUserRepository),
        setUp: () {
          when(() => mockAuthenticationRepository.status).thenAnswer(
              (invocation) => Stream.value(AuthenticationStatus.authenticated));
          when(() => mockUserRepository.getUser())
              .thenAnswer((_) async => user);
        },
        act: (bloc) {
          bloc.add(
              AuthenticationStatusChanged(AuthenticationStatus.authenticated));
        },
        expect: () =>
            <AuthenticationState>[AuthenticationState.authenticated(user)]);

    blocTest<AuthenticationBloc, AuthenticationState>(
        'emit [unauthenticated] when get user with error',
        build: () => AuthenticationBloc(
            authenticationRepository: mockAuthenticationRepository,
            userRepository: mockUserRepository),
        setUp: () {
          when(() => mockUserRepository.getUser()).thenThrow(Exception('___'));
        },
        act: (bloc) {
          bloc.add(
              AuthenticationStatusChanged(AuthenticationStatus.authenticated));
        },
        expect: () => [AuthenticationState.unauthenticated()]);

    blocTest<AuthenticationBloc, AuthenticationState>(
        'emit [unauthenticated] when get user is null',
        build: () => AuthenticationBloc(
            authenticationRepository: mockAuthenticationRepository,
            userRepository: mockUserRepository),
        setUp: () {
          when(() => mockUserRepository.getUser())
              .thenAnswer((_) async => null);
        },
        act: (bloc) {
          bloc.add(
              AuthenticationStatusChanged(AuthenticationStatus.authenticated));
        },
        expect: () => [AuthenticationState.unauthenticated()]);

    blocTest<AuthenticationBloc, AuthenticationState>(
        'emits [unknown] when status is unknown',
        build: () => AuthenticationBloc(
            authenticationRepository: mockAuthenticationRepository,
            userRepository: mockUserRepository),
        setUp: () {
          when(() => mockAuthenticationRepository.status)
              .thenAnswer((_) => Stream.value(AuthenticationStatus.unknown));
        },
        act: (bloc) {
          bloc.add(AuthenticationStatusChanged(AuthenticationStatus.unknown));
        },
        expect: () => [AuthenticationState.unknown()]);
  });

  group('AuthenticationLogoutRequested', () {
    blocTest<AuthenticationBloc, AuthenticationState>(
      'call logout in repository when AuthenticationLogoutRequested is added',
      build: () => AuthenticationBloc(
          authenticationRepository: mockAuthenticationRepository,
          userRepository: mockUserRepository),
      act: (bloc) => bloc.add(AuthenticationLogoutRequested()),
      verify: (_) {
        verify(() => mockAuthenticationRepository.logout()).called(1);
      },
    );
  });
}
