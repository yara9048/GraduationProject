// To parse this JSON data, do
//
//     final playlistByClassModel = playlistByClassModelFromJson(jsonString);

import 'dart:convert';

List<PlaylistByClassModel> playlistByClassModelFromJson(String str) => List<PlaylistByClassModel>.from(json.decode(str).map((x) => PlaylistByClassModel.fromJson(x)));

String playlistByClassModelToJson(List<PlaylistByClassModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PlaylistByClassModel {
  int id;
  String name;
  String description;
  int owner;
  String category;
  int subject;
  SubjectDetail subjectDetail;
  String thumbnail;
  String price;
  int totalVideoCount;
  double? totalDuration;
  int studentsCount;
  int completionRate;
  dynamic rating;
  bool hasUserRating;
  int? userRating;
  bool hasSubscription;
  bool hasActiveSubscription;
  bool canAccessContent;
  DateTime createdAt;
  DateTime updatedAt;

  PlaylistByClassModel({
    required this.id,
    required this.name,
    required this.description,
    required this.owner,
    required this.category,
    required this.subject,
    required this.subjectDetail,
    required this.thumbnail,
    required this.price,
    required this.totalVideoCount,
    required this.totalDuration,
    required this.studentsCount,
    required this.completionRate,
    required this.rating,
    required this.hasUserRating,
    required this.userRating,
    required this.hasSubscription,
    required this.hasActiveSubscription,
    required this.canAccessContent,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PlaylistByClassModel.fromJson(Map<String, dynamic> json) => PlaylistByClassModel(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    owner: json["owner"],
    category: json["category"],
    subject: json["subject"],
    subjectDetail: SubjectDetail.fromJson(json["subject_detail"]),
    thumbnail: json["thumbnail"],
    price: json["price"],
    totalVideoCount: json["total_video_count"],
    totalDuration: json["total_duration"]?.toDouble(),
    studentsCount: json["students_count"],
    completionRate: json["completion_rate"],
    rating: json["rating"],
    hasUserRating: json["has_user_rating"],
    userRating: json["user_rating"],
    hasSubscription: json["has_subscription"],
    hasActiveSubscription: json["has_active_subscription"],
    canAccessContent: json["can_access_content"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "owner": owner,
    "category": category,
    "subject": subject,
    "subject_detail": subjectDetail.toJson(),
    "thumbnail": thumbnail,
    "price": price,
    "total_video_count": totalVideoCount,
    "total_duration": totalDuration,
    "students_count": studentsCount,
    "completion_rate": completionRate,
    "rating": rating,
    "has_user_rating": hasUserRating,
    "user_rating": userRating,
    "has_subscription": hasSubscription,
    "has_active_subscription": hasActiveSubscription,
    "can_access_content": canAccessContent,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}

class SubjectDetail {
  int id;
  String name;
  String slug;
  int category;
  CategoryDetail categoryDetail;
  String description;
  DateTime createdAt;
  DateTime updatedAt;

  SubjectDetail({
    required this.id,
    required this.name,
    required this.slug,
    required this.category,
    required this.categoryDetail,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SubjectDetail.fromJson(Map<String, dynamic> json) => SubjectDetail(
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
