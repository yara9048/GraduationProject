// To parse this JSON data, do
//
//     final resendOtpModel = resendOtpModelFromJson(jsonString);

import 'dart:convert';

ResendOtpModel resendOtpModelFromJson(String str) => ResendOtpModel.fromJson(json.decode(str));

String resendOtpModelToJson(ResendOtpModel data) => json.encode(data.toJson());

class ResendOtpModel {
  String detail;

  ResendOtpModel({
    required this.detail,
  });

  factory ResendOtpModel.fromJson(Map<String, dynamic> json) => ResendOtpModel(
    detail: json["detail"],
  );

  Map<String, dynamic> toJson() => {
    "detail": detail,
  };
}
