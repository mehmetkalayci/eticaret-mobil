import 'dart:convert';
import 'dart:developer';

import 'package:ecommerce_mobile/models/order_detail_model.dart';
import 'package:ecommerce_mobile/models/order_status_model.dart';

class OrderHistoryModel {
  OrderHistoryModel({
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
  String orderDate;
  int userId;
  String paymentType;
  double totalAmount;
  double appliedDiscountAmount;
  double paidAmount;
  String appliedDiscountCode;
  String address;
  String? notes;
  dynamic user;

  List<OrderDetailModel> orderDetails;
  List<OrderStatusModel> orderStatuses;

  factory OrderHistoryModel.fromRawJson(String str) =>
      OrderHistoryModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrderHistoryModel.fromJson(Map<String, dynamic> json) =>
      OrderHistoryModel(
        orderId: json["orderId"],
        orderDate: json["orderDate"],
        userId: json["userId"],
        paymentType: json["paymentType"],
        totalAmount: json["totalAmount"],
        appliedDiscountAmount: json["appliedDiscountAmount"],
        paidAmount: json["paidAmount"],
        appliedDiscountCode: json["appliedDiscountCode"],
        address: json["address"],
        notes: json["notes"],
        user: json["user"],
        orderDetails: List<OrderDetailModel>.from(
            json["orderDetails"].map((x) => OrderDetailModel.fromJson(x))),
        orderStatuses: List<OrderStatusModel>.from(
            json["orderStatuses"].map((x) => OrderStatusModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "orderId": orderId,
        "orderDate": orderDate,
        "userId": userId,
        "paymentType": paymentType,
        "totalAmount": totalAmount,
        "appliedDiscountAmount": appliedDiscountAmount,
        "paidAmount": paidAmount,
        "appliedDiscountCode": appliedDiscountCode,
        "address": address,
        "notes": notes,
        "user": user,
        "orderDetails":
            List<OrderDetailModel>.from(orderDetails.map((x) => x.toJson())),
        "orderStatuses":
            List<OrderStatusModel>.from(orderStatuses.map((x) => x.toJson())),
      };
}
