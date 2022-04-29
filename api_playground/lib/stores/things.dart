import 'dart:convert';
import 'dart:developer'; // ignore: unused_import

import 'package:http/http.dart' as http;
import 'package:mobx/mobx.dart';

import 'package:api_playground/globals.dart';
import 'package:api_playground/models.dart';
import 'package:api_playground/state.dart';

// mobx
part 'things.g.dart';

class ThingsStore = _ThingsStore with _$ThingsStore;

abstract class _ThingsStore with Store {
  // list
  _ThingsStore() {
    thingsFetch();
  }

  @observable
  ObservableList<Thing> things = ObservableList<Thing>.of([]);

  @observable
  bool initialFetchCompleted = false;

  @observable
  bool isLoading = true;

  @action
  Future<void> thingsFetch() async {
    final url = Uri.parse(Globals().urls.thingList);

    final Map<String, String> headers = {
      'Authorization': "Token ${await secureStorage.read('user_api_token')}",
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    final response = await http.get(url, headers: headers);
    initialFetchCompleted = true;

    final List<dynamic> decodedData = jsonDecode(response.body);

    final result = decodedData.map((decodedJson) =>
      Thing.fromJson(decodedJson)).toList();

    things = ObservableList<Thing>.of(result);
  }

  @action
  void refreshThingList() {
    things = ObservableList<Thing>.of(things);
  }

  @action
  Future<void> thingCreate(String name) async {
    final url = Uri.parse(globals.urls.thingList);

    final Map<String, String> headers = {
      'Authorization': "Token ${await secureStorage.read('user_api_token')}",
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    final Object body = {'name': name};

    final response =
      await http.post(url, headers: headers, body: jsonEncode(body));
    final Map<String, dynamic> decodedJson = jsonDecode(response.body);

    if (response.statusCode == 201) {
      final Thing newThing = Thing.fromJson(decodedJson);
      things.insert(0, newThing);
    } else {
      // throw the first exception message we can find
      for (var key in decodedJson.keys) {
        throw Exception(decodedJson[key][0]);
      }
    }
  }

  @action
  Future<void> thingUpdate(int thingId, String name) async {
    final url = Uri.parse(globals.urls.thingDetail(thingId));

    final Map<String, String> headers = {
      'Authorization': "Token ${await secureStorage.read('user_api_token')}",
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    final Object body = {'id': thingId, 'name': name};

    final response =
    await http.put(url, headers: headers, body: jsonEncode(body));
    final Map<String, dynamic> decodedJson = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final Thing updatedThing = things.firstWhere((t) => t.id == thingId);
      updatedThing.name = name;
    } else {
      // throw the first exception message we can find
      for (var key in decodedJson.keys) {
        throw Exception(decodedJson[key][0]);
      }
    }
  }

  @action
  Future<void> thingDelete(int thingId) async {
    final url = Uri.parse(globals.urls.thingDetail(thingId));

    final Map<String, String> headers = {
      'Authorization': "Token ${await secureStorage.read('user_api_token')}",
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    final response = await http.delete(url, headers: headers);

    if (response.statusCode == 204) {
      final Thing thingToDelete = things.firstWhere((t) => t.id == thingId);
      things.remove(thingToDelete);
    } else {
      throw Exception(response.reasonPhrase);
    }
  }
}