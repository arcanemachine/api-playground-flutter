import 'dart:collection';

import 'package:api_playground/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:api_playground/helpers.dart';
import 'package:api_playground/models.dart';
import 'package:provider/provider.dart';


class ThingsState extends ChangeNotifier {
  late final List<Thing> _things;
  UnmodifiableListView get things => UnmodifiableListView(_things);

  // init
  ThingsState() {
    if (kDebugMode) print('fetchData()');
    _things = fetchThingsList();

    notifyListeners();
  }

  void add(Thing thing) {
    _things.add(thing);
    notifyListeners();
  }

  void remove(Thing thing) {
    _things.remove(thing);
    notifyListeners();
  }

  List<Thing> fetchThingsList() {
    // final String ;

    return <Thing>[];
  }
}

class ThingsListScreen extends StatelessWidget {
  const ThingsListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThingsState(),
      child: Scaffold(
        appBar: AppWidgets.auth.loggedInAppBar(context, "Your Things"),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              ThingsListWidget(),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.read<ThingsState>().fetchThingsList();
          },
          tooltip: "Create new Thing",
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class ThingsListWidget extends StatelessWidget {
  const ThingsListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List _things = context.watch<ThingsState>().things;

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
                itemCount: _things.isEmpty ? 1 : _things.length,
                itemBuilder: (BuildContext context, int i) {
                  return ListTile(
                    onTap: () {
                      helpers.snackBarShow(
                        context, "'${_things[i]['name']}' tapped"
                      );
                    },
                    title: Text(
                      _things.isEmpty
                        ? "You have not created any Things."
                        : _things[i]['name'],
                      textAlign: TextAlign.center)
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}