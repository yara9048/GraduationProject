// To parse this JSON data, do
//
//     final passwordSendOtpModel = passwordSendOtpModelFromJson(jsonString);

import 'dart:convert';

PasswordSendOtpModel passwordSendOtpModelFromJson(String str) => PasswordSendOtpModel.fromJson(json.decode(str));

String passwordSendOtpModelToJson(PasswordSendOtpModel data) => json.encode(data.toJson());

class PasswordSendOtpModel {
  String detail;

  PasswordSendOtpModel({
    required this.detail,
  });

  factory PasswordSendOtpModel.fromJson(Map<String, dynamic> json) => PasswordSendOtpModel(
    detail: json["detail"],
  );

  Map<String, dynamic> toJson() => {
    "detail": detail,
  };
}
