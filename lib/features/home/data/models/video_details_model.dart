import 'dart:convert';

VideoDetailsModel videoDetailsModelFromJson(
    String str,
    ) {
  return VideoDetailsModel.fromJson(
    json.decode(str) as Map<String, dynamic>,
  );
}

String videoDetailsModelToJson(
    VideoDetailsModel data,
    ) {
  return json.encode(data.toJson());
}

class VideoDetailsModel {
  final int id;
  final String title;
  final String description;
  final int playlist;
  final int owner;

  final String? videoFile;
  final String? thumbnail;

  final double duration;
  final int views;

  final String status;
  final String approvalStatus;
  final String rejectionReason;
  final String transcript;

  final int mcqCount;
  final String accessStatus;
  final bool canWatch;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  const VideoDetailsModel({
    required this.id,
    required this.title,
    required this.description,
    required this.playlist,
    required this.owner,
    required this.videoFile,
    required this.thumbnail,
    required this.duration,
    required this.views,
    required this.status,
    required this.approvalStatus,
    required this.rejectionReason,
    required this.transcript,
    required this.mcqCount,
    required this.accessStatus,
    required this.canWatch,
    required this.createdAt,
    required this.updatedAt,
  });

  factory VideoDetailsModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return VideoDetailsModel(
      id: _parseInt(json['id']),
      title: json['title']?.toString() ?? '',
      description:
      json['description']?.toString() ?? '',
      playlist: _parseInt(json['playlist']),
      owner: _parseInt(json['owner']),

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

      status: json['status']?.toString() ?? '',

      approvalStatus:
      json['approval_status']?.toString() ?? '',

      rejectionReason:
      json['rejection_reason']?.toString() ?? '',

      transcript:
      json['transcript']?.toString() ?? '',

      mcqCount: _parseInt(
        json['mcqCount'] ?? json['mcq_count'],
      ),

      accessStatus:
      json['access_status']?.toString() ?? '',

      canWatch: _parseBool(
        json['can_watch'],
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
      'owner': owner,
      'video_file': videoFile,
      'thumbnail': thumbnail,
      'duration': duration,
      'views': views,
      'status': status,
      'approval_status': approvalStatus,
      'rejection_reason': rejectionReason,
      'transcript': transcript,
      'mcqCount': mcqCount,
      'access_status': accessStatus,
      'can_watch': canWatch,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
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
        value?.toString().trim().toLowerCase() ?? '';

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
        cleanedValue.toLowerCase() == 'null') {
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