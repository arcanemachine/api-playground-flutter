import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:api_playground/state.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final _state = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            LoginWidget()
          ],
        ),
      ),
    );
  }
}

class LoginWidget extends StatelessWidget {
  const LoginWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _state = context.watch<AppState>();

    Widget _loginForm() {
      final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

      return Padding(
        padding: const EdgeInsets.all(32.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              ElevatedButton(
                child: const Text("Login"),
                onPressed: () => _state.login(context),
              ),
            ],
          ),
        ),
      );
    }

    return Center(
      child: Column(
        children: <Widget>[
          Text('Welcome!',
            style: Theme.of(context).textTheme.headline5,
          ),
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text('Please login to continue.'),
          ),
          _loginForm(),
        ],
      ),
    );
  }
}

