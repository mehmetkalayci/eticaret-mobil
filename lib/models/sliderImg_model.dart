import 'dart:convert';

class SliderImgModel {
  SliderImgModel({
    required this.sliderImgId,
    required this.sliderImgSrc,
    this.details,
    required this.isActive,
    this.productId,
    this.categoryId,
  });

  int sliderImgId;
  String sliderImgSrc;
  dynamic details;
  bool isActive;
  int? productId;
  int? categoryId;


  factory SliderImgModel.fromRawJson(String str) => SliderImgModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SliderImgModel.fromJson(Map<String, dynamic> json) => SliderImgModel(
    sliderImgId: json["sliderImgId"],
    sliderImgSrc: json["sliderImgSrc"],
    details: json["details"],
    isActive: json["isActive"],
    productId: json["productId"],
    categoryId: json["categoryId"],
  );

  Map<String, dynamic> toJson() => {
    "sliderImgId": sliderImgId,
    "sliderImgSrc": sliderImgSrc,
    "details": details,
    "isActive": isActive,
    "productId": productId,
    "categoryId": categoryId,
  };
}