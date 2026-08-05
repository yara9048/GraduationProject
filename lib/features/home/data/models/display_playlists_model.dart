import 'dart:convert';

List<DisplayPlaylistsModel> displayPlaylistsModelFromJson(
    String str,
    ) {
  try {
    final decodedData = json.decode(str);

    if (decodedData is! List) {
      return [];
    }

    return decodedData
        .whereType<Map<String, dynamic>>()
        .map(DisplayPlaylistsModel.fromJson)
        .toList();
  } catch (e) {
    print(
      "DisplayPlaylistsModel parsing error: $e",
    );
    return [];
  }
}

String displayPlaylistsModelToJson(
    List<DisplayPlaylistsModel> data,
    ) {
  return json.encode(
    data.map((item) => item.toJson()).toList(),
  );
}

class DisplayPlaylistsModel {
  final int id;
  final String name;
  final String description;

  /// يمكن أن يكون null أو Object من الـ API.
  final dynamic owner;

  final String category;
  final int subject;
  final SubjectDetail? subjectDetail;
  final String? thumbnail;
  final double price;
  final int totalVideoCount;
  final double? totalDuration;
  final int studentsCount;
  final double completionRate;

  /// لأن الـ API قد يرجع رقمًا أو "N/A".
  final String rating;

  final bool hasSubscription;
  final bool hasActiveSubscription;
  final bool canAccessContent;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const DisplayPlaylistsModel({
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
    required this.hasSubscription,
    required this.hasActiveSubscription,
    required this.canAccessContent,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DisplayPlaylistsModel.fromJson(
      Map<String, dynamic> json,
      ) {
    try {
      return DisplayPlaylistsModel(
        id: _parseInt(json["id"]),
        name: _parseString(json["name"]),
        description: _parseString(
          json["description"],
        ),
        owner: json["owner"],
        category: _parseString(
          json["category"],
        ),
        subject: _parseInt(json["subject"]),
        subjectDetail:
        json["subject_detail"]
        is Map<String, dynamic>
            ? SubjectDetail.fromJson(
          json["subject_detail"]
          as Map<String, dynamic>,
        )
            : null,
        thumbnail:
        json["thumbnail"]?.toString(),
        price: _parseDouble(json["price"]),
        totalVideoCount: _parseInt(
          json["total_video_count"],
        ),
        totalDuration:
        json["total_duration"] == null
            ? null
            : _parseDouble(
          json["total_duration"],
        ),
        studentsCount: _parseInt(
          json["students_count"],
        ),
        completionRate: _parseDouble(
          json["completion_rate"],
        ),
        rating: _parseRating(
          json["rating"],
        ),
        hasSubscription: _parseBool(
          json["has_subscription"],
        ),
        hasActiveSubscription: _parseBool(
          json["has_active_subscription"],
        ),
        canAccessContent: _parseBool(
          json["can_access_content"],
        ),
        createdAt: _parseDateTime(
          json["created_at"],
        ),
        updatedAt: _parseDateTime(
          json["updated_at"],
        ),
      );
    } catch (e) {
      print(
        "DisplayPlaylistsModel.fromJson error: $e",
      );

      return const DisplayPlaylistsModel(
        id: 0,
        name: "",
        description: "",
        owner: null,
        category: "",
        subject: 0,
        subjectDetail: null,
        thumbnail: null,
        price: 0.0,
        totalVideoCount: 0,
        totalDuration: null,
        studentsCount: 0,
        completionRate: 0.0,
        rating: "N/A",
        hasSubscription: false,
        hasActiveSubscription: false,
        canAccessContent: false,
        createdAt: null,
        updatedAt: null,
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "owner": owner,
      "category": category,
      "subject": subject,
      "subject_detail":
      subjectDetail?.toJson(),
      "thumbnail": thumbnail,
      "price": price.toStringAsFixed(2),
      "total_video_count":
      totalVideoCount,
      "total_duration": totalDuration,
      "students_count": studentsCount,
      "completion_rate": completionRate,
      "rating": rating,
      "has_subscription":
      hasSubscription,
      "has_active_subscription":
      hasActiveSubscription,
      "can_access_content":
      canAccessContent,
      "created_at":
      createdAt?.toIso8601String(),
      "updated_at":
      updatedAt?.toIso8601String(),
    };
  }
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
    try {
      return SubjectDetail(
        id: _parseInt(json["id"]),
        name: _parseString(json["name"]),
        slug: _parseString(json["slug"]),
        category: _parseInt(
          json["category"],
        ),
        categoryDetail:
        json["category_detail"]
        is Map<String, dynamic>
            ? CategoryDetail.fromJson(
          json["category_detail"]
          as Map<String, dynamic>,
        )
            : null,
        description: _parseString(
          json["description"],
        ),
        createdAt: _parseDateTime(
          json["created_at"],
        ),
        updatedAt: _parseDateTime(
          json["updated_at"],
        ),
      );
    } catch (e) {
      print(
        "SubjectDetail.fromJson error: $e",
      );

      return const SubjectDetail(
        id: 0,
        name: "",
        slug: "",
        category: 0,
        categoryDetail: null,
        description: "",
        createdAt: null,
        updatedAt: null,
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "slug": slug,
      "category": category,
      "category_detail":
      categoryDetail?.toJson(),
      "description": description,
      "created_at":
      createdAt?.toIso8601String(),
      "updated_at":
      updatedAt?.toIso8601String(),
    };
  }
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
    try {
      return CategoryDetail(
        id: _parseInt(json["id"]),
        name: _parseString(json["name"]),
        slug: _parseString(json["slug"]),
        createdAt: _parseDateTime(
          json["created_at"],
        ),
        updatedAt: _parseDateTime(
          json["updated_at"],
        ),
      );
    } catch (e) {
      print(
        "CategoryDetail.fromJson error: $e",
      );

      return const CategoryDetail(
        id: 0,
        name: "",
        slug: "",
        createdAt: null,
        updatedAt: null,
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "slug": slug,
      "created_at":
      createdAt?.toIso8601String(),
      "updated_at":
      updatedAt?.toIso8601String(),
    };
  }
}

int _parseInt(dynamic value) {
  if (value == null) return 0;

  if (value is int) return value;

  if (value is num) {
    return value.toInt();
  }

  return int.tryParse(
    value.toString(),
  ) ??
      0;
}

double _parseDouble(dynamic value) {
  if (value == null) return 0.0;

  if (value is double) return value;

  if (value is num) {
    return value.toDouble();
  }

  return double.tryParse(
    value.toString(),
  ) ??
      0.0;
}

String _parseString(dynamic value) {
  if (value == null) return "";

  return value.toString();
}

bool _parseBool(dynamic value) {
  if (value == null) return false;

  if (value is bool) return value;

  if (value is num) {
    return value != 0;
  }

  final normalizedValue = value
      .toString()
      .trim()
      .toLowerCase();

  return normalizedValue == "true" ||
      normalizedValue == "1" ||
      normalizedValue == "yes";
}

DateTime? _parseDateTime(dynamic value) {
  if (value == null) return null;

  return DateTime.tryParse(
    value.toString(),
  );
}

String _parseRating(dynamic value) {
  if (value == null) return "N/A";

  if (value is num) {
    return value.toDouble().toString();
  }

  final ratingValue = value
      .toString()
      .trim();

  if (ratingValue.isEmpty) {
    return "N/A";
  }

  return ratingValue;
}