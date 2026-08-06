class SubscriptionModel {
  final int id;
  final int user;
  final UserDetailModel? userDetail;

  final int playlist;
  final PlaylistDetailModel? playlistDetail;

  final TeacherDetailModel? teacherDetail;

  final bool isActive;

  final double pricePaid;
  final double teacherAmount;
  final double adminAmount;

  final String createdAt;
  final String updatedAt;

  const SubscriptionModel({
    required this.id,
    required this.user,
    required this.userDetail,
    required this.playlist,
    required this.playlistDetail,
    required this.teacherDetail,
    required this.isActive,
    required this.pricePaid,
    required this.teacherAmount,
    required this.adminAmount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SubscriptionModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return SubscriptionModel(
      id: JsonParser.toInt(json['id']),
      user: JsonParser.toInt(json['user']),
      userDetail: JsonParser.toMap(json['user_detail']) == null
          ? null
          : UserDetailModel.fromJson(
        JsonParser.toMap(json['user_detail'])!,
      ),
      playlist: JsonParser.toInt(json['playlist']),
      playlistDetail: JsonParser.toMap(
        json['playlist_detail'],
      ) ==
          null
          ? null
          : PlaylistDetailModel.fromJson(
        JsonParser.toMap(
          json['playlist_detail'],
        )!,
      ),
      teacherDetail: JsonParser.toMap(
        json['teacher_detail'],
      ) ==
          null
          ? null
          : TeacherDetailModel.fromJson(
        JsonParser.toMap(
          json['teacher_detail'],
        )!,
      ),
      isActive: JsonParser.toBool(json['is_active']),
      pricePaid: JsonParser.toDouble(json['price_paid']),
      teacherAmount: JsonParser.toDouble(
        json['teacher_amount'],
      ),
      adminAmount: JsonParser.toDouble(
        json['admin_amount'],
      ),
      createdAt: JsonParser.toStringValue(
        json['created_at'],
      ),
      updatedAt: JsonParser.toStringValue(
        json['updated_at'],
      ),
    );
  }

  static List<SubscriptionModel> fromJsonList(
      dynamic data,
      ) {
    if (data is! List) {
      return [];
    }

    return data
        .whereType<Map>()
        .map(
          (item) => SubscriptionModel.fromJson(
        Map<String, dynamic>.from(item),
      ),
    )
        .toList();
  }
}

class UserDetailModel {
  final int id;
  final String email;
  final String name;
  final String firstName;
  final String lastName;
  final String role;
  final String major;

  final List<TeachingClassModel> teachingClasses;

  final String? image;

  const UserDetailModel({
    required this.id,
    required this.email,
    required this.name,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.major,
    required this.teachingClasses,
    required this.image,
  });

  factory UserDetailModel.fromJson(
      Map<String, dynamic> json,
      ) {
    final teachingClassesData =
    JsonParser.toList(json['teaching_classes']);

    return UserDetailModel(
      id: JsonParser.toInt(json['id']),
      email: JsonParser.toStringValue(json['email']),
      name: JsonParser.toStringValue(json['name']),
      firstName: JsonParser.toStringValue(
        json['first_name'],
      ),
      lastName: JsonParser.toStringValue(
        json['last_name'],
      ),
      role: JsonParser.toStringValue(json['role']),
      major: JsonParser.toStringValue(json['major']),
      teachingClasses: teachingClassesData
          .whereType<Map>()
          .map(
            (item) => TeachingClassModel.fromJson(
          Map<String, dynamic>.from(item),
        ),
      )
          .toList(),
      image: JsonParser.toNullableString(json['image']),
    );
  }
}

class TeachingClassModel {
  final int id;
  final String name;

  const TeachingClassModel({
    required this.id,
    required this.name,
  });

  factory TeachingClassModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return TeachingClassModel(
      id: JsonParser.toInt(json['id']),
      name: JsonParser.toStringValue(json['name']),
    );
  }
}

class PlaylistDetailModel {
  final int id;
  final String name;
  final String description;

  final int? owner;

  final String category;
  final int subject;

  final SubjectDetailModel? subjectDetail;

  final String? thumbnail;

  final double price;
  final int totalVideoCount;
  final double totalDuration;
  final int studentsCount;
  final double completionRate;
  final double rating;

  final bool hasSubscription;
  final bool hasActiveSubscription;
  final bool canAccessContent;

  final String createdAt;
  final String updatedAt;

