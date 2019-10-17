import 'dart:async';
import 'dart:convert';
import 'package:bay_al_quran/app/routing/Routes.dart';
import 'package:http/http.dart' as http;

class Router {
  static Map<String, String> _globalParameter = {'formatType': 'json'};

  static void addGlobalParameter(String key, value) {
    _globalParameter[key] = value;
  }

  static void addGlobalParameters(Map<String, String> params) {
    params.forEach((key, value) {
      _globalParameter[key] = value;
    });
  }

  static const JsonDecoder decoder = const JsonDecoder();
  static dynamic decodeFromJson(String input) => decoder.convert(input);

  String _url = '';
  Map<String, String> _parameters;
  Map<String, String> _headers;

  static const String baseUrl = 'https://api.banghasan.com';

  String get url => _buildUrl();

  Router(String name) {
    _url = Routes.getUrl(name);
    _parameters = {};
    _headers = {};
  }

  Router withParam(String key, value) {
    _parameters[key] = value;
    return this;
  }

  Router withParams(Map<String, String> params) {
    params.forEach((key, value) {
      _parameters[key] = value;
    });
    return this;
  }

  String _buildUrl() {
    var url = _url;
    _parameters.addEntries(_globalParameter.entries);
    if (_parameters.isNotEmpty) {
      _parameters.forEach((key, value) {
        key = ':$key';
        url = url.replaceAll(key, value);
      });
    }
    return '$baseUrl/$url';
  }

  Future<dynamic> get() {
    return http
        .get(url, headers: _headers)
        .then(_handleResponse)
        .catchError(_handleError);
  }

  FutureOr _handleResponse(http.Response response) {
    if (response.statusCode == 200) return decodeFromJson(response.body);
    throw Error();
  }

  FutureOr _handleError(e) {
    throw e;
  }
}
