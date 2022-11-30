import 'dart:convert';

import 'package:one_trip/api/auth.dart';
import 'package:one_trip/api/consts.dart';
import 'package:http/http.dart' as http;
import 'dart:io' show File;

class User {
  int id;
  String username;
  String firstName;
  String lastName;
  List<int> homegroupInvites;
  int? homegroup;
  String? imageUrl;

  User({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.homegroupInvites,
    this.homegroup,
    this.imageUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    List<dynamic> invitesDynamic = json["homegroup_invites"];
    List<int> invites = invitesDynamic.map((e) => e as int).toList();

    String? imagePath = json["image"] as String?;
    String? imageUrl = imagePath != null ? "$baseURL/media/$imagePath" : null;

    return User(
      id: json["id"] as int,
      username: json["username"] as String,
      firstName: json["first_name"] as String,
      lastName: json["last_name"] as String,
      homegroup: json["homegroup"] as int?,
      imageUrl: imageUrl,
      homegroupInvites: invites,
    );
  }

  static Future<User?> getMe() async {
    String requestURL = "$baseURL/auth/users/me";

    String token = TokenSingleton().getToken();
    final http.Response response =
        await http.get(Uri.parse(requestURL), headers: {
      "Authorization": "Token $token",
    });

    if (response.statusCode == 200) {
      User u = User.fromJson(jsonDecode(response.body));
      return u;
    } else {
      return null;
    }
  }

  Future<User?> patchMe({
    String? firstName,
    String? lastName,
    int? homegroup,
  }) async {
    String requestURL = "$baseURL/auth/users/me";

    Map<String, String> body = {};
    if (firstName != null) {
      body["first_name"] = firstName;
    }

    if (lastName != null) {
      body["last_name"] = lastName;
    }

    if (homegroup != null) {
      body["homegroup"] = "$homegroup";
    }

    String token = TokenSingleton().getToken();
    final http.Response response = await http.patch(
      Uri.parse(requestURL),
      headers: {
        "Authorization": "Token $token",
      },
      body: body,
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    }

    return null;
  }

  Future<User?> uploadImage(File file) async {
    String requestURL = "$baseURL/auth/users/me";
    String token = TokenSingleton().getToken();

    http.MultipartRequest request =
        http.MultipartRequest("PATCH", Uri.parse(requestURL));

    request.headers.addAll({"Authorization": "Token $token"});
    request.files.add(http.MultipartFile.fromBytes(
        "image", file.readAsBytesSync(),
        filename: file.path));

    var multiresponse = await request.send();
    http.Response response = await http.Response.fromStream(multiresponse);
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    }

    return null;
  }
}
