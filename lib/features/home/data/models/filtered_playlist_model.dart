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
  final DateTime? createdAt;
  final DateTime? updatedAt;

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

  factory FilteredPlayListsModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return FilteredPlayListsModel(
      id: _toInt(json["id"]),
      name: json["name"]?.toString() ?? "",
      description: json["description"]?.toString() ?? "",
      category: json["category"]?.toString() ?? "",
      thumbnail: json["thumbnail"]?.toString(),
      totalVideoCount: _toInt(json["total_video_count"]),
      totalDuration: _toNullableDouble(json["total_duration"]),
      studentsCount: _toInt(json["students_count"]),
      completionRate: _toDouble(json["completion_rate"]),
      rating: json["rating"]?.toString() ?? "",
      createdAt: _toDateTime(json["created_at"]),
      updatedAt: _toDateTime(json["updated_at"]),
    );
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(value.toString()) ??
        double.tryParse(value.toString())?.toInt() ??
        0;
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value.toString()) ?? 0.0;
  }

  static double? _toNullableDouble(dynamic value) {
    if (value == null) return null;

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value.toString());
  }

  static DateTime? _toDateTime(dynamic value) {
    if (value == null) return null;

    return DateTime.tryParse(value.toString());
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
      "created_at": createdAt?.toIso8601String(),
      "updated_at": updatedAt?.toIso8601String(),
    };
  }
}