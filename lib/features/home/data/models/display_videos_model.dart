// To parse this JSON data, do
//
//     final displayVideosModel = displayVideosModelFromJson(jsonString);

import 'dart:convert';

List<DisplayVideosModel> displayVideosModelFromJson(String str) => List<DisplayVideosModel>.from(json.decode(str).map((x) => DisplayVideosModel.fromJson(x)));

String displayVideosModelToJson(List<DisplayVideosModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DisplayVideosModel {
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

  DisplayVideosModel({
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

  factory DisplayVideosModel.fromJson(Map<String, dynamic> json) => DisplayVideosModel(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    playlist: json["playlist"],
    owner: json["owner"],
    videoFile: json["video_file"],
    thumbnail: json["thumbnail"],
    duration: json["duration"]?.toDouble(),
    views: json["views"],
    status: json["status"],
    transcript: json["transcript"],
    mcqCount: json["mcqCount"],
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