  const PlaylistDetailModel({
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

  factory PlaylistDetailModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return PlaylistDetailModel(
      id: JsonParser.toInt(json['id']),
      name: JsonParser.toStringValue(json['name']),
      description: JsonParser.toStringValue(
        json['description'],
      ),
      owner: JsonParser.toNullableInt(json['owner']),
      category: JsonParser.toStringValue(
        json['category'],
      ),
      subject: JsonParser.toInt(json['subject']),
      subjectDetail: JsonParser.toMap(
        json['subject_detail'],
      ) ==
          null
          ? null
          : SubjectDetailModel.fromJson(
        JsonParser.toMap(
          json['subject_detail'],
        )!,
      ),
      thumbnail: JsonParser.toNullableString(
        json['thumbnail'],
      ),
      price: JsonParser.toDouble(json['price']),
      totalVideoCount: JsonParser.toInt(
        json['total_video_count'],
      ),
      totalDuration: JsonParser.toDouble(
        json['total_duration'],
      ),
      studentsCount: JsonParser.toInt(
        json['students_count'],
      ),
      completionRate: JsonParser.toDouble(
        json['completion_rate'],
      ),
      rating: JsonParser.toDouble(json['rating']),
      hasSubscription: JsonParser.toBool(
        json['has_subscription'],
      ),
      hasActiveSubscription: JsonParser.toBool(
        json['has_active_subscription'],
      ),
      canAccessContent: JsonParser.toBool(
        json['can_access_content'],
      ),
      createdAt: JsonParser.toStringValue(
        json['created_at'],
      ),
      updatedAt: JsonParser.toStringValue(
        json['updated_at'],
      ),
    );
  }
}

class SubjectDetailModel {
  final int id;
  final String name;
  final String slug;

  final int category;
  final CategoryDetailModel? categoryDetail;

  final String description;
  final String createdAt;
  final String updatedAt;

  const SubjectDetailModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.category,
    required this.categoryDetail,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SubjectDetailModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return SubjectDetailModel(
      id: JsonParser.toInt(json['id']),
      name: JsonParser.toStringValue(json['name']),
      slug: JsonParser.toStringValue(json['slug']),
      category: JsonParser.toInt(json['category']),
      categoryDetail: JsonParser.toMap(
        json['category_detail'],
      ) ==
          null
          ? null
          : CategoryDetailModel.fromJson(
        JsonParser.toMap(
          json['category_detail'],
        )!,
      ),
      description: JsonParser.toStringValue(
        json['description'],
      ),
      createdAt: JsonParser.toStringValue(
        json['created_at'],
      ),
      updatedAt: JsonParser.toStringValue(
        json['updated_at'],
      ),
    );
  }
}

class CategoryDetailModel {
  final int id;
  final String name;
  final String slug;
  final String createdAt;
  final String updatedAt;

  const CategoryDetailModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CategoryDetailModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return CategoryDetailModel(
      id: JsonParser.toInt(json['id']),
      name: JsonParser.toStringValue(json['name']),
      slug: JsonParser.toStringValue(json['slug']),
      createdAt: JsonParser.toStringValue(
        json['created_at'],
      ),
      updatedAt: JsonParser.toStringValue(
        json['updated_at'],
      ),
    );
  }
}

class TeacherDetailModel {
  final int id;
  final String name;
  final String email;
  final String? image;

  const TeacherDetailModel({
    required this.id,
    required this.name,
    required this.email,
    required this.image,
  });

  factory TeacherDetailModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return TeacherDetailModel(
      id: JsonParser.toInt(json['id']),
      name: JsonParser.toStringValue(json['name']),
      email: JsonParser.toStringValue(json['email']),
      image: JsonParser.toNullableString(json['image']),
    );
  }
}

class JsonParser {
  const JsonParser._();

  static int toInt(
      dynamic value, {
        int defaultValue = 0,
      }) {
    if (value == null) {
      return defaultValue;
    }

    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(value.toString()) ??
        double.tryParse(value.toString())?.toInt() ??
        defaultValue;
  }

  static int? toNullableInt(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    final text = value.toString().trim();

    if (text.isEmpty || text.toLowerCase() == 'null') {
      return null;
    }

    return int.tryParse(text) ??
        double.tryParse(text)?.toInt();
  }

  static double toDouble(
      dynamic value, {
        double defaultValue = 0.0,
      }) {
    if (value == null) {
      return defaultValue;
    }

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value.toString()) ??
        defaultValue;
  }

  static bool toBool(
      dynamic value, {
        bool defaultValue = false,
      }) {
    if (value == null) {
      return defaultValue;
    }

    if (value is bool) {
      return value;
    }

    if (value is num) {
      return value != 0;
    }

    final text = value.toString().toLowerCase().trim();

    if (text == 'true' ||
        text == '1' ||
        text == 'yes') {
      return true;
    }

    if (text == 'false' ||
        text == '0' ||
        text == 'no') {
      return false;
    }

    return defaultValue;
  }

  static String toStringValue(
      dynamic value, {
        String defaultValue = '',
      }) {
    if (value == null) {
      return defaultValue;
    }

    return value.toString();
  }

  static String? toNullableString(dynamic value) {
    if (value == null) {
      return null;
    }

    final text = value.toString().trim();

    if (text.isEmpty || text.toLowerCase() == 'null') {
      return null;
    }

    return text;
  }

  static Map<String, dynamic>? toMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }

    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    return null;
  }

  static List<dynamic> toList(dynamic value) {
    if (value is List) {
      return value;
    }

    return [];
  }
}