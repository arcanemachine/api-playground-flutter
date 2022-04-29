import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import 'package:api_playground/helpers.dart';
import 'package:api_playground/globals.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register New Account"),
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: const <Widget>[
            RegisterFormWidget()
          ],
        ),
      ),
    );
  }
}

class RegisterFormWidget extends StatefulWidget {
  const RegisterFormWidget({Key? key}) : super(key: key);

  @override
  State<RegisterFormWidget> createState() => _RegisterFormWidgetState();
}

class _RegisterFormWidgetState extends State<RegisterFormWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  bool get _loginButtonEnabled => !_isLoading
      && _usernameController.text.isNotEmpty
      && _password1Controller.text.isNotEmpty
      && _password1Controller.text == _password2Controller.text;

  // controllers
  final _usernameController =
    TextEditingController.fromValue(const TextEditingValue(text: "user"));
  final _emailController =
    TextEditingController.fromValue(const TextEditingValue(text: "user@example.com"));
  final _password1Controller =
    TextEditingController.fromValue(const TextEditingValue(text: "pass123123"));
  final _password2Controller =
    TextEditingController.fromValue(const TextEditingValue(text: "pass123123"));

  // methods
  void _handleSubmit() async {
    String _username = _usernameController.text;
    String _email = _emailController.text;
    String _password1 = _password1Controller.text;
    String _password2 = _password2Controller.text;

    setState(() { _isLoading = true; });

    try {
      await _userRegister(_username, _email, _password1, _password2)
          .then((x) {
        context.go('/');
        helperWidgets.snackBarShow(context, "Registration successful");
      });
    } on Exception catch (e) {
      setState(() {
        _isLoading = false;
      });
      helperWidgets.snackBarShow(context, e.toString().substring(11));
    }
  }

  Future<void> _userRegister(
      String username, String email, String password1, String password2
  ) async {
    final url = Uri.parse(globals.urls.userRegister);

    final Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    final Object body = {
      'username': username,
      'email': email,
      'password1': password1,
      'password2': password2,
    };

    final response =
      await http.post(url, headers: headers, body: jsonEncode(body));
    final Map<String, dynamic> decodedJson = jsonDecode(response.body);

    if (response.statusCode != 201) {
      // throw the first exception message we can find
      for (var key in decodedJson.keys) {
        throw Exception(decodedJson[key][0]);
      }
    }
  }

  // widgets
  Widget _registerForm(BuildContext context) {
    final ButtonStyle _registerButtonStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20.0),
      minimumSize: const Size(300, 60),
    );

    return Form(
      key: _formKey,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 300),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(
                icon: Icon(Icons.person),
                labelText: "Username *",
              ),
              onChanged: (x) => setState(() {}),
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return "This field must not be empty.";
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                icon: Icon(Icons.key),
                labelText: "Email *",
              ),
              onChanged: (x) => setState(() {}),
              validator: (val) => helpers.validateEmail(val),
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _password1Controller,
              obscureText: true,
              decoration: const InputDecoration(
                icon: Icon(Icons.key),
                labelText: "Password *",
              ),
              onChanged: (x) => setState(() {}),
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return "This field must not be empty.";
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _password2Controller,
              obscureText: true,
              decoration: const InputDecoration(
                icon: Icon(Icons.key),
                labelText: "Confirm Password *",
              ),
              onChanged: (x) => setState(() {}),
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return "This field must not be empty.";
                } else if (val != _password1Controller.text) {
                  return "The passwords do not match.";
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            const SizedBox(height: 32.0),
            ElevatedButton(
              child: !_isLoading ?
                const Text("Register") : const CircularProgressIndicator(),
              onPressed: _loginButtonEnabled ? () { _handleSubmit(); } : null,
              style: _registerButtonStyle,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("Register New Account",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline5,
        ),
        const SizedBox(height: 24.0),
        _registerForm(context),
      ],
    );
  }
}