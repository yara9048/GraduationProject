import 'dart:convert';

VideoDetailsModel videoDetailsModelFromJson(String str) {
  return VideoDetailsModel.fromJson(
    json.decode(str) as Map<String, dynamic>,
  );
}

String videoDetailsModelToJson(VideoDetailsModel data) {
  return json.encode(data.toJson());
}

class VideoDetailsModel {
  final int id;
  final String title;
  final String description;

  final int playlist;
  final PlaylistDetail? playlistDetail;

  final int owner;
  final OwnerDetail? ownerDetail;

  final String? videoFile;
  final String? thumbnail;

  final double duration;
  final int views;

  final String status;
  final String approvalStatus;
  final String rejectionReason;
  final String transcript;

  final List<VideoAttachment> attachments;

  final int mcqCount;
  final String accessStatus;
  final String userStatus;
  final bool canWatch;
  final bool isFavourite;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  const VideoDetailsModel({
    required this.id,
    required this.title,
    required this.description,
    required this.playlist,
    required this.playlistDetail,
    required this.owner,
    required this.ownerDetail,
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
    required this.userStatus,
    required this.canWatch,
    required this.isFavourite,
    required this.createdAt,
    required this.updatedAt,
  });

  factory VideoDetailsModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return VideoDetailsModel(
      id: _parseInt(
        json['id'],
      ),

      title:
      json['title']?.toString() ?? '',

      description:
      json['description']?.toString() ?? '',

      playlist: _parseInt(
        json['playlist'],
      ),

      playlistDetail:
      json['playlist_detail'] is Map<String, dynamic>
          ? PlaylistDetail.fromJson(
        json['playlist_detail'],
      )
          : null,

      owner: _parseInt(
        json['owner'],
      ),

      ownerDetail:
      json['owner_detail'] is Map<String, dynamic>
          ? OwnerDetail.fromJson(
        json['owner_detail'],
      )
          : null,

      videoFile: _parseNullableString(
        json['video_file'],
      ),

      thumbnail: _parseNullableString(
        json['thumbnail'],
      ),

      duration: _parseDouble(
        json['duration'],
      ),

      views: _parseInt(
        json['views'],
      ),

      status:
      json['status']?.toString() ?? '',

      approvalStatus:
      json['approval_status']?.toString() ?? '',

      rejectionReason:
      json['rejection_reason']?.toString() ?? '',

      transcript:
      json['transcript']?.toString() ?? '',

      attachments:
      (json['attachments'] as List<dynamic>?)
          ?.whereType<Map<String, dynamic>>()
          .map(VideoAttachment.fromJson)
          .toList() ??
          [],

      mcqCount: _parseInt(
        json['mcqCount'] ??
            json['mcq_count'],
      ),

      accessStatus:
      json['access_status']?.toString() ?? '',

      userStatus:
      json['user_status']?.toString() ?? '',

      canWatch: _parseBool(
        json['can_watch'],
      ),

      isFavourite: _parseBool(
        json['is_favourite'],
      ),

      createdAt: _parseDateTime(
        json['created_at'],
      ),

      updatedAt: _parseDateTime(
        json['updated_at'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,

      'playlist': playlist,
      'playlist_detail':
      playlistDetail?.toJson(),

      'owner': owner,
      'owner_detail':
      ownerDetail?.toJson(),

      'video_file': videoFile,
      'thumbnail': thumbnail,

      'duration': duration,
      'views': views,

      'status': status,
      'approval_status': approvalStatus,
      'rejection_reason': rejectionReason,
      'transcript': transcript,

      'attachments': attachments
          .map(
            (e) => e.toJson(),
      )
          .toList(),

      'mcqCount': mcqCount,

      'access_status': accessStatus,
      'user_status': userStatus,
      'can_watch': canWatch,
      'is_favourite': isFavourite,

      'created_at':
      createdAt?.toIso8601String(),

      'updated_at':
      updatedAt?.toIso8601String(),
    };
  }

  static int _parseInt(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is double) {
      return value.toInt();
    }

    return int.tryParse(
      value?.toString() ?? '',
    ) ??
        0;
  }

  static double _parseDouble(dynamic value) {
    if (value is double) {
      return value;
    }

    if (value is int) {
      return value.toDouble();
    }

    return double.tryParse(
      value?.toString() ?? '',
    ) ??
        0.0;
  }

  static bool _parseBool(dynamic value) {
    if (value is bool) {
      return value;
    }

    if (value is int) {
      return value == 1;
    }

    final String cleanedValue =
        value
            ?.toString()
            .trim()
            .toLowerCase() ??
            '';

    return cleanedValue == 'true' ||
        cleanedValue == '1';
  }

  static String? _parseNullableString(
      dynamic value,
      ) {
    if (value == null) {
      return null;
    }

    final String cleanedValue =
    value.toString().trim();

    if (cleanedValue.isEmpty ||
        cleanedValue.toLowerCase() ==
            'null') {
      return null;
    }

    return cleanedValue;
  }

  static DateTime? _parseDateTime(
      dynamic value,
      ) {
    if (value == null) {
      return null;
    }

    return DateTime.tryParse(
      value.toString(),
    );
  }
}

class PlaylistDetail {
  final int id;
  final String name;

  const PlaylistDetail({
    required this.id,
    required this.name,
  });

  factory PlaylistDetail.fromJson(
      Map<String, dynamic> json,
      ) {
    return PlaylistDetail(
      id: VideoDetailsModel._parseInt(
        json['id'],
      ),
      name:
      json['name']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class OwnerDetail {
  final int id;
  final String name;
  final String email;
  final String? image;

  const OwnerDetail({
    required this.id,
    required this.name,
    required this.email,
    required this.image,
  });

  factory OwnerDetail.fromJson(
      Map<String, dynamic> json,
      ) {
    return OwnerDetail(
      id: VideoDetailsModel._parseInt(
        json['id'],
      ),

      name:
      json['name']?.toString() ?? '',

      email:
      json['email']?.toString() ?? '',

      image:
      VideoDetailsModel._parseNullableString(
        json['image'],
      ),
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

class VideoAttachment {
  final int id;
  final String file;
  final String originalName;
  final DateTime? uploadedAt;

  const VideoAttachment({
    required this.id,
    required this.file,
    required this.originalName,
    required this.uploadedAt,
  });

  factory VideoAttachment.fromJson(
      Map<String, dynamic> json,
      ) {
    return VideoAttachment(
      id: VideoDetailsModel._parseInt(
        json['id'],
      ),

      file:
      json['file']?.toString() ?? '',

      originalName:
      json['original_name']
          ?.toString() ??
          '',

      uploadedAt:
      VideoDetailsModel._parseDateTime(
        json['uploaded_at'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'file': file,
      'original_name': originalName,
      'uploaded_at':
      uploadedAt?.toIso8601String(),
    };
  }
}