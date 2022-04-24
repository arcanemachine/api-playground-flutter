import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// misc. app state
class AppState extends ChangeNotifier {
}

// globals
class Globals extends ChangeNotifier {
  _Urls get urls {
    return _Urls();
  }
}

// global URLs
class _Urls {
  // base
  static const String _baseUrl = "http://192.168.1.100:8010/api";

  // auth
  static const String _authBaseUrl = "$_baseUrl/auth";
  String get login {
    return "$_authBaseUrl/login/";
  }
}


// shared preferences
class SharedPrefs {
  static SharedPreferences? _sharedPrefs;

  init() async {
    _sharedPrefs ??= await SharedPreferences.getInstance();
  }

  // isLoggedIn
  bool get isLoggedIn => _sharedPrefs?.getBool('is_logged_in') ?? false;
  set isLoggedIn(bool val) {
    _sharedPrefs?.setBool('is_logged_in', val);
  }

}
final sharedPrefs = SharedPrefs();


// secure storage
class SecureStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  init() async {}  // left empty to allow for initialization in main()

  Future write(String key, String val) async {
    var writeData = await _storage.write(key: key, value: val);
    return writeData;
  }

  Future read(String key) async {
    var readData = await _storage.read(key: key);
    return readData;
  }

  Future delete(String key) async {
    var deleteData = await _storage.delete(key: key);
    return deleteData;
  }
}

final secureStorage = SecureStorage();