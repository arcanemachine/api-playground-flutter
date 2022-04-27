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
  static const String _domainName = "http://192.168.1.100:8010";

  static const String _apiRoot = "$_domainName/api";
  String get apiRoot { return _apiRoot; }

  static const String _baseUrl = "http://$_domainName";

  // auth
  static const String _authBaseUrl = "$_baseUrl/auth";
  String get login { return "$_authBaseUrl/login/"; }

  // things
  static const String _thingsBaseUrl = "$_apiRoot/things";
  String get thingList { return "$_thingsBaseUrl/"; }
}