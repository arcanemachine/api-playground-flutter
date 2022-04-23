import 'dart:io';

import 'package:flutter/material.dart';

import 'package:api_playground/screens/login.dart';
import 'package:api_playground/screens/things.dart';


class AppState extends ChangeNotifier {
  bool isLoggedIn = false;
  late String firstName;

  void login(BuildContext context) {
    stdout.writeln("login()");

    isLoggedIn = true;

    // navigate to ThingsScreen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const ThingsScreen()),
    );

    stdout.writeln("isLoggedIn: $isLoggedIn");

    notifyListeners();
  }

  void logout(BuildContext context) {
    isLoggedIn = false;

    // navigate to ThingsScreen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );

    notifyListeners();
  }
}