import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:api_playground/screens/login.dart';
import 'package:api_playground/screens/things.dart';

class AppState extends ChangeNotifier {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late String firstName;

  Future<bool> get isLoggedIn async {
    return _prefs.then((SharedPreferences prefs) {
      return prefs.getBool('isLoggedIn') ?? false;
    });
  }

  set isLoggedIn(val) {
    _prefs.then((SharedPreferences prefs) {
      prefs.setBool('isLoggedIn', val);
    });
  }

  // login
  void login(BuildContext context) {
    isLoggedIn = true;

    // navigate to ThingsScreen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const ThingsScreen()),
    );

    notifyListeners();
  }

  void logout(BuildContext context) {
    isLoggedIn = false;

    // navigate to LoginScreen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );

    notifyListeners();
  }
}