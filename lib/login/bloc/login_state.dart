part of 'login_bloc.dart';

class LoginState extends Equatable {
  final FormzStatus formzStatus;
  final Username username;
  final Password password;

  const LoginState({
    this.formzStatus = FormzStatus.pure,
    this.username = const Username.pure(),
    this.password = const Password.pure(),
  });

  LoginState copyWith({
    FormzStatus? formzStatus,
    Username? username,
    Password? password,
  }) {
    return LoginState(
      formzStatus: formzStatus ?? this.formzStatus,
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }

  @override
  List<Object> get props => [formzStatus, username, password];
}
