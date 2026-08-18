class DisplayFavouriteModel {
  final int id;
  final int user;
  final int? playlist;
  final int? video;
  final FavouritePlaylistDetail? playlistDetail;
  final FavouriteVideoDetail? videoDetail;
  final DateTime? createdAt;

  DisplayFavouriteModel({
    required this.id,
    required this.user,
    this.playlist,
    this.video,
    this.playlistDetail,
    this.videoDetail,
    this.createdAt,
  });

  factory DisplayFavouriteModel.fromJson(Map<String, dynamic> json) {
    return DisplayFavouriteModel(
      id: _toInt(json['id']),
      user: _toInt(json['user']),
      playlist: _toNullableInt(json['playlist']),
      video: _toNullableInt(json['video']),
      playlistDetail: json['playlist_detail'] is Map<String, dynamic>
          ? FavouritePlaylistDetail.fromJson(json['playlist_detail'])
          : null,
      videoDetail: json['video_detail'] is Map<String, dynamic>
          ? FavouriteVideoDetail.fromJson(json['video_detail'])
          : null,
      createdAt: _toDateTime(json['created_at']),
    );
  }

  /// لأن الـ API يرجع List مباشرة
  static List<DisplayFavouriteModel> fromJsonList(dynamic data) {
    if (data is! List) {
      return [];
    }

    return data
        .whereType<Map<String, dynamic>>()
        .map((item) => DisplayFavouriteModel.fromJson(item))
        .toList();
  }
}

// ======================================================
// PLAYLIST DETAIL
// ======================================================

class FavouritePlaylistDetail {
  final int id;
  final String name;
  final String description;
  final int owner;
  final String category;
  final int? subject;
  final FavouriteSubjectDetail? subjectDetail;
  final String thumbnail;
  final String price;
  final int totalVideoCount;
  final double totalDuration;
  final int studentsCount;

  final dynamic completionRate;
  final dynamic rating;
  final dynamic hasUserRating;
  final dynamic userRating;
  final dynamic hasSubscription;
  final dynamic hasActiveSubscription;
  final dynamic canAccessContent;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  FavouritePlaylistDetail({
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
    required this.totalDuration,
    required this.studentsCount,
    this.completionRate,
    this.rating,
    this.hasUserRating,
    this.userRating,
    this.hasSubscription,
    this.hasActiveSubscription,
    this.canAccessContent,
    this.createdAt,
    this.updatedAt,
  });

  factory FavouritePlaylistDetail.fromJson(Map<String, dynamic> json) {
    return FavouritePlaylistDetail(
      id: _toInt(json['id']),
      name: _toString(json['name']),
      description: _toString(json['description']),
      owner: _toInt(json['owner']),
      category: _toString(json['category']),
      subject: _toNullableInt(json['subject']),
      subjectDetail: json['subject_detail'] is Map<String, dynamic>
          ? FavouriteSubjectDetail.fromJson(json['subject_detail'])
          : null,
      thumbnail: _toString(json['thumbnail']),
      price: _toString(json['price']),
      totalVideoCount: _toInt(json['total_video_count']),
      totalDuration: _toDouble(json['total_duration']),
      studentsCount: _toInt(json['students_count']),
      completionRate: json['completion_rate'],
      rating: json['rating'],
      hasUserRating: json['has_user_rating'],
      userRating: json['user_rating'],
      hasSubscription: json['has_subscription'],
      hasActiveSubscription: json['has_active_subscription'],
      canAccessContent: json['can_access_content'],
      createdAt: _toDateTime(json['created_at']),
      updatedAt: _toDateTime(json['updated_at']),
    );
  }
}

// ======================================================
// SUBJECT DETAIL
// ======================================================

