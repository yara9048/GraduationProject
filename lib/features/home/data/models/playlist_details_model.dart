import 'dart:convert';

PlayListDetailsModel playListDetailsModelFromJson(
    String str,
    ) {
  try {
    final dynamic decodedData =
    json.decode(str);

    if (decodedData
    is! Map<String, dynamic>) {
      throw const FormatException(
        'Playlist details response is not a JSON object',
      );
    }

    return PlayListDetailsModel.fromJson(
      decodedData,
    );
  } on FormatException {
    rethrow;
  } catch (e) {
    throw FormatException(
      'Failed to parse playlist details: $e',
    );
  }
}

String playListDetailsModelToJson(
    PlayListDetailsModel data,
    ) {
  return json.encode(
    data.toJson(),
  );
}

class PlayListDetailsModel {
  final int id;
  final String name;
  final String description;
  final dynamic owner;
  final String category;
  final int subject;
  final SubjectDetail? subjectDetail;
  final String? thumbnail;
  final String price;

  final int totalVideoCount;
  final double? totalDuration;
  final int studentsCount;
  final double completionRate;

  // التقييم العام للقائمة
  final double? rating;

  // تقييم المستخدم الحالي
  final bool hasUserRating;
  final double? userRating;

  final bool hasSubscription;
  final bool hasActiveSubscription;
  final bool canAccessContent;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  const PlayListDetailsModel({
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

  factory PlayListDetailsModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return PlayListDetailsModel(
      id: _parseInt(
        json['id'],
      ),
      name: _parseString(
        json['name'],
      ),
      description: _parseString(
        json['description'],
      ),
      owner: json['owner'],
      category: _parseString(
        json['category'],
      ),
      subject: _parseInt(
        json['subject'],
      ),
      subjectDetail:
      _parseSubjectDetail(
        json['subject_detail'],
      ),
      thumbnail:
      _parseNullableString(
        json['thumbnail'],
      ),
      price: _parsePrice(
        json['price'],
      ),
      totalVideoCount:
      _parseInt(
        json['total_video_count'],
      ),
      totalDuration:
      _parseNullableDouble(
        json['total_duration'],
      ),
      studentsCount:
      _parseInt(
        json['students_count'],
      ),
      completionRate:
      _parseDouble(
        json['completion_rate'],
      ),

      rating:
      _parseNullableDouble(
        json['rating'],
      ),

      hasUserRating:
      _parseBool(
        json['has_user_rating'],
      ),

      userRating:
      _parseNullableDouble(
        json['user_rating'],
      ),

      hasSubscription:
      _parseBool(
        json['has_subscription'],
      ),
      hasActiveSubscription:
      _parseBool(
        json['has_active_subscription'],
      ),
      canAccessContent:
      _parseBool(
        json['can_access_content'],
      ),

      createdAt:
      _parseDateTime(
        json['created_at'],
      ),
      updatedAt:
      _parseDateTime(
        json['updated_at'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description':
      description,
      'owner': owner,
      'category': category,
      'subject': subject,
      'subject_detail':
      subjectDetail
          ?.toJson(),
      'thumbnail':
      thumbnail,
      'price': price,
      'total_video_count':
      totalVideoCount,
      'total_duration':
      totalDuration,
      'students_count':
      studentsCount,
      'completion_rate':
      completionRate,

      'rating': rating,
      'has_user_rating':
      hasUserRating,
      'user_rating':
      userRating,

      'has_subscription':
      hasSubscription,
      'has_active_subscription':
      hasActiveSubscription,
      'can_access_content':
      canAccessContent,

      'created_at':
      createdAt
          ?.toIso8601String(),
      'updated_at':
      updatedAt
          ?.toIso8601String(),
    };
  }
}

class SubjectDetail {
  final int id;
  final String name;
  final String slug;
  final int category;
  final CategoryDetail?
  categoryDetail;
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
    return SubjectDetail(
      id: _parseInt(
        json['id'],
      ),
      name: _parseString(
        json['name'],
      ),
      slug: _parseString(
        json['slug'],
      ),
      category: _parseInt(
        json['category'],
      ),
      categoryDetail:
      _parseCategoryDetail(
        json['category_detail'],
      ),
      description:
      _parseString(
        json['description'],
      ),
      createdAt:
      _parseDateTime(
        json['created_at'],
      ),
      updatedAt:
      _parseDateTime(
        json['updated_at'],
      ),
    );
  }

  Map<String, dynamic>
  toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'category':
      category,
      'category_detail':
      categoryDetail
          ?.toJson(),
      'description':
      description,
      'created_at':
      createdAt
          ?.toIso8601String(),
      'updated_at':
      updatedAt
          ?.toIso8601String(),
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
    return CategoryDetail(
      id: _parseInt(
        json['id'],
      ),
      name: _parseString(
        json['name'],
      ),
      slug: _parseString(
        json['slug'],
      ),
      createdAt:
      _parseDateTime(
        json['created_at'],
      ),
      updatedAt:
      _parseDateTime(
        json['updated_at'],
      ),
    );
  }

  Map<String, dynamic>
  toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'created_at':
      createdAt
          ?.toIso8601String(),
      'updated_at':
      updatedAt
          ?.toIso8601String(),
    };
  }
}

