import 'dart:convert';

import 'package:ecommerce_mobile/models/sliderImg_model.dart';
import 'package:ecommerce_mobile/models/story_model.dart';

import 'category_model.dart';

class HomepageModel {
  HomepageModel({
    required this.sliderImgs,
    required this.stories,
    required this.categories,
  });

  List<SliderImgModel> sliderImgs;
  List<StoryModel> stories;
  List<CategoryModel> categories;

  factory HomepageModel.fromRawJson(String str) => HomepageModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory HomepageModel.fromJson(Map<String, dynamic> json) => HomepageModel(
    sliderImgs: List<SliderImgModel>.from(json["sliderImgs"].map((x) => SliderImgModel.fromJson(x))),
    stories: List<StoryModel>.from(json["stories"].map((x) => StoryModel.fromJson(x))),
    categories: List<CategoryModel>.from(json["categories"].map((x) => CategoryModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "sliderImgs": List<dynamic>.from(sliderImgs.map((x) => x.toJson())),
    "stories": List<dynamic>.from(stories.map((x) => x.toJson())),
    "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
  };
}