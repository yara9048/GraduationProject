import 'dart:convert';

List<NowShowingPlaylistModel> nowShowingPlaylistModelFromJson(String str) {
  final data = json.decode(str);

  if (data is! List) {
    return [];
  }

  return data
      .whereType<Map<String, dynamic>>()
      .map((x) => NowShowingPlaylistModel.fromJson(x))
      .toList();
}

String nowShowingPlaylistModelToJson(
    List<NowShowingPlaylistModel> data,
    ) =>
    json.encode(
      List<dynamic>.from(data.map((x) => x.toJson())),
    );

// ======================================================
// MAIN MODEL
// ======================================================

class NowShowingPlaylistModel {
  final int id;
  final int user;
  final int video;

  final NowShowingVideoDetail videoDetail;
  final NowShowingCourseDetail courseDetail;

  final int progressSeconds;
  final double progressPercentage;
  final bool isCompleted;
  final DateTime? lastWatchedAt;

  const NowShowingPlaylistModel({
    required this.id,
    required this.user,
    required this.video,
    required this.videoDetail,
    required this.courseDetail,
    required this.progressSeconds,
    required this.progressPercentage,
    required this.isCompleted,
    this.lastWatchedAt,
  });

  factory NowShowingPlaylistModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return NowShowingPlaylistModel(
      id: _toInt(json['id']),
      user: _toInt(json['user']),
      video: _toInt(json['video']),
      videoDetail: NowShowingVideoDetail.fromJson(
        _toMap(json['video_detail']),
      ),
      courseDetail: NowShowingCourseDetail.fromJson(
        _toMap(json['course_detail']),
      ),
      progressSeconds: _toInt(json['progress_seconds']),
      progressPercentage: _toDouble(
        json['progress_percentage'],
      ),
      isCompleted: _toBool(json['is_completed']),
      lastWatchedAt: _toDateTime(json['last_watched_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user,
      'video': video,
      'video_detail': videoDetail.toJson(),
      'course_detail': courseDetail.toJson(),
      'progress_seconds': progressSeconds,
      'progress_percentage': progressPercentage,
      'is_completed': isCompleted,
      'last_watched_at': lastWatchedAt?.toIso8601String(),
    };
  }
}

// ======================================================
// COURSE DETAIL
// ======================================================

class NowShowingCourseDetail {
  final int id;
  final String name;
  final String description;
  final int owner;
  final String category;
  final int? subject;

  final NowShowingSubjectDetail? subjectDetail;

  final String thumbnail;
  final String price;

  final int totalVideoCount;

  /// ممكن ترجع int أو double أو null
  final double? totalDuration;

  final int studentsCount;

  /// ممكن ترجع int أو double أو string أو null
  final double? completionRate;

  /// ممكن ترجع int أو double أو string أو null
  final double? rating;

  final bool hasUserRating;

  /// ممكن يكون null إذا المستخدم ما قيّم
  final double? userRating;

