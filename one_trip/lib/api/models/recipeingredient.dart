import 'dart:convert';

import 'package:one_trip/api/auth.dart';
import 'package:one_trip/api/consts.dart';
import 'package:http/http.dart' as http;

class RecipeIngredient {
  int id;
  String name;
  int recipe;

  RecipeIngredient({
    required this.id,
    required this.name,
    required this.recipe,
  });

  factory RecipeIngredient.fromJson(Map<String, dynamic> json) {
    return RecipeIngredient(
      id: json["id"] as int,
      name: json["name"] as String,
      recipe: json["recipe"] as int,
    );
  }

  static Future<RecipeIngredient?> create(String name, int recipeID) async {
    const String requestURL = "$baseURL/api/recipeingredients/";
    String token = TokenSingleton().getToken();
    http.Response response = await http.post(
      Uri.parse(requestURL),
      headers: {"Authorization": "Token $token"},
      body: {
        "name": name,
        "recipe": "$recipeID",
      },
    );

    if (response.statusCode == 201) {
      return RecipeIngredient.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }

  Future<RecipeIngredient?> patch(String name) async {
    String requestURL = "$baseURL/api/recipeingredients/$id/";
    String token = TokenSingleton().getToken();

    http.Response response = await http.patch(Uri.parse(requestURL),
        headers: {"Authorization": "Token $token"}, body: {"name": name});

    if (response.statusCode == 200) {
      return RecipeIngredient.fromJson(jsonDecode(response.body));
    }

    return null;
  }

  Future<bool> delete() async {
    String requestURL = "$baseURL/api/recipeingredients/$id/";
    String token = TokenSingleton().getToken();
    http.Response response = await http.delete(Uri.parse(requestURL),
        headers: {"Authorization": "Token $token"});

    if (response.statusCode == 204) {
      return true;
    }

    return false;
  }
}
