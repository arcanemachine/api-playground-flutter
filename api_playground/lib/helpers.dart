import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:api_playground/state.dart';

class Helpers extends ChangeNotifier {
  init() async {}

  void login(BuildContext context) {
    sharedPrefs.isLoggedIn = true;
    context.go('/things');
    widgetHelpers.snackBarShow(context, "Login successful");

    notifyListeners();
  }

  void logout(BuildContext context) {
    sharedPrefs.isLoggedIn = false;
    context.go('/login');
    widgetHelpers.snackBarShow(context, "Logout successful");

    notifyListeners();
  }

}
final helpers = Helpers();

class WidgetHelpers {
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackBarShow(
    context, message
  ) {
    final _messenger = ScaffoldMessenger.of(context);

    // hide existing snackbars
    _messenger.clearSnackBars();

    return _messenger.showSnackBar(
      SnackBar(
        elevation: 10000.0,
        content: Text(message),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {},
        ),
      ),
    );
  }

  void dialogShow(BuildContext context, AlertDialog alertDialog) {
    showDialog(
      context: context,
      builder: (BuildContext context) => alertDialog,
    );
  }
}
final widgetHelpers = WidgetHelpers();