SubjectDetail?
_parseSubjectDetail(
    dynamic value,
    ) {
  if (value
  is Map<String, dynamic>) {
    return SubjectDetail
        .fromJson(value);
  }

  if (value is Map) {
    return SubjectDetail
        .fromJson(
      Map<String, dynamic>
          .from(value),
    );
  }

  return null;
}

CategoryDetail?
_parseCategoryDetail(
    dynamic value,
    ) {
  if (value
  is Map<String, dynamic>) {
    return CategoryDetail
        .fromJson(value);
  }

  if (value is Map) {
    return CategoryDetail
        .fromJson(
      Map<String, dynamic>
          .from(value),
    );
  }

  return null;
}

int _parseInt(
    dynamic value,
    ) {
  if (value == null) {
    return 0;
  }

  if (value is int) {
    return value;
  }

  if (value is num) {
    return value.toInt();
  }

  return int.tryParse(
    value
        .toString()
        .trim(),
  ) ??
      double.tryParse(
        value
            .toString()
            .trim(),
      )?.toInt() ??
      0;
}

double _parseDouble(
    dynamic value,
    ) {
  if (value == null) {
    return 0.0;
  }

  if (value is num) {
    return value.toDouble();
  }

  return double.tryParse(
    value
        .toString()
        .trim(),
  ) ??
      0.0;
}

double? _parseNullableDouble(
    dynamic value,
    ) {
  if (value == null) {
    return null;
  }

  if (value is num) {
    return value.toDouble();
  }

  final String text =
  value
      .toString()
      .trim();

  if (text.isEmpty ||
      text.toLowerCase() ==
          'null' ||
      text.toUpperCase() ==
          'N/A') {
    return null;
  }

  return double.tryParse(
    text,
  );
}

String _parseString(
    dynamic value,
    ) {
  if (value == null) {
    return '';
  }

  return value.toString();
}

String? _parseNullableString(
    dynamic value,
    ) {
  if (value == null) {
    return null;
  }

  final String text =
  value
      .toString()
      .trim();

  if (text.isEmpty ||
      text.toLowerCase() ==
          'null') {
    return null;
  }

  return text;
}

String _parsePrice(
    dynamic value,
    ) {
  if (value == null) {
    return '0.00';
  }

  if (value is num) {
    return value
        .toDouble()
        .toStringAsFixed(
      2,
    );
  }

  final String text =
  value
      .toString()
      .trim();

  if (text.isEmpty) {
    return '0.00';
  }

  return text;
}

bool _parseBool(
    dynamic value,
    ) {
  if (value == null) {
    return false;
  }

  if (value is bool) {
    return value;
  }

  if (value is num) {
    return value != 0;
  }

  final String text =
  value
      .toString()
      .trim()
      .toLowerCase();

  return text == 'true' ||
      text == '1' ||
      text == 'yes';
}

DateTime? _parseDateTime(
    dynamic value,
    ) {
  if (value == null) {
    return null;
  }

  final String text =
  value
      .toString()
      .trim();

  if (text.isEmpty ||
      text.toLowerCase() ==
          'null') {
    return null;
  }

  return DateTime.tryParse(
    text,
  );
}