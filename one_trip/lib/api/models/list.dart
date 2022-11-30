import 'dart:convert';

import 'package:one_trip/api/auth.dart';
import 'package:one_trip/api/consts.dart';
import 'package:one_trip/api/models/listingredient.dart';
import 'package:http/http.dart' as http;
import 'package:one_trip/api/models/recipe.dart';
import 'package:one_trip/api/models/recipeingredient.dart';

class ShoppingList {
  List<ListIngredient> ingredients;
  int updates;
  int homegroup;

  ShoppingList({
    required this.ingredients,
    required this.updates,
    required this.homegroup,
  });

  factory ShoppingList.fromJson(Map<String, dynamic> json) {
    List<ListIngredient> ingredients = [];
    for (dynamic ingredient in json["ingredients"]) {
      ingredients.add(ListIngredient.fromJson(ingredient));
    }

    return ShoppingList(
        ingredients: ingredients,
        updates: json["updates"] as int,
        homegroup: json["homegroup"] as int);
  }

  static Future<ShoppingList?> get(int id) async {
    String requestURL = "$baseURL/api/lists/$id/";
    String token = TokenSingleton().getToken();
    http.Response response = await http.get(
      Uri.parse(requestURL),
      headers: {"Authorization": "Token $token"},
    );

    if (response.statusCode == 200) {
      return ShoppingList.fromJson(jsonDecode(response.body));
    }

    return null;
  }

  Future<ShoppingList?> patch({int? updates}) async {
    Map<String, String> body = {};
    if (updates != null) {
      body["updates"] = "$updates";
    }

    String requestURL = "$baseURL/api/lists/$homegroup/";
    String token = TokenSingleton().getToken();
    http.Response response = await http.patch(Uri.parse(requestURL),
        headers: {"Authorization": "Token $token"}, body: body);

    if (response.statusCode == 200) {
      return ShoppingList.fromJson(jsonDecode(response.body));
    }

    return null;
  }

  Future<ShoppingList?> addRecipe(int recipeID) async {
    Recipe? recipe = await Recipe.get(recipeID);

    if (recipe == null) {
      return null;
    }

    bool anySuccesses = false;
    for (RecipeIngredient ingredient in recipe.ingredients) {
      ListIngredient? newIngredient =
          await ListIngredient.create(ingredient.name, homegroup);

      if (newIngredient != null) {
        anySuccesses = true;
      }
    }

    if (anySuccesses) {
      return patch(updates: updates + 1);
    }

    return null;
  }

  Future<ShoppingList?> clear() async {
    bool anySuccess = false;
    for (ListIngredient ingredient in ingredients) {
      bool success = await ingredient.delete();

      if (success) {
        anySuccess = true;
      }
    }

    if (anySuccess) {
      return patch(updates: updates + 1);
    }

    return null;
  }

  @override
  bool operator ==(Object other) =>
      other is ShoppingList &&
      other.homegroup == homegroup &&
      other.ingredients == ingredients;

  @override
  int get hashCode => Object.hashAll(ingredients);
}
