import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:api_playground/state.dart';


class ThingsScreen extends StatelessWidget {
  const ThingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            ThingsWidget(),
          ],
        ),
      ),
    );
  }
}

class ThingsWidget extends StatelessWidget {
  const ThingsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _helpers = context.watch<Helpers>();
    final List _dummyThings = [{'name': "Thing 1", 'id': 0},
                               {'name': "Thing 2", 'id': 1}];

    return Expanded(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text("Your Things",
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          Expanded(
            child: Center(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _dummyThings.length,
                itemBuilder: (BuildContext context, int i) {
                  return ListTile(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "'${_dummyThings[i]['name']}' tapped"
                            ),
                            action: SnackBarAction(
                              label: 'OK',
                              onPressed: () {},
                            ),
                          ),
                        );
                      },
                      title: Text(_dummyThings[i]['name'],
                        textAlign: TextAlign.center,
                      )
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              child: const Text("Logout"),
              onPressed: () => _helpers.logout(context),
            ),
          ),
        ],
      ),
    );
  }
}

