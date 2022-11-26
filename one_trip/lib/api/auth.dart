import 'dart:convert';

import 'consts.dart';
import 'package:http/http.dart' as http;

class TokenSingleton {
  static final TokenSingleton _instance = TokenSingleton._internal();
  String token = "";

  factory TokenSingleton() {
    return _instance;
  }

  void setToken(String tok) {
    token = tok;
  }

  String getToken() {
    return token;
  }

  TokenSingleton._internal();
}

Future<String> getToken(String username, String password) async {
  const String requestURL = "$baseURL/auth/token";

  final http.Response response = await http.post(Uri.parse(requestURL),
      body: {"username": username, "password": password});

  if (response.statusCode == 200) {
    Map<String, dynamic> json = jsonDecode(response.body);

    final TokenSingleton s = TokenSingleton();
    s.setToken(json["token"]);

    return json["token"];
  } else {
    return "";
  }
}

Future<bool> testToken(String token) async {
  const String requestURL = "$baseURL/auth/users/me";

  final http.Response response = await http.get(
    Uri.parse(requestURL),
    headers: {
      "Authorization": "Token $token",
    },
  );

  return response.statusCode == 200;
}

Future<String> signup(
  String firstName,
  String lastName,
  String username,
  String password,
) async {
  const String requestURL = "$baseURL/auth/users/";

  final http.Response response = await http.post(
    Uri.parse(requestURL),
    body: {
      "first_name": firstName,
      "last_name": lastName,
      "username": username,
      "password": password,
    },
  );

  if (response.statusCode == 201) {
    return "";
  }

  Map<String, dynamic> errorBody = jsonDecode(response.body);

  List<String> errors = [];
  errorBody.forEach((key, value) {
    errors.add("$key: ${value[0]}");
  });

  return errors.join(", ");
}
