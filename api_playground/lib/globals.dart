// globals
class Globals {
  init() {}

  _Urls get urls {
    return _Urls();
  }
}
final globals = Globals();

// global URLs
class _Urls {
  // base
  static const String _baseUrl = "http://192.168.1.100:8010/api";

  // auth
  static const String _authBaseUrl = "$_baseUrl/auth";
  String get login { return "$_authBaseUrl/login/"; }

  // things
  static const String _thingsBaseUrl = "$_baseUrl/things";
  String get thingList { return "$_thingsBaseUrl/"; }
  String thingDetail(int thingId) { return "$_thingsBaseUrl/$thingId/"; }
}