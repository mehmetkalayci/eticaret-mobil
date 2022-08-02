import 'dart:convert';

class LoginResponseModel {
  LoginResponseModel({
    required this.token,
    required this.refreshToken,
    required this.expiresAt,
  });

  String token;
  String refreshToken;
  DateTime expiresAt;

  factory LoginResponseModel.fromRawJson(String str) => LoginResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) => LoginResponseModel(
    token: json["token"],
    refreshToken: json["refreshToken"],
    expiresAt: DateTime.parse(json["expiresAt"]),
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    "refreshToken": refreshToken,
    "expiresAt": expiresAt.toIso8601String(),
  };
}