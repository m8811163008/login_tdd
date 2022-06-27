import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:login_ttd/login/login.dart';

import '../bloc/login_bloc.dart';

class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listenWhen: (prev, current) => prev.formzStatus != current.formzStatus,
      listener: (context, state) {
        if (state.formzStatus.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Authentication Failure')),
            );
        }
      },
      child: Column(
        children: [
          _UsernameInput(),
          _PasswordInput(),
          _submitButton(),
        ],
      ),
    );
  }
}

class _UsernameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.username != current.username,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_usernameInput_textField'),
          onChanged: (username) =>
              context.read<LoginBloc>().add(LoginUsernameChanged(username)),
          decoration: InputDecoration(
            labelText: 'username',
            errorText: state.username.invalid ? 'invalid username' : null,
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_passwordInput_textField'),
          onChanged: (password) =>
              context.read<LoginBloc>().add(LoginPasswordChanged(password)),
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'password',
            errorText: state.password.invalid ? 'invalid password' : null,
          ),
        );
      },
    );
  }
}

class _submitButton extends StatelessWidget {
  const _submitButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
        buildWhen: (prev, current) => prev.formzStatus != current.formzStatus,
        builder: (context, state) {
          // late final bool isButtonEnabled;
          // if (state.formzStatus != FormzStatus.submissionSuccess) {
          //   isButtonEnabled = false;
          // } else {
          //   isButtonEnabled = true;
          // }
          // return ElevatedButton(
          //   onPressed: isButtonEnabled ? () {} : null,
          //   child: Text('login'),
          // );

          return state.formzStatus.isSubmissionInProgress ||
                  state.formzStatus.isSubmissionSuccess
              ? CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: state.formzStatus.isValidated
                      ? () {
                          context.read<LoginBloc>().add(LoginSubmitted());
                        }
                      : null,
                  child: Text('login'),
                );
        });
  }
}
