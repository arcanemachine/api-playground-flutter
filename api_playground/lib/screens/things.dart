// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:developer';

import 'package:api_playground/globals.dart';
import 'package:api_playground/state.dart';
import 'package:api_playground/widgets.dart';
import 'package:http/http.dart' as http;
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

import 'package:api_playground/helpers.dart';
import 'package:api_playground/models.dart';

// mobx
part 'things.g.dart';

class ThingsStore = _ThingsStore with _$ThingsStore;

class ThingsService {
  Future<List<Thing>> getThings() async {
    final url = Uri.parse(Globals().urls.thingList);

    final response = await http.get(url, headers: {
      'Authorization': "Token ${await secureStorage.read('user_api_token')}",
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    });

    final List<dynamic> decodedData = jsonDecode(response.body);

    return decodedData.map((decodedJson) =>
      Thing.fromJson(decodedJson)).toList();
  }
}

abstract class _ThingsStore with Store {
  static ObservableFuture<List<Thing>> emptyResponse =
    ObservableFuture.value([]);
  ThingsService service = ThingsService();

  @observable
  ObservableList<Thing> things = ObservableList<Thing>.of([]);

  @observable
  bool initialFetchCompleted = false;

  @observable
  ObservableFuture<List<Thing>> fetchThingsFuture = emptyResponse;

  @computed
  bool get hasResults =>
    fetchThingsFuture != emptyResponse
    && fetchThingsFuture.status == FutureStatus.fulfilled;

  _ThingsStore() {
    fetchThings();
  }

  @action
  Future<void> fetchThings() async {
    // print('fetchThings()');

    await ThingsService().getThings().then((result) {
      initialFetchCompleted = true;
      things = ObservableList<Thing>.of(result);
    });
  }
}

class ThingsListScreen extends StatelessWidget {
  const ThingsListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppWidgets.auth.loggedInAppBar(context, "Your Things"),
      body: const Center(
        child: ThingsListWidget(),
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

final store = ThingsStore();

class ThingsListWidget extends StatelessWidget {
  const ThingsListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        if (!store.initialFetchCompleted) {
          return const SizedBox(
            height: 32.0, width: 32.0, child: CircularProgressIndicator()
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
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text("Your Things",
                      style: Theme.of(context).textTheme.headline5,
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
                              store.things[i].name,
                              textAlign: TextAlign.center
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