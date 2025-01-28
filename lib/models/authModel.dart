// To parse this JSON data, do
//
//     final authModel = authModelFromJson(jsonString);

import 'dart:convert';

AuthModel authModelFromJson(String str) => AuthModel.fromJson(json.decode(str));

String authModelToJson(AuthModel data) => json.encode(data.toJson());

class AuthModel {
  String? type;
  String? token;

  AuthModel({
    this.type,
    this.token,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) => AuthModel(
    type: json["type"],
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "token": token,
  };
}
