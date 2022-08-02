import 'dart:convert';

class SliderImgModel {
  SliderImgModel({
    required this.sliderImgId,
    required this.sliderImgSrc,
    this.details,
    required this.isActive,
  });

  int sliderImgId;
  String sliderImgSrc;
  dynamic details;
  bool isActive;

  factory SliderImgModel.fromRawJson(String str) => SliderImgModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SliderImgModel.fromJson(Map<String, dynamic> json) => SliderImgModel(
    sliderImgId: json["sliderImgId"],
    sliderImgSrc: json["sliderImgSrc"],
    details: json["details"],
    isActive: json["isActive"],
  );

  Map<String, dynamic> toJson() => {
    "sliderImgId": sliderImgId,
    "sliderImgSrc": sliderImgSrc,
    "details": details,
    "isActive": isActive,
  };
}