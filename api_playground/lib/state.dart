import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
  init() async {}
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

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