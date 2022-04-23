import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    context.go('/things');

    notifyListeners();
  }

  void logout(BuildContext context) {
    isLoggedIn = false;
    context.go('/login');

    notifyListeners();
  }
}