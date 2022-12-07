import 'dart:convert';

import 'package:one_trip/api/auth.dart';
import 'package:one_trip/api/consts.dart';
import 'package:http/http.dart' as http;

class RecipeIngredient {
  int id;
  String name;
  String? quantity;
  int recipe;

  RecipeIngredient({
    required this.id,
    required this.name,
    required this.quantity,
    required this.recipe,
  });

  factory RecipeIngredient.fromJson(Map<String, dynamic> json) {
    return RecipeIngredient(
      id: json["id"] as int,
      name: json["name"] as String,
      quantity: json["quantity"] as String?,
      recipe: json["recipe"] as int,
    );
  }

  static Future<RecipeIngredient?> create(
      int recipeID, String name, String? quantity) async {
    const String requestURL = "$baseURL/api/recipeingredients/";
    String token = TokenSingleton().getToken();

    Map<String, dynamic> body = {
      "name": name,
      "recipe": recipeID,
    };

    if (quantity != null) {
      body["quantity"] = quantity;
    }

    http.Response response = await http.post(
      Uri.parse(requestURL),
      headers: {
        "Authorization": "Token $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      return RecipeIngredient.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }

  Future<RecipeIngredient?> patch({String? name, String? quantity}) async {
    Map<String, dynamic> body = {"quantity": quantity};

    if (name != null) {
      body["name"] = name;
    }

    String requestURL = "$baseURL/api/recipeingredients/$id/";
    String token = TokenSingleton().getToken();

    http.Response response = await http.patch(Uri.parse(requestURL),
        headers: {
          "Authorization": "Token $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode(body));

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
