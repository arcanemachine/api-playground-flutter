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