// To parse this JSON data, do
//
//     final playListDetailsModel = playListDetailsModelFromJson(jsonString);

import 'dart:convert';

PlayListDetailsModel playListDetailsModelFromJson(String str) => PlayListDetailsModel.fromJson(json.decode(str));

String playListDetailsModelToJson(PlayListDetailsModel data) => json.encode(data.toJson());

class PlayListDetailsModel {
  int id;
  String name;
  String description;
  String category;
  dynamic thumbnail;
  int totalVideoCount;
  double totalDuration;
  int studentsCount;
  int completionRate;
  int rating;
  DateTime createdAt;
  DateTime updatedAt;

  PlayListDetailsModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.thumbnail,
    required this.totalVideoCount,
    required this.totalDuration,
    required this.studentsCount,
    required this.completionRate,
    required this.rating,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PlayListDetailsModel.fromJson(Map<String, dynamic> json) => PlayListDetailsModel(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    category: json["category"],
    thumbnail: json["thumbnail"],
    totalVideoCount: json["total_video_count"],
    totalDuration: json["total_duration"]?.toDouble(),
    studentsCount: json["students_count"],
    completionRate: json["completion_rate"],
    rating: json["rating"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "category": category,
    "thumbnail": thumbnail,
    "total_video_count": totalVideoCount,
    "total_duration": totalDuration,
    "students_count": studentsCount,
    "completion_rate": completionRate,
    "rating": rating,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
