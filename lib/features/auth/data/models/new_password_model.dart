// To parse this JSON data, do
//
//     final newPasswordModel = newPasswordModelFromJson(jsonString);

import 'dart:convert';

NewPasswordModel newPasswordModelFromJson(String str) => NewPasswordModel.fromJson(json.decode(str));

String newPasswordModelToJson(NewPasswordModel data) => json.encode(data.toJson());

class NewPasswordModel {
  String detail;

  NewPasswordModel({
    required this.detail,
  });

  factory NewPasswordModel.fromJson(Map<String, dynamic> json) => NewPasswordModel(
    detail: json["detail"],
  );

  Map<String, dynamic> toJson() => {
    "detail": detail,
  };
}
