import 'dart:convert';

PlayListDetailsModel playListDetailsModelFromJson(String str) =>
    PlayListDetailsModel.fromJson(json.decode(str));

String playListDetailsModelToJson(PlayListDetailsModel data) =>
    json.encode(data.toJson());

class PlayListDetailsModel {
  final int id;
  final String name;
  final String description;
  final String category;
  final dynamic thumbnail;
  final int totalVideoCount;
  final double totalDuration;
  final int studentsCount;
  final double completionRate;
  final double rating;
  final DateTime createdAt;
  final DateTime updatedAt;

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

  factory PlayListDetailsModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return PlayListDetailsModel(
      id: (json["id"] as num).toInt(),
      name: json["name"]?.toString() ?? "",
      description:
      json["description"]?.toString() ?? "",
      category:
      json["category"]?.toString() ?? "",
      thumbnail: json["thumbnail"],

      totalVideoCount:
      (json["total_video_count"] as num)
          .toInt(),

      totalDuration:
      (json["total_duration"] as num)
          .toDouble(),

      studentsCount:
      (json["students_count"] as num)
          .toInt(),

      completionRate:
      (json["completion_rate"] as num)
          .toDouble(),

      rating:
      (json["rating"] as num)
          .toDouble(),

      createdAt: DateTime.parse(
        json["created_at"].toString(),
      ),

      updatedAt: DateTime.parse(
        json["updated_at"].toString(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
}