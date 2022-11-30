import 'dart:convert';

import 'package:one_trip/api/auth.dart';
import 'package:one_trip/api/consts.dart';
import 'package:one_trip/api/models/recipeingredient.dart';
import 'package:http/http.dart' as http;
import 'package:one_trip/api/searchresult.dart';

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

  static Future<List<Recipe>> getList() async {
    const String requestURL = "$baseURL/api/recipes/";

    String token = TokenSingleton().getToken();
    http.Response response = await http.get(
      Uri.parse(requestURL),
      headers: {"Authorization": "Token $token"},
    );

    List<Recipe> recipes = [];
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      for (var recipe in body) {
        recipes.add(Recipe.fromJson(recipe));
      }
    }

    return recipes;
  }

  static Future<SearchResult<Recipe>> search(String query, int page) async {
    String requestURL = "$baseURL/api/searchrecipes/?page=$page&search=$query";
    requestURL = requestURL.replaceAll(RegExp(r"\s+"), "+");

    String token = TokenSingleton().getToken();
    final http.Response response = await http.get(
      Uri.parse(requestURL),
      headers: {"Authorization": "Token $token"},
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      List<Recipe> recipes = [];
      for (var recipeObject in json["results"]) {
        Recipe r = Recipe.fromJson(recipeObject);
        recipes.add(r);
      }

      return SearchResult<Recipe>(
          results: recipes, next: json["next"] as String?);
    }

    return SearchResult<Recipe>(results: [], next: null);
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
