import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:api_playground/state.dart';

class Helpers extends ChangeNotifier {
  init() async {}

  void login(BuildContext context) {
    sharedPrefs.isLoggedIn = true;
    context.go('/things');
    snackBarShow(context, "Login successful");

    notifyListeners();
  }

  void logout(BuildContext context) {
    sharedPrefs.isLoggedIn = false;
    context.go('/login');
    snackBarShow(context, "Logout successful");

    notifyListeners();
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackBarShow(
    context, message
  ) {
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
}
final helpers = Helpers();