  final bool hasSubscription;
  final bool hasActiveSubscription;
  final bool canAccessContent;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  const NowShowingCourseDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.owner,
    required this.category,
    this.subject,
    this.subjectDetail,
    required this.thumbnail,
    required this.price,
    required this.totalVideoCount,
    this.totalDuration,
    required this.studentsCount,
    this.completionRate,
    this.rating,
    required this.hasUserRating,
    this.userRating,
    required this.hasSubscription,
    required this.hasActiveSubscription,
    required this.canAccessContent,
    this.createdAt,
    this.updatedAt,
  });

  factory NowShowingCourseDetail.fromJson(
      Map<String, dynamic> json,
      ) {
    return NowShowingCourseDetail(
      id: _toInt(json['id']),
      name: _toString(json['name']),
      description: _toString(json['description']),
      owner: _toInt(json['owner']),
      category: _toString(json['category']),
      subject: _toNullableInt(json['subject']),
      subjectDetail: json['subject_detail'] is Map
          ? NowShowingSubjectDetail.fromJson(
        _toMap(json['subject_detail']),
      )
          : null,
      thumbnail: _toString(json['thumbnail']),
      price: _toString(json['price']),
      totalVideoCount: _toInt(json['total_video_count']),
      totalDuration: _toNullableDouble(
        json['total_duration'],
      ),
      studentsCount: _toInt(json['students_count']),
      completionRate: _toNullableDouble(
        json['completion_rate'],
      ),
      rating: _toNullableDouble(json['rating']),
      hasUserRating: _toBool(json['has_user_rating']),
      userRating: _toNullableDouble(json['user_rating']),
      hasSubscription: _toBool(
        json['has_subscription'],
      ),
      hasActiveSubscription: _toBool(
        json['has_active_subscription'],
      ),
      canAccessContent: _toBool(
        json['can_access_content'],
      ),
      createdAt: _toDateTime(json['created_at']),
      updatedAt: _toDateTime(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'owner': owner,
      'category': category,
      'subject': subject,
      'subject_detail': subjectDetail?.toJson(),
      'thumbnail': thumbnail,
      'price': price,
      'total_video_count': totalVideoCount,
      'total_duration': totalDuration,
      'students_count': studentsCount,
      'completion_rate': completionRate,
      'rating': rating,
      'has_user_rating': hasUserRating,
      'user_rating': userRating,
      'has_subscription': hasSubscription,
      'has_active_subscription': hasActiveSubscription,
      'can_access_content': canAccessContent,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

// ======================================================
// SUBJECT DETAIL
// ======================================================

class NowShowingSubjectDetail {
  final int id;
  final String name;
  final String slug;
  final int? category;

  final NowShowingCategoryDetail? categoryDetail;

  final String description;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const NowShowingSubjectDetail({
    required this.id,
    required this.name,
    required this.slug,
    this.category,
    this.categoryDetail,
    required this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory NowShowingSubjectDetail.fromJson(
      Map<String, dynamic> json,
      ) {
    return NowShowingSubjectDetail(
      id: _toInt(json['id']),
      name: _toString(json['name']),
      slug: _toString(json['slug']),
      category: _toNullableInt(json['category']),
      categoryDetail: json['category_detail'] is Map
          ? NowShowingCategoryDetail.fromJson(
        _toMap(json['category_detail']),
      )
          : null,
      description: _toString(json['description']),
      createdAt: _toDateTime(json['created_at']),
      updatedAt: _toDateTime(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'category': category,
      'category_detail': categoryDetail?.toJson(),
      'description': description,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

// ======================================================
// CATEGORY DETAIL
// ======================================================

class NowShowingCategoryDetail {
  final int id;
  final String name;
  final String slug;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const NowShowingCategoryDetail({
    required this.id,
    required this.name,
    required this.slug,
    this.createdAt,
    this.updatedAt,
  });

  factory NowShowingCategoryDetail.fromJson(
      Map<String, dynamic> json,
      ) {
    return NowShowingCategoryDetail(
      id: _toInt(json['id']),
      name: _toString(json['name']),
      slug: _toString(json['slug']),
      createdAt: _toDateTime(json['created_at']),
      updatedAt: _toDateTime(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

// ======================================================
// VIDEO DETAIL
// ======================================================

class NowShowingVideoDetail {
  final int id;
  final String title;
  final String description;

  final int? playlist;
  final NowShowingPlaylistDetail? playlistDetail;

  final int? owner;
  final NowShowingOwnerDetail? ownerDetail;

  final String videoFile;
  final String thumbnail;

  /// ممكن int أو double
  final double duration;

  final int views;

  final String status;
  final String approvalStatus;
  final String rejectionReason;
  final String transcript;

  final List<NowShowingAttachment> attachments;

  final int mcqCount;

  final String accessStatus;
  final bool canWatch;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  const NowShowingVideoDetail({
    required this.id,
    required this.title,
    required this.description,
    this.playlist,
    this.playlistDetail,
    this.owner,
    this.ownerDetail,
    required this.videoFile,
    required this.thumbnail,
    required this.duration,
    required this.views,
    required this.status,
    required this.approvalStatus,
    required this.rejectionReason,
    required this.transcript,
    required this.attachments,
    required this.mcqCount,
    required this.accessStatus,
    required this.canWatch,
    this.createdAt,
    this.updatedAt,
  });

  factory NowShowingVideoDetail.fromJson(
      Map<String, dynamic> json,
      ) {
    return NowShowingVideoDetail(
      id: _toInt(json['id']),
      title: _toString(json['title']),
      description: _toString(json['description']),
      playlist: _toNullableInt(json['playlist']),
      playlistDetail: json['playlist_detail'] is Map
          ? NowShowingPlaylistDetail.fromJson(
        _toMap(json['playlist_detail']),
      )
          : null,
      owner: _toNullableInt(json['owner']),
      ownerDetail: json['owner_detail'] is Map
          ? NowShowingOwnerDetail.fromJson(
        _toMap(json['owner_detail']),
      )
          : null,
      videoFile: _toString(json['video_file']),
      thumbnail: _toString(json['thumbnail']),
      duration: _toDouble(json['duration']),
      views: _toInt(json['views']),
      status: _toString(json['status']),
      approvalStatus: _toString(
        json['approval_status'],
      ),
      rejectionReason: _toString(
        json['rejection_reason'],
      ),
      transcript: _toString(json['transcript']),
      attachments: _parseAttachments(
        json['attachments'],
      ),
      mcqCount: _toInt(json['mcqCount']),
      accessStatus: _toString(
        json['access_status'],
      ),
      canWatch: _toBool(json['can_watch']),
      createdAt: _toDateTime(json['created_at']),
      updatedAt: _toDateTime(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'playlist': playlist,
      'playlist_detail': playlistDetail?.toJson(),
      'owner': owner,
      'owner_detail': ownerDetail?.toJson(),
      'video_file': videoFile,
      'thumbnail': thumbnail,
      'duration': duration,
      'views': views,
      'status': status,
      'approval_status': approvalStatus,
      'rejection_reason': rejectionReason,
      'transcript': transcript,
      'attachments': attachments
          .map((x) => x.toJson())
          .toList(),
      'mcqCount': mcqCount,
      'access_status': accessStatus,
      'can_watch': canWatch,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

// ======================================================
// ATTACHMENT
// ======================================================

class NowShowingAttachment {
  final int id;
  final String file;
  final String originalName;
  final DateTime? uploadedAt;

  const NowShowingAttachment({
    required this.id,
    required this.file,
    required this.originalName,
    this.uploadedAt,
  });

  factory NowShowingAttachment.fromJson(
      Map<String, dynamic> json,
      ) {
    return NowShowingAttachment(
      id: _toInt(json['id']),
      file: _toString(json['file']),
      originalName: _toString(
        json['original_name'],
      ),
      uploadedAt: _toDateTime(
        json['uploaded_at'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'file': file,
      'original_name': originalName,
      'uploaded_at': uploadedAt?.toIso8601String(),
    };
  }
}

// ======================================================
// OWNER DETAIL
// ======================================================

class NowShowingOwnerDetail {
  final int id;
  final String name;
  final String email;
  final String image;

  const NowShowingOwnerDetail({
    required this.id,
    required this.name,
    required this.email,
    required this.image,
  });

  factory NowShowingOwnerDetail.fromJson(
      Map<String, dynamic> json,
      ) {
    return NowShowingOwnerDetail(
      id: _toInt(json['id']),
      name: _toString(json['name']),
      email: _toString(json['email']),
      image: _toString(json['image']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'image': image,
    };
  }
}

// ======================================================
// PLAYLIST DETAIL INSIDE VIDEO
// ======================================================

class NowShowingPlaylistDetail {
  final int id;
  final String name;

  const NowShowingPlaylistDetail({
    required this.id,
    required this.name,
  });

  factory NowShowingPlaylistDetail.fromJson(
      Map<String, dynamic> json,
      ) {
    return NowShowingPlaylistDetail(
      id: _toInt(json['id']),
      name: _toString(json['name']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

// ======================================================
// HELPERS
// ======================================================

Map<String, dynamic> _toMap(dynamic value) {
  if (value is Map<String, dynamic>) {
    return value;
  }

  if (value is Map) {
    return Map<String, dynamic>.from(value);
  }

  return <String, dynamic>{};
}

int _toInt(dynamic value) {
  if (value == null) return 0;

  if (value is int) return value;

  if (value is num) return value.toInt();

  return int.tryParse(
    value.toString(),
  ) ??
      0;
}

int? _toNullableInt(dynamic value) {
  if (value == null) return null;

  if (value is int) return value;

  if (value is num) return value.toInt();

  return int.tryParse(
    value.toString(),
  );
}

double _toDouble(dynamic value) {
  if (value == null) return 0.0;

  if (value is num) {
    return value.toDouble();
  }

  return double.tryParse(
    value.toString(),
  ) ??
      0.0;
}

double? _toNullableDouble(dynamic value) {
  if (value == null) return null;

  if (value is num) {
    return value.toDouble();
  }

  return double.tryParse(
    value.toString(),
  );
}

String _toString(dynamic value) {
  if (value == null) return '';

  return value.toString();
}

bool _toBool(dynamic value) {
  if (value == null) return false;

  if (value is bool) {
    return value;
  }

  if (value is num) {
    return value != 0;
  }

  final stringValue =
  value.toString().toLowerCase().trim();

  return stringValue == 'true' ||
      stringValue == '1';
}

DateTime? _toDateTime(dynamic value) {
  if (value == null) return null;

  return DateTime.tryParse(
    value.toString(),
  );
}

List<NowShowingAttachment> _parseAttachments(
    dynamic value,
    ) {
  if (value is! List) {
    return [];
  }

  return value
      .whereType<Map>()
      .map(
        (item) => NowShowingAttachment.fromJson(
      Map<String, dynamic>.from(item),
    ),
  )
      .toList();
}