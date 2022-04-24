import 'dart:convert';

// ignore: unnecessary_import
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'package:api_playground/state.dart';
import 'package:api_playground/helpers/helpers.dart';


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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var _isLoading = false;

  void _isLoadingSet(bool val) {
    setState(() { _isLoading = val; });
  }

  // controllers
  final _usernameController =
  TextEditingController.fromValue(const TextEditingValue(text: "user"));
  final _passwordController =
  TextEditingController.fromValue(const TextEditingValue(text: "password"));

  // widgets
  Widget _loginForm() {
    final _globals = context.read<Globals>();

    final ButtonStyle _loginButtonStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20.0),
      minimumSize: const Size(300, 60),
    );

    void _handleSubmit() async {
      // if (kDebugMode) print("_handleSubmit()");
      final String _username = _usernameController.text;
      final String _password = _passwordController.text;

      // set loading status
      _isLoadingSet(true);

      // attempt to login
      final Uri _loginUrl = Uri.parse(_globals.urls.login);
      final http.Response _response = await http.post(_loginUrl, body: {
        "username": _username,
        "password": _password,
      });

      // reset loading status
      _isLoadingSet(false);

      if (_response.statusCode == 200) {
        final decodedResponse = jsonDecode(_response.body);

        // update state
        await secureStorage  // save token to secure storage
            .write('user_api_token', decodedResponse['key']);
        sharedPrefs.isLoggedIn = true; // set login status

        // login
        helpers.login(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                "Error ${_response.statusCode}: ${_response.reasonPhrase}"
            ),
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
              autovalidateMode: AutovalidateMode.onUserInteraction,
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
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            const SizedBox(height: 30.0),
            Center(
              child: ElevatedButton(
                child: !_isLoading
                  ? const Text("Login")
                  : const CircularProgressIndicator(),
                style: _loginButtonStyle,
                onPressed: _isLoading ? null : () async {
                  if (_formKey.currentState!.validate()) {
                    _handleSubmit();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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