import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'package:api_playground/widgets.dart';
import 'package:api_playground/helpers.dart';
import 'package:api_playground/stores/things.dart';

final store = ThingsStore();

class ThingsScreen extends StatelessWidget {
  const ThingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppWidgets.auth.loggedInAppBar(context, "Your Things"),
      body: const Center(
        child: ThingsWidget(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // context.read<ThingsState>().fetchThingsList();
        },
        tooltip: "Create new Thing",
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ThingsWidget extends StatelessWidget {
  const ThingsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        if (!store.initialFetchCompleted) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 32.0, width: 32.0,
                child: CircularProgressIndicator()
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text("Loading...",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          );
        } else if (store.things.isEmpty) {
          return const Text("You have not created any Things.");
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32.0),
                    child: Text("Your Things",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: store.things.length,
                        itemBuilder: (BuildContext context, int i) {
                          return ListTile(
                            onTap: () {
                              helpers.snackBarShow(
                                context, "'${store.things[i].name}' tapped"
                              );
                            },
                            title: Text(
                              "- ${store.things[i].name}",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}