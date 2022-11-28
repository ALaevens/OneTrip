import 'dart:convert';

import 'package:one_trip/api/auth.dart';
import 'package:one_trip/api/consts.dart';
import 'package:one_trip/api/models/homegroup.dart';
import 'package:one_trip/api/models/recipeingredient.dart';
import 'package:http/http.dart' as http;

class Recipe {
  int id;
  int homegroup;
  String name;
  List<RecipeIngredient> ingredients;

  Recipe(
      {required this.id,
      required this.name,
      required this.ingredients,
      required this.homegroup});

  factory Recipe.fromJson(Map<String, dynamic> json) {
    List<RecipeIngredient> ingredients = [];
    for (dynamic ingredient in json["ingredients"]) {
      ingredients.add(RecipeIngredient.fromJson(ingredient));
    }
    return Recipe(
        id: json["id"] as int,
        homegroup: json["homegroup"] as int,
        name: json["name"] as String,
        ingredients: ingredients);
  }

  static Future<Recipe?> get(int id) async {
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

  static Future<List<Recipe>> getList(int groupID) async {
    Homegroup? group = await Homegroup.get(groupID);
    if (group == null) {
      return [];
    }

    List<Recipe> recipes = [];
    for (int recipeID in group.recipes) {
      Recipe? recipe = await Recipe.get(recipeID);
      if (recipe != null) {
        // TODO: implement sorted insert
        recipes.add(recipe);
      }
    }

    recipes.sort(((a, b) => a.name.compareTo(b.name)));

    return recipes;
  }

  static Future<Recipe?> create(String name, int group) async {
    String requestURL = "$baseURL/api/recipes/";
    String token = TokenSingleton().getToken();
    final http.Response response = await http.post(
      Uri.parse(requestURL),
      headers: {"Authorization": "Token $token"},
      body: {"homegroup": "$group", "name": name},
    );

    if (response.statusCode == 201) {
      return Recipe.fromJson(jsonDecode(response.body));
    }

    return null;
  }

  Future<bool> delete() async {
    String requestURL = "$baseURL/api/recipes/$id/";
    String token = TokenSingleton().getToken();
    final http.Response response = await http.delete(
      Uri.parse(requestURL),
      headers: {"Authorization": "Token $token"},
    );

    if (response.statusCode == 204) {
      return true;
    }

    return false;
  }
}
