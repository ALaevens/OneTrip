import 'dart:convert';

import 'package:one_trip/api/auth.dart';
import 'package:one_trip/api/consts.dart';
import 'package:http/http.dart' as http;

class SearchResult {
  List<SimpleUser> users;
  String? next;

  SearchResult({required this.users, required this.next});
}

class SimpleUser {
  int id;
  String username;
  String firstName;
  String lastName;
  String? imageUrl;
  int? invite;

  SimpleUser({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    this.imageUrl,
  });

  factory SimpleUser.fromJson(Map<String, dynamic> json) {
    return SimpleUser(
      id: json["id"] as int,
      username: json["username"] as String,
      firstName: json["first_name"] as String,
      lastName: json["last_name"] as String,
      imageUrl: json["image"] as String?,
    );
  }

  static Future<SimpleUser?> get({int? id}) async {
    String requestURL = "$baseURL/auth/users/${id ?? 'me'}";

    String token = TokenSingleton().getToken();
    final http.Response response = await http.get(
      Uri.parse(requestURL),
      headers: {"Authorization": "Token $token"},
    );

    if (response.statusCode == 200) {
      SimpleUser u = SimpleUser.fromJson(jsonDecode(response.body));
      return u;
    } else {
      return null;
    }
  }

  static Future<SearchResult> search(String query, int page) async {
    // String requestURL = "";
    // if (url != null) {
    //   requestURL = url;
    // } else if (query != null) {
    //   requestURL = "$baseURL/auth/users/?search=$query";
    // } else {
    //   return SearchResult(users: [], next: null);
    // }

    String requestURL = "$baseURL/auth/users/?page=$page&search=$query";
    requestURL = requestURL.replaceAll(RegExp(r"\s+"), "+");

    String token = TokenSingleton().getToken();
    final http.Response response = await http.get(
      Uri.parse(requestURL),
      headers: {"Authorization": "Token $token"},
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      List<SimpleUser> users = [];
      for (var userObject in json["results"]) {
        SimpleUser u = SimpleUser.fromJson(userObject);
        users.add(u);
      }

      return SearchResult(users: users, next: json["next"] as String?);
    }

    return SearchResult(users: [], next: null);
  }
}
