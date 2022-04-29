import 'package:api_playground/helpers.dart';
import 'package:flutter/material.dart';

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

  void _isLoadingSet(bool isLoading) {
    setState(() { _isLoading = isLoading; });
  }

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
    return;
  }

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