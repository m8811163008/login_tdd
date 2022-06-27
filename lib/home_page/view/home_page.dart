//The HomePage can access the current user id via context.select((AuthenticationBloc bloc) => bloc.state.user.id) and displays it via a Text widget. In addition, when the logout button is tapped, an AuthenticationLogoutRequested event is added to the AuthenticationBloc.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_ttd/authentication/bloc/authentication_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => HomePage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Builder(builder: (context) {
            final userId =
                context.select((AuthenticationBloc bloc) => bloc.state.user.id);
            return Text('login user id : $userId');
          }),
          ElevatedButton(
              onPressed: () {
                context
                    .read<AuthenticationBloc>()
                    .add(AuthenticationLogoutRequested());
              },
              child: Text('log out'))
        ],
      ),
    );
  }
}