class FavouriteSubjectDetail {
  final int id;
  final String name;
  final String slug;
  final int? category;
  final FavouriteCategoryDetail? categoryDetail;
  final String description;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  FavouriteSubjectDetail({
    required this.id,
    required this.name,
    required this.slug,
    this.category,
    this.categoryDetail,
    required this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory FavouriteSubjectDetail.fromJson(Map<String, dynamic> json) {
    return FavouriteSubjectDetail(
      id: _toInt(json['id']),
      name: _toString(json['name']),
      slug: _toString(json['slug']),
      category: _toNullableInt(json['category']),
      categoryDetail: json['category_detail'] is Map<String, dynamic>
          ? FavouriteCategoryDetail.fromJson(json['category_detail'])
          : null,
      description: _toString(json['description']),
      createdAt: _toDateTime(json['created_at']),
      updatedAt: _toDateTime(json['updated_at']),
    );
  }
}

// ======================================================
// CATEGORY DETAIL
// ======================================================

class FavouriteCategoryDetail {
  final int id;
  final String name;
  final String slug;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  FavouriteCategoryDetail({
    required this.id,
    required this.name,
    required this.slug,
    this.createdAt,
    this.updatedAt,
  });

  factory FavouriteCategoryDetail.fromJson(Map<String, dynamic> json) {
    return FavouriteCategoryDetail(
      id: _toInt(json['id']),
      name: _toString(json['name']),
      slug: _toString(json['slug']),
      createdAt: _toDateTime(json['created_at']),
      updatedAt: _toDateTime(json['updated_at']),
    );
  }
}

// ======================================================
// VIDEO DETAIL
// ======================================================

class FavouriteVideoDetail {
  final int id;
  final String title;
  final String description;
  final int? playlist;

  /// بالـ Swagger ظاهرة String،
  /// لكن تركناها dynamic حتى ما يضرب التطبيق لو رجعت Object.
  final dynamic playlistDetail;

  final int? owner;
  final dynamic ownerDetail;

  final String videoFile;
  final String thumbnail;
  final double duration;

  /// ممكن يرجع int أو String
  final dynamic views;

  final String status;
  final String approvalStatus;
  final String rejectionReason;
  final String transcript;

  final List<FavouriteAttachment> attachments;

  final int mcqCount;
  final String accessStatus;

  /// ممكن يكون bool أو String حسب الـ backend
  final dynamic canWatch;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  FavouriteVideoDetail({
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
    this.views,
    required this.status,
    required this.approvalStatus,
    required this.rejectionReason,
    required this.transcript,
    required this.attachments,
    required this.mcqCount,
    required this.accessStatus,
    this.canWatch,
    this.createdAt,
    this.updatedAt,
  });

  factory FavouriteVideoDetail.fromJson(Map<String, dynamic> json) {
    return FavouriteVideoDetail(
      id: _toInt(json['id']),
      title: _toString(json['title']),
      description: _toString(json['description']),
      playlist: _toNullableInt(json['playlist']),
      playlistDetail: json['playlist_detail'],
      owner: _toNullableInt(json['owner']),
      ownerDetail: json['owner_detail'],
      videoFile: _toString(json['video_file']),
      thumbnail: _toString(json['thumbnail']),
      duration: _toDouble(json['duration']),
      views: json['views'],
      status: _toString(json['status']),
      approvalStatus: _toString(json['approval_status']),
      rejectionReason: _toString(json['rejection_reason']),
      transcript: _toString(json['transcript']),
      attachments: json['attachments'] is List
          ? (json['attachments'] as List)
          .whereType<Map<String, dynamic>>()
          .map((item) => FavouriteAttachment.fromJson(item))
          .toList()
          : [],
      mcqCount: _toInt(json['mcqCount']),
      accessStatus: _toString(json['access_status']),
      canWatch: json['can_watch'],
      createdAt: _toDateTime(json['created_at']),
      updatedAt: _toDateTime(json['updated_at']),
    );
  }
}

// ======================================================
// ATTACHMENT
// ======================================================

class FavouriteAttachment {
  final int id;
  final String file;
  final String originalName;
  final DateTime? uploadedAt;

  FavouriteAttachment({
    required this.id,
    required this.file,
    required this.originalName,
    this.uploadedAt,
  });

  factory FavouriteAttachment.fromJson(Map<String, dynamic> json) {
    return FavouriteAttachment(
      id: _toInt(json['id']),
      file: _toString(json['file']),
      originalName: _toString(json['original_name']),
      uploadedAt: _toDateTime(json['uploaded_at']),
    );
  }
}

// ======================================================
// HELPERS
// ======================================================

int _toInt(dynamic value) {
  if (value == null) return 0;

  if (value is int) return value;

  if (value is num) return value.toInt();

  return int.tryParse(value.toString()) ?? 0;
}

int? _toNullableInt(dynamic value) {
  if (value == null) return null;

  if (value is int) return value;

  if (value is num) return value.toInt();

  return int.tryParse(value.toString());
}

double _toDouble(dynamic value) {
  if (value == null) return 0.0;

  if (value is double) return value;

  if (value is num) return value.toDouble();

  return double.tryParse(value.toString()) ?? 0.0;
}

String _toString(dynamic value) {
  if (value == null) return '';

  return value.toString();
}

DateTime? _toDateTime(dynamic value) {
  if (value == null) return null;

  return DateTime.tryParse(value.toString());
}