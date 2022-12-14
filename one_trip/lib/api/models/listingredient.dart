import 'dart:convert';

import 'package:one_trip/api/auth.dart';
import 'package:one_trip/api/consts.dart';
import 'package:http/http.dart' as http;

class ListIngredient {
  int id;
  String name;
  String? quantity;
  int list;
  bool inCart;

  ListIngredient({
    required this.id,
    required this.name,
    required this.quantity,
    required this.list,
    required this.inCart,
  });

  factory ListIngredient.fromJson(Map<String, dynamic> json) {
    return ListIngredient(
      id: json["id"] as int,
      name: json["name"] as String,
      quantity: json["quantity"] as String?,
      list: json["list"] as int,
      inCart: json["in_cart"] as bool,
    );
  }

  static Future<ListIngredient?> create(
      int list, String name, String? quantity) async {
    const String requestURL = "$baseURL/api/listingredients/";
    String token = TokenSingleton().getToken();

    Map<String, dynamic> body = {
      "name": name,
      "list": list,
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
      return ListIngredient.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }

  Future<ListIngredient?> patch(
      {String? name, String? quantity, bool? inCart}) async {
    String requestURL = "$baseURL/api/listingredients/$id/";
    String token = TokenSingleton().getToken();

    Map<String, dynamic> body = {"quantity": quantity ?? this.quantity};

    if (name != null) {
      body["name"] = name;
    }

    if (inCart != null) {
      body["in_cart"] = inCart;
    }

    http.Response response = await http.patch(Uri.parse(requestURL),
        headers: {
          "Authorization": "Token $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode(body));

    if (response.statusCode == 200) {
      return ListIngredient.fromJson(jsonDecode(response.body));
    }

    return null;
  }

  Future<bool> delete() async {
    String requestURL = "$baseURL/api/listingredients/$id/";
    String token = TokenSingleton().getToken();
    http.Response response = await http.delete(Uri.parse(requestURL),
        headers: {"Authorization": "Token $token"});

    if (response.statusCode == 204) {
      return true;
    }

    return false;
  }

  @override
  bool operator ==(Object other) =>
      other is ListIngredient &&
      other.id == id &&
      other.name == name &&
      other.quantity == quantity &&
      other.inCart == inCart;

  @override
  int get hashCode => Object.hash(id, name, quantity, inCart);
}
