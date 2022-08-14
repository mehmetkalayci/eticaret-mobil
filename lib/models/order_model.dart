import 'dart:convert';

import 'package:ecommerce_mobile/models/order_detail_model.dart';
import 'package:ecommerce_mobile/models/order_status_model.dart';

class OrderModel {
  OrderModel({
    required this.orderId,
    required this.orderDate,
    required this.userId,
    required this.paymentType,
    required this.totalAmount,
    required this.appliedDiscountAmount,
    required this.paidAmount,
    required this.appliedDiscountCode,
    required this.address,
    this.notes,
    this.user,
    required this.orderDetails,
    required this.orderStatuses,
  });

  int orderId;
  DateTime orderDate;
  int userId;
  String paymentType;
  double totalAmount;
  double appliedDiscountAmount;
  double paidAmount;
  String appliedDiscountCode;
  String address;
  dynamic notes;
  dynamic user;
  List<OrderDetailModel> orderDetails;
  List<OrderStatusModel> orderStatuses;

  factory OrderModel.fromRawJson(String str) => OrderModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
    orderId: json["orderId"],
    orderDate: DateTime.parse(json["orderDate"]),
    userId: json["userId"],
    paymentType: json["paymentType"],
    totalAmount: json["totalAmount"],
    appliedDiscountAmount: json["appliedDiscountAmount"],
    paidAmount: json["paidAmount"],
    appliedDiscountCode: json["appliedDiscountCode"],
    address: json["address"],
    notes: json["notes"],
    user: json["user"],
    orderDetails: List<OrderDetailModel>.from(json["orderDetails"].map((x) => OrderDetailModel.fromJson(x))),
    orderStatuses: List<OrderStatusModel>.from(json["orderStatuses"].map((x) => OrderStatusModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "orderId": orderId,
    "orderDate": orderDate.toIso8601String(),
    "userId": userId,
    "paymentType": paymentType,
    "totalAmount": totalAmount,
    "appliedDiscountAmount": appliedDiscountAmount,
    "paidAmount": paidAmount,
    "appliedDiscountCode": appliedDiscountCode,
    "address": address,
    "notes": notes,
    "user": user,
    "orderDetails": List<dynamic>.from(orderDetails.map((x) => x.toJson())),
    "orderStatuses": List<dynamic>.from(orderStatuses.map((x) => x.toJson())),
  };
}