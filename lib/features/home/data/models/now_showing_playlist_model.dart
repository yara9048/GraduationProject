import 'dart:convert';

List<NowShowingPlaylistModel> nowShowingPlaylistModelFromJson(String str) {
  final decodedData = json.decode(str);

  if (decodedData is! List) {
    throw FormatException(
      "Expected a list but received ${decodedData.runtimeType}",
    );
  }

  return decodedData
      .map(
        (item) => NowShowingPlaylistModel.fromJson(
      Map<String, dynamic>.from(item),
    ),
  )
      .toList();
}

String nowShowingPlaylistModelToJson(
    List<NowShowingPlaylistModel> data,
    ) {
  return json.encode(
    data.map((item) => item.toJson()).toList(),
  );
}

class NowShowingPlaylistModel {
  final int id;
  final String title;
  final String description;
  final int playlist;
  final int owner;
  final dynamic videoFile;
  final dynamic thumbnail;
  final double duration;
  final int views;
  final String status;
  final String approvalStatus;
  final String? rejectionReason;
  final String? transcript;
  final int mcqCount;
  final String accessStatus;
  final bool canWatch;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  NowShowingPlaylistModel({
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

  factory NowShowingPlaylistModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return NowShowingPlaylistModel(
      id: _toInt(json["id"]),
      title: _toStringValue(json["title"]),
      description: _toStringValue(json["description"]),
      playlist: _toInt(json["playlist"]),
      owner: _toInt(json["owner"]),
      videoFile: json["video_file"],
      thumbnail: json["thumbnail"],
      duration: _toDouble(json["duration"]),
      views: _toInt(json["views"]),
      status: _toStringValue(json["status"]),
      approvalStatus: _toStringValue(json["approval_status"]),
      rejectionReason: json["rejection_reason"]?.toString(),
      transcript: json["transcript"]?.toString(),
      mcqCount: _toInt(
        json["mcqCount"] ?? json["mcq_count"],
      ),
      accessStatus: _toStringValue(json["access_status"]),
      canWatch: _toBool(json["can_watch"]),
      createdAt: _toDateTime(json["created_at"]),
      updatedAt: _toDateTime(json["updated_at"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "playlist": playlist,
      "owner": owner,
      "video_file": videoFile,
      "thumbnail": thumbnail,
      "duration": duration,
      "views": views,
      "status": status,
      "approval_status": approvalStatus,
      "rejection_reason": rejectionReason,
      "transcript": transcript,
      "mcqCount": mcqCount,
      "access_status": accessStatus,
      "can_watch": canWatch,
      "created_at": createdAt?.toIso8601String(),
      "updated_at": updatedAt?.toIso8601String(),
    };
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;

    if (value is int) {
      return value;
    }

    if (value is double) {
      return value.toInt();
    }

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

  static String _toStringValue(dynamic value) {
    return value?.toString() ?? "";
  }

  static bool _toBool(dynamic value) {
    if (value is bool) {
      return value;
    }

    if (value is num) {
      return value != 0;
    }

    final stringValue = value?.toString().toLowerCase();

    return stringValue == "true" || stringValue == "1";
  }

  static DateTime? _toDateTime(dynamic value) {
    if (value == null) return null;

    return DateTime.tryParse(value.toString());
  }
}