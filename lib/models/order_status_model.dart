import 'dart:convert';

class OrderStatusModel {
  OrderStatusModel({
    required this.id,
    required this.orderId,
    required this.status,
    required this.details,
    required this.operationTime,
    required this.order,
  });

  int id;
  int orderId;
  String status;
  String? details;
  DateTime operationTime;
  dynamic order;

  factory OrderStatusModel.fromRawJson(String str) => OrderStatusModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrderStatusModel.fromJson(Map<String, dynamic> json) => OrderStatusModel(
    id: json["id"],
    orderId: json["orderId"],
    status: json["status"],
    details: json["details"] ?? "",
    operationTime: DateTime.parse(json["operationTime"]),
    order: json["order"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "orderId": orderId,
    "status": status,
    "details": details,
    "operationTime": operationTime.toIso8601String(),
    "order": order,
  };
}