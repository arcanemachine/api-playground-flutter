import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:api_playground/globals.dart';
import 'package:api_playground/state.dart';


class Thing {
  Thing({ required this.id,
          required this.name, });

  int id;
  String name;

  factory Thing.fromJson(Map<String, dynamic> json) => Thing(
    id: json['id'],
    name: json['name'],
  );
}

class ThingsService {
  Future<List<Thing>> thingsGet() async {
    final url = Uri.parse(Globals().urls.thingList);

    final Map<String, String> headers = {
      'Authorization': "Token ${await secureStorage.read('user_api_token')}",
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    final response = await http.get(url, headers: headers);

    final List<dynamic> decodedData = jsonDecode(response.body);

    return decodedData.map((decodedJson) =>
      Thing.fromJson(decodedJson)).toList();
  }

  Future<List<Thing>> thingCreate(String name) async {
    // print("thingCreate(); name: $name");
    final url = Uri.parse(Globals().urls.thingList);

    final Map<String, String> headers = {
      'Authorization': "Token ${await secureStorage.read('user_api_token')}",
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    final Object body = {'name': name};

    // debugger();

    final response =
      await http.post(url, headers: headers, body: jsonEncode(body));

    final List<dynamic> decodedData = jsonDecode(response.body);

    return decodedData.map((decodedJson) =>
      Thing.fromJson(decodedJson)).toList();
  }
}