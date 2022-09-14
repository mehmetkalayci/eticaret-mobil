// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';

import 'package:ecommerce_mobile/models/category_model.dart';

class ProductModel {
  ProductModel({
    required this.productId,
    required this.categoryId,
    required this.productName,
    required this.details,
    required this.totalStockAmount,
    required this.sellingPrice,
    required this.discountedPrice,
    required this.isDiscounted,
    required this.productAttibutes,
    required this.productImages,
  });

  int productId;
  int? categoryId;
  String productName;
  String details;
  int? totalStockAmount;
  double sellingPrice;
  double discountedPrice;
  bool isDiscounted;
  List<ProductAttibute> productAttibutes;
  List<ProductImage> productImages;

  factory ProductModel.fromRawJson(String str) =>
      ProductModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        productId: json["productId"],
        categoryId: json["categoryId"],
        productName: json["productName"],
        details: json["details"],
        totalStockAmount: json["totalStockAmount"],
        sellingPrice: json["sellingPrice"],
        discountedPrice: json["discountedPrice"],
        isDiscounted: json["isDiscounted"],




        productAttibutes: List<ProductAttibute>.from(
            json["productAttibutes"].map((x) => ProductAttibute.fromJson(x))),
        productImages: List<ProductImage>.from(
            json["productImages"].map((x) => ProductImage.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "productId": productId,
        "categoryId": categoryId,
        "productName": productName,
        "details": details,
        "totalStockAmount": totalStockAmount,
        "sellingPrice": sellingPrice,
        "discountedPrice": discountedPrice,
        "isDiscounted": isDiscounted,
        "productAttibutes":
            List<dynamic>.from(productAttibutes.map((x) => x.toJson())),
        "productImages":
            List<dynamic>.from(productImages.map((x) => x.toJson())),
      };
}

class ProductAttibute {
  ProductAttibute({
    required this.attibuteId,
    required this.productId,
    required this.name,
    required this.value,
    this.type,
    this.product,
  });

  int attibuteId;
  int productId;
  String name;
  String value;
  dynamic type;
  dynamic product;

  factory ProductAttibute.fromRawJson(String str) =>
      ProductAttibute.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProductAttibute.fromJson(Map<String, dynamic> json) =>
      ProductAttibute(
        attibuteId: json["attibuteId"],
        productId: json["productId"],
        name: json["name"],
        value: json["value"],
        type: json["type"],
        product: json["product"],
      );

  Map<String, dynamic> toJson() => {
        "attibuteId": attibuteId,
        "productId": productId,
        "name": name,
        "value": value,
        "type": type,
        "product": product,
      };
}

class ProductImage {
  ProductImage({
    required this.imageId,
    required this.productId,
    required this.src,
    this.thumbSrc,
    this.details,
    this.product,
  });

  int imageId;
  int productId;
  String src;
  dynamic thumbSrc;
  dynamic details;
  dynamic product;

  factory ProductImage.fromRawJson(String str) =>
      ProductImage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProductImage.fromJson(Map<String, dynamic> json) => ProductImage(
        imageId: json["imageId"],
        productId: json["productId"],
        src: json["src"],
        thumbSrc: json["thumbSrc"] ?? "",
        details: json["details"],
        product: json["product"],
      );

  Map<String, dynamic> toJson() => {
        "imageId": imageId,
        "productId": productId,
        "src": src,
        "thumbSrc": thumbSrc,
        "details": details,
        "product": product,
      };
}
