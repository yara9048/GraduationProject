// To parse this JSON data, do
//
//     final refreshModel = refreshModelFromJson(jsonString);

import 'dart:convert';

RefreshModel refreshModelFromJson(String str) => RefreshModel.fromJson(json.decode(str));

String refreshModelToJson(RefreshModel data) => json.encode(data.toJson());

class RefreshModel {
  String access;
  String refresh;

  RefreshModel({
    required this.access,
    required this.refresh,
  });

  factory RefreshModel.fromJson(Map<String, dynamic> json) => RefreshModel(
    access: json["access"],
    refresh: json["refresh"],
  );

  Map<String, dynamic> toJson() => {
    "access": access,
    "refresh": refresh,
  };
}
