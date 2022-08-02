import 'dart:convert';

class CartModel {
  CartModel({
    required this.productId,
    required this.productName,
    required this.sellingPrice,
    required this.discountedPrice,
    required this.pcs,
    required this.isDiscounted,
    required this.thumbSrc,
  });

  int productId;
  String productName;
  double sellingPrice;
  double discountedPrice;
  int pcs;
  bool isDiscounted;
  String thumbSrc;

  factory CartModel.fromRawJson(String str) => CartModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
    productId: json["productId"],
    productName: json["productName"],
    sellingPrice: json["sellingPrice"],
    discountedPrice: json["discountedPrice"],
    pcs: json["pcs"],
    isDiscounted: json["isDiscounted"],
    thumbSrc: json["thumbSrc"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "productId": productId,
    "productName": productName,
    "sellingPrice": sellingPrice,
    "discountedPrice": discountedPrice,
    "pcs": pcs,
    "isDiscounted": isDiscounted,
    "thumbSrc": thumbSrc,
  };
}