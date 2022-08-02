import 'dart:convert';

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