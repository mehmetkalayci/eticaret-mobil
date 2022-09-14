
import 'dart:convert';

class SearchResultModel {
  SearchResultModel({
    required this.productId,
    required this.productName,
    required this.details,
    required this.totalStockAmount,
    required this.sellingPrice,
    required this.discountedPrice,
    required this.name,
  });

  int productId;
  String productName;
  String details;
  int? totalStockAmount;
  double sellingPrice;
  double discountedPrice;
  String? name;

  factory SearchResultModel.fromRawJson(String str) => SearchResultModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SearchResultModel.fromJson(Map<String, dynamic> json) => SearchResultModel(
    productId: json["productId"],
    productName: json["productName"],
    details: json["details"],
    totalStockAmount: json["totalStockAmount"],
    sellingPrice: json["sellingPrice"],
    discountedPrice: json["discountedPrice"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "productId": productId,
    "productName": productName,
    "details": details,
    "totalStockAmount": totalStockAmount,
    "sellingPrice": sellingPrice,
    "discountedPrice": discountedPrice,
    "name": name,
  };
}