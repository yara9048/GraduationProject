// To parse this JSON data, do
//
//     final displaySubjectsModel = displaySubjectsModelFromJson(jsonString);

import 'dart:convert';

List<DisplaySubjectsModel> displaySubjectsModelFromJson(String str) => List<DisplaySubjectsModel>.from(json.decode(str).map((x) => DisplaySubjectsModel.fromJson(x)));

String displaySubjectsModelToJson(List<DisplaySubjectsModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DisplaySubjectsModel {
  int id;
  String name;
  String slug;
  int category;
  CategoryDetail categoryDetail;
  String description;
  DateTime createdAt;
  DateTime updatedAt;

  DisplaySubjectsModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.category,
    required this.categoryDetail,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DisplaySubjectsModel.fromJson(Map<String, dynamic> json) => DisplaySubjectsModel(
    id: json["id"],
    name: json["name"],
    slug: json["slug"],
    category: json["category"],
    categoryDetail: CategoryDetail.fromJson(json["category_detail"]),
    description: json["description"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "slug": slug,
    "category": category,
    "category_detail": categoryDetail.toJson(),
    "description": description,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}

class CategoryDetail {
  int id;
  String name;
  String slug;
  DateTime createdAt;
  DateTime updatedAt;

  CategoryDetail({
    required this.id,
    required this.name,
    required this.slug,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CategoryDetail.fromJson(Map<String, dynamic> json) => CategoryDetail(
    id: json["id"],
    name: json["name"],
    slug: json["slug"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "slug": slug,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
