import 'dart:convert';
import 'package:grocery_helper/api/auth.dart';
import 'package:grocery_helper/api/consts.dart';
import 'package:http/http.dart' as http;

class Homegroup {
  int id;
  String name;
  List<int> recipes;
  List<int> users;
  List<int> inviteIDs;

  Homegroup({
    required this.id,
    required this.name,
    required this.recipes,
    required this.users,
    required this.inviteIDs,
  });

  factory Homegroup.fromJson(Map<String, dynamic> json) {
    List<int> recipes =
        (json["recipes"] as List<dynamic>).map(((e) => e as int)).toList();
    List<int> users =
        (json["users"] as List<dynamic>).map(((e) => e as int)).toList();
    List<int> inviteIDs =
        (json["invites"] as List<dynamic>).map(((e) => e as int)).toList();

    return Homegroup(
      id: json["id"] as int,
      name: json["name"] as String,
      recipes: recipes,
      users: users,
      inviteIDs: inviteIDs,
    );
  }

  static Future<Homegroup?> fetchHomegroup(int id) async {
    String requestURL = "$baseURL/api/homegroups/$id/";

    String token = TokenSingleton().getToken();
    final http.Response response = await http.get(
      Uri.parse(requestURL),
      headers: {"Authorization": "Token $token"},
    );

    if (response.statusCode == 200) {
      Homegroup hg = Homegroup.fromJson(jsonDecode(response.body));
      return hg;
    } else {
      return null;
    }
  }

  static Future<Homegroup?> createHomegroup(String title) async {
    String requestURL = "$baseURL/api/homegroups/";

    String token = TokenSingleton().getToken();
    final http.Response response = await http.post(
      Uri.parse(requestURL),
      headers: {"Authorization": "Token $token"},
      body: {"name": title},
    );

    if (response.statusCode == 201) {
      Homegroup hg = Homegroup.fromJson(jsonDecode(response.body));
      return hg;
    }

    return null;
  }
}
