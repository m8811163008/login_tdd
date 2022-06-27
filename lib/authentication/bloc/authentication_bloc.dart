import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationRepository _authenticationRepository;
  UserRepository _userRepository;
  late StreamSubscription<AuthenticationStatus>
      _streamAuthenticationStatusSubscription;

  @override
  Future<void> close() {
    _streamAuthenticationStatusSubscription.cancel();
    _authenticationRepository.dispose();
    return super.close();
  }

  AuthenticationBloc(
      {required AuthenticationRepository authenticationRepository,
      required UserRepository userRepository})
      : _authenticationRepository = authenticationRepository,
        _userRepository = userRepository,
        super(AuthenticationState.unknown()) {
    on<AuthenticationStatusChanged>(_onAuthenticationStatusChanged);
    on<AuthenticationLogoutRequested>(_onAuthenticationLogoutRequested);
    _streamAuthenticationStatusSubscription =
        authenticationRepository.status.listen((status) {
      add(AuthenticationStatusChanged(status));
    });
  }

  void _onAuthenticationStatusChanged(AuthenticationStatusChanged event,
      Emitter<AuthenticationState> emit) async {
    switch (event.status) {
      case AuthenticationStatus.unauthenticated:
        return emit(const AuthenticationState.unauthenticated());

      case AuthenticationStatus.authenticated:
        final User? user = await _tryGetUser();

        if (user != null) {
          return emit(AuthenticationState.authenticated(user));
        } else {
          return emit(AuthenticationState.unauthenticated());
        }
      case AuthenticationStatus.unknown:
      default:
        return emit(AuthenticationState.unknown());
    }
  }

  Future<User?> _tryGetUser() async {
    try {
      return await _userRepository.getUser();
    } catch (_) {
      return null;
    }
  }

  void _onAuthenticationLogoutRequested(AuthenticationLogoutRequested event,
      Emitter<AuthenticationState> emit) async {
    _authenticationRepository.logout();
  }
}
