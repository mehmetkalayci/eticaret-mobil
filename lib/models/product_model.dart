// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';

import 'package:ecommerce_mobile/models/homepage_model.dart';

class ProductModel {
  ProductModel({
    required this.productId,
    required this.categoryId,
    required this.productName,
    required this.details,
    required this.slug,
    required this.totalStockAmount,
    required this.sellingPrice,
    required this.discountedPrice,
    required this.category,
    required this.productAttibutes,
    required this.productImages,
  });

  int productId;
  int categoryId;
  String productName;
  String details;
  String slug;
  int totalStockAmount;
  double sellingPrice;
  double discountedPrice;
  CategoryModel category;
  List<ProductAttibuteModel> productAttibutes;
  List<ProductImageModel> productImages;

  factory ProductModel.fromRawJson(String str) => ProductModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    productId: json["productId"],
    categoryId: json["categoryId"],
    productName: json["productName"],
    details: json["details"],
    slug: json["slug"],
    totalStockAmount: json["totalStockAmount"],
    sellingPrice: json["sellingPrice"],
    discountedPrice: json["discountedPrice"],
    category: CategoryModel.fromJson(json["category"]),
    productAttibutes: List<ProductAttibuteModel>.from(json["productAttibutes"].map((x) => ProductAttibuteModel.fromJson(x))),
    productImages: List<ProductImageModel>.from(json["productImages"].map((x) => ProductImageModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "productId": productId,
    "categoryId": categoryId,
    "productName": productName,
    "details": details,
    "slug": slug,
    "totalStockAmount": totalStockAmount,
    "sellingPrice": sellingPrice,
    "discountedPrice": discountedPrice,
    "category": category.toJson(),
    "productAttibutes": List<dynamic>.from(productAttibutes.map((x) => x.toJson())),
    "productImages": List<dynamic>.from(productImages.map((x) => x.toJson())),
  };
}

class CategoryModel {
  CategoryModel({
    required this.categoryId,
    this.parentCategoryId,
    required this.name,
    required this.imageSrc,
    this.details,
    this.parentCategory,
    required this.inverseParentCategory,
    required this.products,
  });

  int categoryId;
  dynamic parentCategoryId;
  String name;
  String imageSrc;
  dynamic details;
  dynamic parentCategory;
  List<dynamic> inverseParentCategory;
  List<dynamic> products;

  factory CategoryModel.fromRawJson(String str) => CategoryModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    categoryId: json["categoryId"],
    parentCategoryId: json["parentCategoryId"],
    name: json["name"],
    imageSrc: json["imageSrc"],
    details: json["details"],
    parentCategory: json["parentCategory"],
    inverseParentCategory: List<dynamic>.from(json["inverseParentCategory"].map((x) => x)),
    products: List<dynamic>.from(json["products"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "categoryId": categoryId,
    "parentCategoryId": parentCategoryId,
    "name": name,
    "imageSrc": imageSrc,
    "details": details,
    "parentCategory": parentCategory,
    "inverseParentCategory": List<dynamic>.from(inverseParentCategory.map((x) => x)),
    "products": List<dynamic>.from(products.map((x) => x)),
  };
}

class ProductAttibuteModel {
  ProductAttibuteModel({
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

  factory ProductAttibuteModel.fromRawJson(String str) => ProductAttibuteModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProductAttibuteModel.fromJson(Map<String, dynamic> json) => ProductAttibuteModel(
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

class ProductImageModel {
  ProductImageModel({
    required this.imageId,
    required this.productId,
    required this.src,
    this.thumbSrc,
    required this.displayOrder,
    this.details,
    this.product,
  });

  int imageId;
  int productId;
  String src;
  dynamic thumbSrc;
  int? displayOrder;
  dynamic details;
  dynamic product;

  factory ProductImageModel.fromRawJson(String str) => ProductImageModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProductImageModel.fromJson(Map<String, dynamic> json) => ProductImageModel(
    imageId: json["imageId"],
    productId: json["productId"],
    src: json["src"],
    thumbSrc: json["thumbSrc"],
    displayOrder: json["displayOrder"],
    details: json["details"],
    product: json["product"],
  );

  Map<String, dynamic> toJson() => {
    "imageId": imageId,
    "productId": productId,
    "src": src,
    "thumbSrc": thumbSrc,
    "displayOrder": displayOrder,
    "details": details,
    "product": product,
  };
}
