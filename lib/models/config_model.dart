
import 'dart:convert';

ConfigModel configFromJson(String str) => ConfigModel.fromJson(json.decode(str));

String configToJson(ConfigModel data) => json.encode(data.toJson());

class ConfigModel {
  ConfigModel({
    required this.configId,
    required this.shipmentFee,
    required this.shipmentFeeUnder,
    required this.appContactPhone,
    this.appWhatsappUrl,
  });

  int configId;
  double shipmentFee;
  double shipmentFeeUnder;
  String appContactPhone;
  String? appWhatsappUrl;

  factory ConfigModel.fromJson(Map<String, dynamic> json) => ConfigModel(
    configId: json["configId"],
    shipmentFee: json["shipmentFee"],
    shipmentFeeUnder: json["shipmentFeeUnder"],
    appContactPhone: json["appContactPhone"],
    appWhatsappUrl: json["appWhatsappURL"],
  );

  Map<String, dynamic> toJson() => {
    "configId": configId,
    "shipmentFee": shipmentFee,
    "shipmentFeeUnder": shipmentFeeUnder,
    "appContactPhone": appContactPhone,
    "appWhatsappURL": appWhatsappUrl,
  };
}
