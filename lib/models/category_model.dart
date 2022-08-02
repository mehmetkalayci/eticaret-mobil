import 'dart:convert';

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
    imageSrc: json["imageSrc"] == null ? "" : json["imageSrc"],
    //imageSrc: json["imageSrc"] ?? "",
    details: json["details"],
    parentCategory: json["parentCategory"],
    inverseParentCategory: List<dynamic>.from(json["inverseParentCategory"].map((x) => x)),
    products: List<dynamic>.from(json["products"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "categoryId": categoryId,
    "parentCategoryId": parentCategoryId,
    "name": name,
    "imageSrc": imageSrc == null ? null : imageSrc,
    "details": details,
    "parentCategory": parentCategory,
    "inverseParentCategory": List<dynamic>.from(inverseParentCategory.map((x) => x)),
    "products": List<dynamic>.from(products.map((x) => x)),
  };
}