import 'package:grocery_helper/api/auth.dart';
import 'package:grocery_helper/api/consts.dart';
import 'package:http/http.dart' as http;

class Ingredient {
  int id;
  String name;
  bool inStock;
  int contentType;
  int objectID;

  Ingredient({
    required this.id,
    required this.name,
    required this.inStock,
    required this.contentType,
    required this.objectID,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
        id: json["id"] as int,
        name: json["name"] as String,
        inStock: json["in_stock"] as bool,
        contentType: json["content_type"] as int,
        objectID: json["object_id"] as int);
  }
}
