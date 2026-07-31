import 'dart:convert';

List<DisplayPlayListBySubjectModel>
displayPlayListBySubjectModelFromJson(String str) {
  final decoded = json.decode(str) as List<dynamic>;

  return decoded
      .map(
        (item) => DisplayPlayListBySubjectModel.fromJson(
      item as Map<String, dynamic>,
    ),
  )
      .toList();
}

String displayPlayListBySubjectModelToJson(
    List<DisplayPlayListBySubjectModel> data,
    ) {
  return json.encode(
    data.map((item) => item.toJson()).toList(),
  );
}

class DisplayPlayListBySubjectModel {
  final int id;
  final String name;
  final String description;
  final dynamic owner;
  final String category;
  final int subject;
  final SubjectDetail subjectDetail;
  final String? thumbnail;
  final String price;
  final int totalVideoCount;
  final double totalDuration;
  final int studentsCount;
  final double completionRate;
  final double rating;
  final DateTime createdAt;
  final DateTime updatedAt;

  const DisplayPlayListBySubjectModel({
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
    required this.createdAt,
    required this.updatedAt,
  });

  factory DisplayPlayListBySubjectModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return DisplayPlayListBySubjectModel(
      id: _toInt(json["id"]),
      name: json["name"]?.toString() ?? "",
      description:
      json["description"]?.toString() ?? "",
      owner: json["owner"],
      category: json["category"]?.toString() ?? "",
      subject: _toInt(json["subject"]),
      subjectDetail: SubjectDetail.fromJson(
        json["subject_detail"]
        as Map<String, dynamic>? ??
            {},
      ),
      thumbnail: json["thumbnail"]?.toString(),
      price: json["price"]?.toString() ?? "0.00",
      totalVideoCount:
      _toInt(json["total_video_count"]),
      totalDuration:
      _toDouble(json["total_duration"]),
      studentsCount:
      _toInt(json["students_count"]),
      completionRate:
      _toDouble(json["completion_rate"]),
      rating: _toDouble(json["rating"]),
      createdAt: _toDateTime(json["created_at"]),
      updatedAt: _toDateTime(json["updated_at"]),
    );
  }

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
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}

class SubjectDetail {
  final int id;
  final String name;
  final String slug;
  final int category;
  final CategoryDetail categoryDetail;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SubjectDetail({
    required this.id,
    required this.name,
    required this.slug,
    required this.category,
    required this.categoryDetail,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SubjectDetail.fromJson(
      Map<String, dynamic> json,
      ) {
    return SubjectDetail(
      id: _toInt(json["id"]),
      name: json["name"]?.toString() ?? "",
      slug: json["slug"]?.toString() ?? "",
      category: _toInt(json["category"]),
      categoryDetail: CategoryDetail.fromJson(
        json["category_detail"]
        as Map<String, dynamic>? ??
            {},
      ),
      description:
      json["description"]?.toString() ?? "",
      createdAt: _toDateTime(json["created_at"]),
      updatedAt: _toDateTime(json["updated_at"]),
    );
  }

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
  final int id;
  final String name;
  final String slug;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CategoryDetail({
    required this.id,
    required this.name,
    required this.slug,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CategoryDetail.fromJson(
      Map<String, dynamic> json,
      ) {
    return CategoryDetail(
      id: _toInt(json["id"]),
      name: json["name"]?.toString() ?? "",
      slug: json["slug"]?.toString() ?? "",
      createdAt: _toDateTime(json["created_at"]),
      updatedAt: _toDateTime(json["updated_at"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "slug": slug,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}

int _toInt(dynamic value) {
  if (value == null) return 0;

  if (value is num) {
    return value.toInt();
  }

  return int.tryParse(value.toString()) ??
      double.tryParse(value.toString())?.toInt() ??
      0;
}

double _toDouble(dynamic value) {
  if (value == null) return 0.0;

  if (value is num) {
    return value.toDouble();
  }

  return double.tryParse(value.toString()) ?? 0.0;
}

DateTime _toDateTime(dynamic value) {
  if (value == null) {
    return DateTime.fromMillisecondsSinceEpoch(0);
  }

  return DateTime.tryParse(value.toString()) ??
      DateTime.fromMillisecondsSinceEpoch(0);
}