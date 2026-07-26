import 'dart:convert';

List<DisplayVideosModel> displayVideosModelFromJson(String str) {
final decodedData = json.decode(str) as List<dynamic>;

return decodedData
    .map(
(item) => DisplayVideosModel.fromJson(
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
final DateTime createdAt;
final DateTime updatedAt;

const DisplayVideosModel({
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
required this.createdAt,
required this.updatedAt,
});

factory DisplayVideosModel.fromJson(
Map<String, dynamic> json,
) {
return DisplayVideosModel(
id: (json["id"] as num?)?.toInt() ?? 0,
title: json["title"]?.toString() ?? "",
description:
json["description"]?.toString() ?? "",
playlist:
(json["playlist"] as num?)?.toInt() ?? 0,
owner: (json["owner"] as num?)?.toInt() ?? 0,
videoFile: json["video_file"]?.toString(),
thumbnail: json["thumbnail"]?.toString(),
duration:
(json["duration"] as num?)?.toDouble() ?? 0.0,
views: (json["views"] as num?)?.toInt() ?? 0,
status: json["status"]?.toString() ?? "",
approvalStatus:
json["approval_status"]?.toString() ?? "",
rejectionReason:
json["rejection_reason"]?.toString() ?? "",
transcript:
json["transcript"]?.toString() ?? "",
mcqCount:
(json["mcqCount"] as num?)?.toInt() ?? 0,
createdAt: DateTime.tryParse(
json["created_at"]?.toString() ?? "",
) ??
DateTime.fromMillisecondsSinceEpoch(0),
updatedAt: DateTime.tryParse(
json["updated_at"]?.toString() ?? "",
) ??
DateTime.fromMillisecondsSinceEpoch(0),
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
"created_at": createdAt.toIso8601String(),
"updated_at": updatedAt.toIso8601String(),
};
}
}
