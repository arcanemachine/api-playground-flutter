import 'package:flutter/material.dart';

import 'package:api_playground/state.dart';
import 'package:provider/provider.dart';

class AuthWidgets {
  PreferredSizeWidget loggedInAppBar(BuildContext context, String title) {
    return AppBar(
      title: Text(title),
      actions: [
        PopupMenuButton(
          itemBuilder: (context) {
            return <PopupMenuEntry>[
              // logout
              PopupMenuItem(
                child: const Text("Logout"),
                onTap: () {
                  WidgetsBinding?.instance?.addPostFrameCallback((_) {
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
                              context.read<Helpers>().logout(context);
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