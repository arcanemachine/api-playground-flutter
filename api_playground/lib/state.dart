import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {

}

class Helpers extends ChangeNotifier {
  void login(BuildContext context) {
    sharedPrefs.isLoggedIn = true;
    context.go('/things');
    notifyListeners();
  }

  void logout(BuildContext context) {
    sharedPrefs.isLoggedIn = false;
    context.go('/login');
    notifyListeners();
  }
}

// shared preferences
class SharedPrefs {
  static SharedPreferences? _sharedPrefs;

  init() async {
    _sharedPrefs ??= await SharedPreferences.getInstance();
  }

  // isLoggedIn
  bool get isLoggedIn => _sharedPrefs?.getBool('is_logged_in') ?? false;
  set isLoggedIn(bool val) {
    _sharedPrefs?.setBool('is_logged_in', val);
  }

}

final sharedPrefs = SharedPrefs();