import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import 'package:api_playground/globals.dart';
import 'package:api_playground/helpers.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  Widget _uselessDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Center(
              child: Text("Useless Drawer",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                ),
              ),
            )
          ),
          ListTile(
            title: const Text(
              "This drawer is just here to make it easy to check the "
              "smoothness of animations on older devices."
            ),
            onTap: () { Navigator.pop(context); },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      drawer: _uselessDrawer(context),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: const <Widget>[
            LoginFormWidget(),
          ],
        ),
      ),
    );
  }
}

class LoginFormWidget extends StatefulWidget {
  const LoginFormWidget({Key? key}) : super(key: key);

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  void _isLoadingSet(bool isLoading) {
    setState(() { _isLoading = isLoading; });
  }

  bool get _loginButtonEnabled => !_isLoading
    && _usernameController.text.isNotEmpty
    && _passwordController.text.isNotEmpty;

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

    return Form(
      key: _formKey,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 300),
        child: Column(
          children: [
            const SizedBox(height: 16.0),
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
            ),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                icon: Icon(Icons.key),
                labelText: "Password *",
              ),
              onChanged: (x) => setState(() {}),
              onFieldSubmitted: (x) =>  _handleSubmit(),
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return "This field must not be empty.";
                }
                return null;
              },
            ),
            const SizedBox(height: 32.0),
            Center(
              child: ElevatedButton(
                child: !_isLoading ?
                  const Text("Login") : const CircularProgressIndicator(),
                style: _loginButtonStyle,
                onPressed: _loginButtonEnabled ? () { _handleSubmit(); } : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _registerButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: TextButton(
        child: const Text("Register new account",
          style: TextStyle(
            decoration: TextDecoration.underline,
          ),
        ),
        onPressed: () {
          context.push('/register');
        },
      ),
    );
  }

  // methods
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

      helpers.login(context, decodedResponse['key']);
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
          _registerButton(),
        ],
      ),
    );
  }
}