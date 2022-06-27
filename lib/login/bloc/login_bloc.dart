import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:login_ttd/login/models/password.dart';
import 'package:login_ttd/login/models/username.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthenticationRepository _authenticationRepository;

  LoginBloc({required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(LoginState()) {
    on<LoginUsernameChanged>(_onLoginUsernameChanged);
    on<LoginPasswordChanged>(_onLoginPasswordChanged);
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  void _onLoginPasswordChanged(
      LoginPasswordChanged event, Emitter<LoginState> emit) {
    final password = Password.dirty(event.password);
    emit(
      state.copyWith(
          password: password,
          formzStatus: Formz.validate([password, state.username])),
    );
  }

  void _onLoginUsernameChanged(
      LoginUsernameChanged event, Emitter<LoginState> emit) {
    final username = Username.dirty(event.username);
    emit(state.copyWith(
        username: username,
        formzStatus: Formz.validate([username, state.password])));
  }

  void _onLoginSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {
    if (state.formzStatus.isValidated) {
      emit(state.copyWith(formzStatus: FormzStatus.submissionInProgress));
      try {
        await _authenticationRepository.login(
            username: state.username.value, password: state.password.value);
        emit(state.copyWith(formzStatus: FormzStatus.submissionSuccess));
      } catch (_) {
        emit(state.copyWith(formzStatus: FormzStatus.submissionFailure));
      }
    }
  }
}
