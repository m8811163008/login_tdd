part of 'authentication_bloc.dart';

class AuthenticationState extends Equatable {
  final User user;
  final AuthenticationStatus authenticationStatus;

  const AuthenticationState._(
      {this.user = User.empty,
      this.authenticationStatus = AuthenticationStatus.unknown});

  const AuthenticationState.unknown() : this._();

  const AuthenticationState.authenticated(User user)
      : this._(
            user: user,
            authenticationStatus: AuthenticationStatus.authenticated);

  const AuthenticationState.unauthenticated()
      : this._(authenticationStatus: AuthenticationStatus.unauthenticated);

  @override
  List<Object> get props => [user, authenticationStatus];
}
