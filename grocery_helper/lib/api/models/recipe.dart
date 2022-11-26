import 'dart:convert';

import 'package:grocery_helper/api/auth.dart';
import 'package:grocery_helper/api/consts.dart';
import 'package:grocery_helper/api/models/homegroup.dart';
import 'package:grocery_helper/api/models/ingredient.dart';
import 'package:http/http.dart' as http;

class Recipe {
  int id;
  String name;
  List<Ingredient> ingredients;

  Recipe({required this.id, required this.name, required this.ingredients});

  factory Recipe.fromJson(Map<String, dynamic> json) {
    List<Ingredient> ingredients = [];
    for (dynamic ingredient in json["ingredients"]) {
      ingredients.add(Ingredient.fromJson(ingredient));
    }
    return Recipe(
        id: json["id"] as int,
        name: json["name"] as String,
        ingredients: ingredients);
  }

  static Future<Recipe?> fetch(int id) async {
    String requestURL = "$baseURL/api/recipes/$id/";

    String token = TokenSingleton().getToken();
    final http.Response response = await http.get(
      Uri.parse(requestURL),
      headers: {"Authorization": "Token $token"},
    );

    if (response.statusCode == 200) {
      return Recipe.fromJson(jsonDecode(response.body));
    }

    return null;
  }

  static Future<List<Recipe>> fetchList(int groupID) async {
    Homegroup? group = await Homegroup.fetchHomegroup(groupID);
    if (group == null) {
      return [];
    }

    List<Recipe> recipes = [];
    for (int recipeID in group.recipes) {
      Recipe? recipe = await Recipe.fetch(recipeID);
      if (recipe != null) {
        recipes.add(recipe);
      }
    }

    return recipes;
  }
}
