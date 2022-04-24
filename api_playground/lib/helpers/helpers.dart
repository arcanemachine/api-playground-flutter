import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:api_playground/state.dart';

class Helpers extends ChangeNotifier {
  init() async {}

  snackbarShow(context, message) {
    final _messenger = ScaffoldMessenger.of(context);

    // hide existing snackbars
    _messenger.clearSnackBars();

    return _messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {},
        ),
      ),
    );
  }

  void login(BuildContext context) {
    sharedPrefs.isLoggedIn = true;
    context.go('/things');
    snackbarShow(context, "Login successful");

    notifyListeners();
  }

  void logout(BuildContext context) {
    sharedPrefs.isLoggedIn = false;
    context.go('/login');
    snackbarShow(context, "Logout successful");

    notifyListeners();
  }
}
final helpers = Helpers();
