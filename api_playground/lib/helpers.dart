import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:api_playground/state.dart';

class Helpers {
  init() async {}

  void login(BuildContext context, String userApiToken) {
    secureStorage.write('user_api_token', userApiToken).then((x) {
      sharedPrefs.isLoggedIn = true;
      context.go('/things');
      helperWidgets.snackBarShow(context, "Login successful");
    });
  }

  void logout(BuildContext context) {
    secureStorage.delete('user_api_token');
    sharedPrefs.isLoggedIn = false;
    context.go('/');
    helperWidgets.snackBarShow(context, "Logout successful");
  }

  String? validateEmail(String? value) {
    String pattern =
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = RegExp(pattern);
    if (value == null || value.isEmpty || !regex.hasMatch(value)) {
      return 'Enter a valid email address';
    } else {
      return null;
    }
  }
}
final helpers = Helpers();

class HelperWidgets {
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
final helperWidgets = HelperWidgets();