import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:api_playground/globals.dart';
import 'package:api_playground/helpers.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _loginButtonActive = false;

  void _isLoadingSet(bool val) {
    setState(() { _isLoading = val; });
  }

  void _updateLoginButtonStatus() {
    late bool _buttonIsActive;

    // determine button status
    if (!_isLoading
        && _usernameController.text.isNotEmpty
        && _passwordController.text.isNotEmpty) {
      _buttonIsActive = true;
    } else {
      _buttonIsActive = false;
    }

    // update state
    setState(() {
      _loginButtonActive = _buttonIsActive;
    });
  }

  // controllers
  final _usernameController =
    TextEditingController.fromValue(const TextEditingValue(text: "user"));
  final _passwordController =
    TextEditingController.fromValue(const TextEditingValue(text: "password"));

  // widgets
  Widget _loginForm() {
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
      final Uri _loginUrl = Uri.parse(Globals().urls.login);
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
              onChanged: (x) { _updateLoginButtonStatus(); },
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
              onChanged: (x) { _updateLoginButtonStatus(); },
              onFieldSubmitted: _loginButtonActive
                ? (x) { _handleSubmit(); } : null,
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
                onPressed: _loginButtonActive && !_isLoading
                  ? () { _handleSubmit(); } : null,
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