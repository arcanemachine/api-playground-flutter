import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    bool _isLoading = false;

    // controllers
    final _usernameController =
      TextEditingController.fromValue(const TextEditingValue(text: "user"));
    final _passwordController =
      TextEditingController.fromValue(const TextEditingValue(text: "password"));


    // widgets
    Widget _loginForm() {
      final _globals = context.read<Globals>();

      final ButtonStyle _buttonStyle = ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 20.0),
        minimumSize: const Size(300, 60),
      );

      void _handleSubmit() async {
        if (kDebugMode) print("_handleSubmit()");
        final String _username = _usernameController.text;
        final String _password = _passwordController.text;

        // set loading status
        _isLoading = true;

        // attempt to login
        final Uri _loginUrl = Uri.parse(_globals.urls.login);
        final http.Response _response = await http.post(_loginUrl, body: {
          "username": _username,
          "password": _password,
        });

        // reset loading status
        _isLoading = false;

        if (_response.statusCode == 200) {
          final decodedResponse = jsonDecode(_response.body);

          // update state
          await secureStorage  // save token to secure storage
            .write('user_api_token', decodedResponse['key']);
          sharedPrefs.isLoggedIn = true; // set login status

          // login
          context.read<Helpers>().login(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              // content: Text("Form submitted"),
              content: Text(
                "Error ${_response.statusCode}: ${_response.reasonPhrase}"
              ),
              // content: Text("loginUrl: $_loginUrl"),
              action: SnackBarAction(
                label: 'OK',
                onPressed: () {},
              ),
            ),
          );
        }
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
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return "This field must not be empty.";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  icon: Icon(Icons.key),
                  labelText: "Password *",
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return "This field must not be empty.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30.0),
              Center(
                child: ElevatedButton(
                  child: _isLoading
                    ? const Text("Loading...")
                    : const Text("Login"),
                  style: _buttonStyle,
                  onPressed: () async { _handleSubmit(); },
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

