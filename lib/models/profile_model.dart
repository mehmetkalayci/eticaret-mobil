
import 'dart:convert';

ProfileModel profileModelFromJson(String str) => ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
  ProfileModel({
    required this.userId,
    required this.fullName,
    required this.businessName,
    required this.phone,
    required this.address,
    required this.role,
  });

  int userId;
  String fullName;
  String businessName;
  String phone;
  dynamic address;
  String role;

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
    userId: json["userId"],
    fullName: json["fullName"],
    businessName: json["businessName"],
    phone: json["phone"],
    address: json["address"],
    role: json["role"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "fullName": fullName,
    "businessName": businessName,
    "phone": phone,
    "address": address,
    "role": role,
  };
}
