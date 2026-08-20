import 'dart:convert';

List<DisplayVideosModel> displayVideosModelFromJson(
    String str,
    ) {
  final decodedData =
  json.decode(str) as List<dynamic>;

  return decodedData
      .map(
        (item) =>
        DisplayVideosModel.fromJson(
          item as Map<String, dynamic>,
        ),
  )
      .toList();
}

String displayVideosModelToJson(
    List<DisplayVideosModel> data,
    ) {
  return json.encode(
    data.map((item) => item.toJson()).toList(),
  );
}

class DisplayVideosModel {
  final int id;
  final String title;
  final String description;

  final int playlist;
  final DisplayPlaylistDetail? playlistDetail;

  final int owner;
  final DisplayOwnerDetail? ownerDetail;

  final String? videoFile;
  final String? thumbnail;

  final double duration;
  final int views;

  final String status;
  final String approvalStatus;
  final String rejectionReason;
  final String transcript;

  final List<DisplayVideoAttachment> attachments;

  final int mcqCount;

  final String accessStatus;
  final String userStatus;

  final bool canWatch;
  final bool isFavourite;

  final DateTime createdAt;
  final DateTime updatedAt;

  const DisplayVideosModel({
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

  factory DisplayVideosModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return DisplayVideosModel(
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
      json['playlist_detail']
      is Map<String, dynamic>
          ? DisplayPlaylistDetail.fromJson(
        json['playlist_detail'],
      )
          : null,

      owner: _parseInt(
        json['owner'],
      ),

      ownerDetail:
      json['owner_detail']
      is Map<String, dynamic>
          ? DisplayOwnerDetail.fromJson(
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
      json['approval_status']
          ?.toString() ??
          '',

      rejectionReason:
      json['rejection_reason']
          ?.toString() ??
          '',

      transcript:
      json['transcript']?.toString() ?? '',

      attachments:
      (json['attachments']
      as List<dynamic>?)
          ?.whereType<
          Map<String, dynamic>>()
          .map(
        DisplayVideoAttachment
            .fromJson,
      )
          .toList() ??
          [],

      mcqCount: _parseInt(
        json['mcqCount'] ??
            json['mcq_count'],
      ),

      accessStatus:
      json['access_status']
          ?.toString() ??
          '',

      userStatus:
      json['user_status']
          ?.toString() ??
          '',

      canWatch: _parseBool(
        json['can_watch'],
      ),

      isFavourite: _parseBool(
        json['is_favourite'],
      ),

      createdAt:
      _parseDateTime(
        json['created_at'],
      ) ??
          DateTime.fromMillisecondsSinceEpoch(
            0,
          ),

      updatedAt:
      _parseDateTime(
        json['updated_at'],
      ) ??
          DateTime.fromMillisecondsSinceEpoch(
            0,
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
      'approval_status':
      approvalStatus,
      'rejection_reason':
      rejectionReason,
      'transcript': transcript,

      'attachments': attachments
          .map(
            (item) => item.toJson(),
      )
          .toList(),

      'mcqCount': mcqCount,

      'access_status':
      accessStatus,

      'user_status':
      userStatus,

      'can_watch':
      canWatch,

      'is_favourite':
      isFavourite,

      'created_at':
      createdAt.toIso8601String(),

      'updated_at':
      updatedAt.toIso8601String(),
    };
  }

  static int _parseInt(
      dynamic value,
      ) {
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

  static double _parseDouble(
      dynamic value,
      ) {
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

  static bool _parseBool(
      dynamic value,
      ) {
    if (value is bool) {
      return value;
    }

    if (value is int) {
      return value == 1;
    }

    final cleanedValue =
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

    final cleanedValue =
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

class DisplayPlaylistDetail {
  final int id;
  final String name;

  const DisplayPlaylistDetail({
    required this.id,
    required this.name,
  });

  factory DisplayPlaylistDetail.fromJson(
      Map<String, dynamic> json,
      ) {
    return DisplayPlaylistDetail(
      id: DisplayVideosModel._parseInt(
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

class DisplayOwnerDetail {
  final int id;
  final String name;
  final String email;
  final String? image;

  const DisplayOwnerDetail({
    required this.id,
    required this.name,
    required this.email,
    required this.image,
  });

  factory DisplayOwnerDetail.fromJson(
      Map<String, dynamic> json,
      ) {
    return DisplayOwnerDetail(
      id: DisplayVideosModel._parseInt(
        json['id'],
      ),

      name:
      json['name']?.toString() ?? '',

      email:
      json['email']?.toString() ?? '',

      image:
      DisplayVideosModel
          ._parseNullableString(
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

class DisplayVideoAttachment {
  final int id;
  final String file;
  final String originalName;
  final DateTime? uploadedAt;

  const DisplayVideoAttachment({
    required this.id,
    required this.file,
    required this.originalName,
    required this.uploadedAt,
  });

  factory DisplayVideoAttachment.fromJson(
      Map<String, dynamic> json,
      ) {
    return DisplayVideoAttachment(
      id: DisplayVideosModel._parseInt(
        json['id'],
      ),

      file:
      json['file']?.toString() ?? '',

      originalName:
      json['original_name']
          ?.toString() ??
          '',

      uploadedAt:
      DisplayVideosModel
          ._parseDateTime(
        json['uploaded_at'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'file': file,
      'original_name':
      originalName,
      'uploaded_at':
      uploadedAt?.toIso8601String(),
    };
  }
}