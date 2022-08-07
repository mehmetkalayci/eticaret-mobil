import 'dart:convert';

HataModel hataModelFromJson(String str) => HataModel.fromJson(json.decode(str));

String hataModelToJson(HataModel data) => json.encode(data.toJson());

class HataModel {
  HataModel({
    required this.type,
    required this.title,
    required this.status,
    required this.detail,
    required this.traceId,
  });

  String type;
  String title;
  int status;
  String detail;
  String traceId;

  factory HataModel.fromJson(Map<String, dynamic> json) => HataModel(
    type: json["type"],
    title: json["title"],
    status: json["status"],
    detail: json["detail"] ?? "",
    traceId: json["traceId"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "title": title,
    "status": status,
    "detail": detail,
    "traceId": traceId,
  };
}
