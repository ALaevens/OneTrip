import 'dart:convert';
import 'package:one_trip/api/auth.dart';
import 'package:one_trip/api/consts.dart';
import 'package:http/http.dart' as http;

class HomegroupInvite {
  int id;
  int homegroupID;
  int userID;

  HomegroupInvite({
    required this.id,
    required this.homegroupID,
    required this.userID,
  });

  factory HomegroupInvite.fromJson(Map<String, dynamic> json) {
    return HomegroupInvite(
      id: json["id"] as int,
      homegroupID: json["homegroup"] as int,
      userID: json["user"] as int,
    );
  }

  static Future<HomegroupInvite?> get(int id) async {
    String requestURL = "$baseURL/api/groupinvites/$id/";
    String token = TokenSingleton().getToken();
    final http.Response response = await http.get(
      Uri.parse(requestURL),
      headers: {"Authorization": "Token $token"},
    );

    if (response.statusCode == 200) {
      return HomegroupInvite.fromJson(jsonDecode(response.body));
    }

    return null;
  }

  static Future<HomegroupInvite?> create(int homegroupID, int userID) async {
    String requestURL = "$baseURL/api/groupinvites/";
    String token = TokenSingleton().getToken();
    final http.Response response = await http.post(
      Uri.parse(requestURL),
      headers: {"Authorization": "Token $token"},
      body: {"homegroup": "$homegroupID", "user": "$userID"},
    );

    if (response.statusCode == 201) {
      return HomegroupInvite.fromJson(jsonDecode(response.body));
    }

    return null;
  }

  Future<bool> delete() async {
    String requestURL = "$baseURL/api/groupinvites/$id/";
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
