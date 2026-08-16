// To parse this JSON data, do
//
//     final regnerateMcqModel = regnerateMcqModelFromJson(jsonString);

import 'dart:convert';

RegnerateMcqModel regnerateMcqModelFromJson(String str) => RegnerateMcqModel.fromJson(json.decode(str));

String regnerateMcqModelToJson(RegnerateMcqModel data) => json.encode(data.toJson());

class RegnerateMcqModel {
  String status;
  String message;
  List<dynamic> categories;
  int perCategory;
  int count;
  List<dynamic> mcqs;

  RegnerateMcqModel({
    required this.status,
    required this.message,
    required this.categories,
    required this.perCategory,
    required this.count,
    required this.mcqs,
  });

  factory RegnerateMcqModel.fromJson(Map<String, dynamic> json) => RegnerateMcqModel(
    status: json["status"],
    message: json["message"],
    categories: List<dynamic>.from(json["categories"].map((x) => x)),
    perCategory: json["per_category"],
    count: json["count"],
    mcqs: List<dynamic>.from(json["mcqs"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "categories": List<dynamic>.from(categories.map((x) => x)),
    "per_category": perCategory,
    "count": count,
    "mcqs": List<dynamic>.from(mcqs.map((x) => x)),
  };
}
