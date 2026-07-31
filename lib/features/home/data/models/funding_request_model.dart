// To parse this JSON data, do
//
//     final fundingRequestModel = fundingRequestModelFromJson(jsonString);

import 'dart:convert';

FundingRequestModel fundingRequestModelFromJson(String str) => FundingRequestModel.fromJson(json.decode(str));

String fundingRequestModelToJson(FundingRequestModel data) => json.encode(data.toJson());

class FundingRequestModel {
  int id;
  int user;
  String amount;
  String status;
  String note;
  String adminNote;
  dynamic reviewedBy;
  dynamic reviewedAt;
  DateTime createdAt;
  DateTime updatedAt;

  FundingRequestModel({
    required this.id,
    required this.user,
    required this.amount,
    required this.status,
    required this.note,
    required this.adminNote,
    required this.reviewedBy,
    required this.reviewedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FundingRequestModel.fromJson(Map<String, dynamic> json) => FundingRequestModel(
    id: json["id"],
    user: json["user"],
    amount: json["amount"],
    status: json["status"],
    note: json["note"],
    adminNote: json["admin_note"],
    reviewedBy: json["reviewed_by"],
    reviewedAt: json["reviewed_at"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user": user,
    "amount": amount,
    "status": status,
    "note": note,
    "admin_note": adminNote,
    "reviewed_by": reviewedBy,
    "reviewed_at": reviewedAt,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
