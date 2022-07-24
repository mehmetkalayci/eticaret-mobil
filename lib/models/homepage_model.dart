import 'dart:convert';

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

class StoryModel {
  StoryModel({
    required this.storyId,
    required this.storyCoverImgSrc,
    required this.storyImgSrc,
    required this.storyTitle,
    required this.isActive,
  });

  int storyId;
  String storyCoverImgSrc;
  String storyImgSrc;
  String storyTitle;
  bool isActive;

  factory StoryModel.fromRawJson(String str) => StoryModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StoryModel.fromJson(Map<String, dynamic> json) => StoryModel(
    storyId: json["storyId"],
    storyCoverImgSrc: json["storyCoverImgSrc"],
    storyImgSrc: json["storyImgSrc"],
    storyTitle: json["storyTitle"],
    isActive: json["isActive"],
  );

  Map<String, dynamic> toJson() => {
    "storyId": storyId,
    "storyCoverImgSrc": storyCoverImgSrc,
    "storyImgSrc": storyImgSrc,
    "storyTitle": storyTitle,
    "isActive": isActive,
  };
}
