import 'package:api_playground/models.dart';
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
        child: ThingsListWidget(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (BuildContext context) => const ThingCreateWidget(),
        ),
        tooltip: "Create new Thing",
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ThingCreateWidget extends StatefulWidget {
  const ThingCreateWidget({Key? key}) : super(key: key);

  @override
  State<ThingCreateWidget> createState() => _ThingCreateWidgetState();
}

class _ThingCreateWidgetState extends State<ThingCreateWidget> {
  final _controller = TextEditingController();

  void _handleSubmit() async {
    String _thingName = _controller.text;
    await ThingsService().thingCreate(_thingName);
    store.fetchThings();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Create New Thing"),
      content: TextFormField(
        controller: _controller,
        onChanged: (val) => setState(() {}),
        decoration: const InputDecoration(hintText: "Name of this Thing"),
        onFieldSubmitted: (x) async => _handleSubmit(),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text("Cancel"),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: const Text("OK"),
          onPressed: () async {
            _controller.text.isNotEmpty ? _handleSubmit() : null;
          },
        ),
      ],
    );
  }
}

class ThingsListWidget extends StatelessWidget {
  const ThingsListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        if (!store.initialFetchCompleted) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                  height: 32.0,
                  width: 32.0,
                  child: CircularProgressIndicator()),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Loading...",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          );
        } else if (store.things.isEmpty) {
          return const Text("You have not created any Things.");
        }

        return RefreshIndicator(
          onRefresh: () async {
            await store.fetchThings();
          },
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  "Your Things",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: store.things.length,
                  itemBuilder: (BuildContext context, int i) {
                    return ListTile(
                      onTap: () {
                        widgetHelpers.snackBarShow(
                          context, "Thing '${store.things[i].name}' tapped");
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
            ],
          ),
        );
      },
    );
  }
}
