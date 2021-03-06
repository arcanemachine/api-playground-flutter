import 'package:flutter/material.dart';

import 'package:api_playground/helpers.dart';

class AppWidgets {
  init() async {}
  static final auth = AuthWidgets();
}

class AuthWidgets {
  PreferredSizeWidget loggedInAppBar(BuildContext context, String title) {
    return AppBar(
      title: Text(title),
      actions: [
        PopupMenuButton(
          itemBuilder: (context) {
            return <PopupMenuEntry>[
              PopupMenuItem( // logout
                child: const Text("Logout"),
                onTap: () {
                  WidgetsBinding.instance?.addPostFrameCallback((_) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text("Confirm Logout"),
                        content: const Text("Are you sure you want to log out?"),
                        actions: <Widget>[
                          TextButton(
                            child: const Text("No"),
                            onPressed: () => Navigator.pop(context),
                          ),
                          TextButton(
                            child: const Text("Yes"),
                            onPressed: () {
                              helpers.logout(context);
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    );
                  });
                },
              )
            ];
          },
        ),
      ],
    );
  }
}

class WidgetHelpers {
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackBarShow(
      BuildContext context, String message
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
