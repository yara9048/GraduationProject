import 'dart:convert';

List<DisplayFavouriteModel> displayFavouriteModelFromJson(String str) =>
    List<DisplayFavouriteModel>.from(
      json.decode(str).map((x) => DisplayFavouriteModel.fromJson(x)),
    );

String displayFavouriteModelToJson(List<DisplayFavouriteModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DisplayFavouriteModel {
  int id;
  int user;
  int? playlist;
  int? video;
  PlaylistDetail? playlistDetail;
  VideoDetail? videoDetail;
  DateTime createdAt;

  DisplayFavouriteModel({
    required this.id,
    required this.user,
    required this.playlist,
    required this.video,
    required this.playlistDetail,
    required this.videoDetail,
    required this.createdAt,
  });

  factory DisplayFavouriteModel.fromJson(Map<String, dynamic> json) =>
      DisplayFavouriteModel(
        id: json["id"],
        user: json["user"],
        playlist: json["playlist"],
        video: json["video"],
        playlistDetail: json["playlist_detail"] == null
            ? null
            : PlaylistDetail.fromJson(json["playlist_detail"]),
        videoDetail: json["video_detail"] == null
            ? null
            : VideoDetail.fromJson(json["video_detail"]),
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user": user,
    "playlist": playlist,
    "video": video,
    "playlist_detail": playlistDetail?.toJson(),
    "video_detail": videoDetail?.toJson(),
    "created_at": createdAt.toIso8601String(),
  };
}

class PlaylistDetail {
  int id;
  String name;
  String description;
  String category;
  dynamic thumbnail;
  int totalVideoCount;
  double totalDuration;
  int studentsCount;
  double completionRate;
  String rating;
  DateTime createdAt;
  DateTime updatedAt;

  PlaylistDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.thumbnail,
    required this.totalVideoCount,
    required this.totalDuration,
    required this.studentsCount,
    required this.completionRate,
    required this.rating,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PlaylistDetail.fromJson(Map<String, dynamic> json) =>
      PlaylistDetail(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        category: json["category"],
        thumbnail: json["thumbnail"],
        totalVideoCount: (json["total_video_count"] as num).toInt(),
        totalDuration: (json["total_duration"] as num).toDouble(),
        studentsCount: (json["students_count"] as num).toInt(),
        completionRate: (json["completion_rate"] as num).toDouble(),
        rating: json["rating"].toString(),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "category": category,
    "thumbnail": thumbnail,
    "total_video_count": totalVideoCount,
    "total_duration": totalDuration,
    "students_count": studentsCount,
    "completion_rate": completionRate,
    "rating": rating,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}

class VideoDetail {
  int id;
  String title;
  String description;
  int playlist;
  int owner;
  dynamic videoFile;
  dynamic thumbnail;
  double duration;
  int views;
  String status;
  String transcript;
  int mcqCount;
  DateTime createdAt;
  DateTime updatedAt;

  VideoDetail({
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
    required this.transcript,
    required this.mcqCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory VideoDetail.fromJson(Map<String, dynamic> json) => VideoDetail(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    playlist: (json["playlist"] as num).toInt(),
    owner: (json["owner"] as num).toInt(),
    videoFile: json["video_file"],
    thumbnail: json["thumbnail"],
    duration: (json["duration"] as num).toDouble(),
    views: (json["views"] as num).toInt(),
    status: json["status"],
    transcript: json["transcript"] ?? "",
    mcqCount: (json["mcqCount"] as num).toInt(),
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
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
    "transcript": transcript,
    "mcqCount": mcqCount,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}