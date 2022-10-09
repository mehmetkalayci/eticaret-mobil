import 'dart:convert';

class AppConfigResponseModel {
  int? configId;
  int? shipmentFee;
  int? shipmentFeeUnder;

  AppConfigResponseModel({this.configId, this.shipmentFee, this.shipmentFeeUnder});

  AppConfigResponseModel.fromJson(Map<String, dynamic> json) {
    configId = json['configId'];
    shipmentFee = json['shipmentFee'];
    shipmentFeeUnder = json['shipmentFeeUnder'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['configId'] = this.configId;
    data['shipmentFee'] = this.shipmentFee;
    data['shipmentFeeUnder'] = this.shipmentFeeUnder;
    return data;
  }
}