class FilteredPlayListsModel {
  final int id;
  final String name;
  final String description;
  final String category;
  final String? thumbnail;
  final int totalVideoCount;
  final double? totalDuration;
  final int studentsCount;
  final double completionRate;
  final String rating;
  final DateTime createdAt;
  final DateTime updatedAt;

  FilteredPlayListsModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    this.thumbnail,
    required this.totalVideoCount,
    this.totalDuration,
    required this.studentsCount,
    required this.completionRate,
    required this.rating,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FilteredPlayListsModel.fromJson(Map<String, dynamic> json) {
    return FilteredPlayListsModel(
      id: json["id"],
      name: json["name"] ?? "",
      description: json["description"] ?? "",
      category: json["category"] ?? "",
      thumbnail: json["thumbnail"],
      totalVideoCount: json["total_video_count"] ?? 0,
      totalDuration: json["total_duration"] == null
          ? null
          : (json["total_duration"] as num).toDouble(),
      studentsCount: json["students_count"] ?? 0,
      completionRate: (json["completion_rate"] as num).toDouble(),
      rating: json["rating"] ?? "",
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
    );
  }

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