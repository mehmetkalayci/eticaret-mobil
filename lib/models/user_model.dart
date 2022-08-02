import 'dart:convert';

class UserModel {
  UserModel({
    required this.fullName,
    required this.businessName,
    required this.phone,
    required this.password,
    required this.address,
  });

  String fullName;
  String businessName;
  String phone;
  String password;
  String address;

  factory UserModel.fromRawJson(String str) => UserModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    fullName: json["fullName"],
    businessName: json["businessName"],
    phone: json["phone"],
    password: json["password"],
    address: json["address"],
  );

  Map<String, dynamic> toJson() => {
    "fullName": fullName,
    "businessName": businessName,
    "phone": phone,
    "password": password,
    "address": address,
  };
}