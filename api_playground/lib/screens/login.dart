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

class LoginWidget extends StatefulWidget {
  const LoginWidget({Key? key}) : super(key: key);

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  // String username = "";
  // String password = "";

  @override
  Widget build(BuildContext context) {
    final _helpers = context.watch<Helpers>();
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    // setup controllers
    final _usernameController =
      TextEditingController.fromValue(const TextEditingValue(text: ""));
    final _passwordController =
      TextEditingController.fromValue(const TextEditingValue(text: ""));

    Widget _loginForm() {
      final ButtonStyle _buttonStyle = ElevatedButton.styleFrom(
        // padding: const EdgeInsets.all(16.0),
        textStyle: const TextStyle(fontSize: 20.0),
        minimumSize: const Size(300, 60),
      );

      void _handleSubmit() {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Form submitted"),
            action: SnackBarAction(
              label: 'OK',
              onPressed: () {},
            ),
          ),
        );
      }

      return Form(
        key: _formKey,
        child: Container(
          constraints: const BoxConstraints(minWidth: 300, maxWidth: 300),
          child: Column(
            children: [
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.person),
                  labelText: "Username *",
                ),
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.key),
                  labelText: "Password *",
                ),
                obscureText: true,
              ),
              const SizedBox(height: 30.0),
              Center(
                child: ElevatedButton(
                  child: const Text("Login"),
                  style: _buttonStyle,
                  onPressed: _handleSubmit,
                ),
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

