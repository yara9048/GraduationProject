import 'dart:convert';

SubscribeModel subscribeModelFromJson(String str) {
  return SubscribeModel.fromJson(
    json.decode(str) as Map<String, dynamic>,
  );
}

String subscribeModelToJson(SubscribeModel data) {
  return json.encode(data.toJson());
}

class SubscribeModel {
  final int id;
  final int user;
  final int playlist;
  final PlaylistDetail? playlistDetail;
  final bool isActive;
  final String pricePaid;
  final String teacherAmount;
  final String adminAmount;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const SubscribeModel({
    required this.id,
    required this.user,
    required this.playlist,
    required this.playlistDetail,
    required this.isActive,
    required this.pricePaid,
    required this.teacherAmount,
    required this.adminAmount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SubscribeModel.fromJson(
      Map<String, dynamic> json,
      ) {
    final playlistDetailJson = json["playlist_detail"];

    return SubscribeModel(
      id: _toInt(json["id"]),
      user: _toInt(json["user"]),
      playlist: _toInt(json["playlist"]),

      playlistDetail:
      playlistDetailJson is Map<String, dynamic>
          ? PlaylistDetail.fromJson(
        playlistDetailJson,
      )
          : null,

      isActive: _toBool(json["is_active"]),

      pricePaid: json["price_paid"]?.toString() ?? "0",

      teacherAmount:
      json["teacher_amount"]?.toString() ?? "0",

      adminAmount:
      json["admin_amount"]?.toString() ?? "0",

      createdAt: _toDateTime(json["created_at"]),
      updatedAt: _toDateTime(json["updated_at"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "user": user,
    "playlist": playlist,
    "playlist_detail": playlistDetail?.toJson(),
    "is_active": isActive,
    "price_paid": pricePaid,
    "teacher_amount": teacherAmount,
    "admin_amount": adminAmount,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class PlaylistDetail {
  final int id;
  final String name;
  final String description;
  final dynamic owner;
  final String category;
  final int subject;
  final SubjectDetail? subjectDetail;
  final dynamic thumbnail;
  final String price;
  final int totalVideoCount;
  final double totalDuration;
  final int studentsCount;
  final double completionRate;
  final double rating;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const PlaylistDetail({
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

  factory PlaylistDetail.fromJson(
      Map<String, dynamic> json,
      ) {
    final subjectDetailJson = json["subject_detail"];

    return PlaylistDetail(
      id: _toInt(json["id"]),

      name: json["name"]?.toString() ?? "",

      description:
      json["description"]?.toString() ?? "",

      owner: json["owner"],

      category: json["category"]?.toString() ?? "",

      subject: _toInt(json["subject"]),

      subjectDetail:
      subjectDetailJson is Map<String, dynamic>
          ? SubjectDetail.fromJson(
        subjectDetailJson,
      )
          : null,

      thumbnail: json["thumbnail"],

      price: json["price"]?.toString() ?? "0",

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
    "subject_detail": subjectDetail?.toJson(),
    "thumbnail": thumbnail,
    "price": price,
    "total_video_count": totalVideoCount,
    "total_duration": totalDuration,
    "students_count": studentsCount,
    "completion_rate": completionRate,
    "rating": rating,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class SubjectDetail {
  final int id;
  final String name;
  final String slug;
  final int category;
  final CategoryDetail? categoryDetail;
  final String description;
  final DateTime? createdAt;
  final DateTime? updatedAt;

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
    final categoryDetailJson = json["category_detail"];

    return SubjectDetail(
      id: _toInt(json["id"]),

      name: json["name"]?.toString() ?? "",

      slug: json["slug"]?.toString() ?? "",

      category: _toInt(json["category"]),

      categoryDetail:
      categoryDetailJson is Map<String, dynamic>
          ? CategoryDetail.fromJson(
        categoryDetailJson,
      )
          : null,

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
    "category_detail": categoryDetail?.toJson(),
    "description": description,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class CategoryDetail {
  final int id;
  final String name;
  final String slug;
  final DateTime? createdAt;
  final DateTime? updatedAt;

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
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

int _toInt(dynamic value) {
  if (value == null) {
    return 0;
  }

  if (value is int) {
    return value;
  }

  if (value is num) {
    return value.toInt();
  }

  return int.tryParse(value.toString()) ?? 0;
}

double _toDouble(dynamic value) {
  if (value == null) {
    return 0.0;
  }

  if (value is num) {
    return value.toDouble();
  }

  final parsedValue = double.tryParse(
    value.toString(),
  );

  return parsedValue ?? 0.0;
}

bool _toBool(dynamic value) {
  if (value is bool) {
    return value;
  }

  if (value is num) {
    return value != 0;
  }

  if (value is String) {
    return value.toLowerCase() == "true" ||
        value == "1";
  }

  return false;
}

DateTime? _toDateTime(dynamic value) {
  if (value == null) {
    return null;
  }

  return DateTime.tryParse(
    value.toString(),
  );
}