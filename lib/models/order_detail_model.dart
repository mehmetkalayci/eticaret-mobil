import 'dart:convert';

class OrderDetailModel {
  OrderDetailModel({
    required this.orderDetailId,
    required this.orderId,
    required this.productId,
    required this.productName,
    required this.sellingPrice,
    required this.discountedPrice,
    required this.appliedPrice,
    required this.pcs,
    this.order,
    this.product,
  });

  int orderDetailId;
  int orderId;
  int productId;
  String productName;
  double sellingPrice;
  double discountedPrice;
  double appliedPrice;
  int pcs;
  dynamic order;
  dynamic product;

  factory OrderDetailModel.fromRawJson(String str) => OrderDetailModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) => OrderDetailModel(
    orderDetailId: json["orderDetailId"],
    orderId: json["orderId"],
    productId: json["productId"],
    productName: json["productName"],
    sellingPrice: json["sellingPrice"],
    discountedPrice: json["discountedPrice"],
    appliedPrice: json["appliedPrice"],
    pcs: json["pcs"],
    order: json["order"],
    product: json["product"],
  );

  Map<String, dynamic> toJson() => {
    "orderDetailId": orderDetailId,
    "orderId": orderId,
    "productId": productId,
    "productName": productName,
    "sellingPrice": sellingPrice,
    "discountedPrice": discountedPrice,
    "appliedPrice": appliedPrice,
    "pcs": pcs,
    "order": order,
    "product": product,
  };
}