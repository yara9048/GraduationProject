import 'dart:convert';

List<WatchingHistoryModel> watchingHistoryModelFromJson(
String str,
) {
final decodedData = json.decode(str) as List<dynamic>;

return decodedData
    .map(
(item) => WatchingHistoryModel.fromJson(
item as Map<String, dynamic>,
),
)
    .toList();
}

String watchingHistoryModelToJson(
List<WatchingHistoryModel> data,
) {
return json.encode(
data.map((item) => item.toJson()).toList(),
);
}

class WatchingHistoryModel {
final int id;
final int user;
final int video;
final VideoDetail videoDetail;
final CourseDetail courseDetail;
final double progressSeconds;
final bool isCompleted;
final DateTime lastWatchedAt;

const WatchingHistoryModel({
required this.id,
required this.user,
required this.video,
required this.videoDetail,
required this.courseDetail,
required this.progressSeconds,
required this.isCompleted,
required this.lastWatchedAt,
});

factory WatchingHistoryModel.fromJson(
Map<String, dynamic> json,
) {
return WatchingHistoryModel(
id: _toInt(json['id']),
user: _toInt(json['user']),
video: _toInt(json['video']),
videoDetail: VideoDetail.fromJson(
json['video_detail'] as Map<String, dynamic>? ?? {},
),
courseDetail: CourseDetail.fromJson(
json['course_detail'] as Map<String, dynamic>? ?? {},
),
progressSeconds: _toDouble(
json['progress_seconds'],
),
isCompleted: json['is_completed'] == true,
lastWatchedAt: _toDateTime(
json['last_watched_at'],
),
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
'is_completed': isCompleted,
'last_watched_at': lastWatchedAt.toIso8601String(),
};
}
}

class CourseDetail {
final int id;
final String name;
final String description;
final dynamic owner;
final String category;
final int subject;
final SubjectDetail subjectDetail;
final String? thumbnail;
final String price;
final int totalVideoCount;
final double totalDuration;
final int studentsCount;
final double completionRate;
final double rating;
final DateTime createdAt;
final DateTime updatedAt;

const CourseDetail({
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
required this.createdAt,
required this.updatedAt,
});

factory CourseDetail.fromJson(
Map<String, dynamic> json,
) {
return CourseDetail(
id: _toInt(json['id']),
name: _toStringValue(json['name']),
description: _toStringValue(
json['description'],
),
owner: json['owner'],
category: _toStringValue(json['category']),
subject: _toInt(json['subject']),
subjectDetail: SubjectDetail.fromJson(
json['subject_detail'] as Map<String, dynamic>? ?? {},
),
thumbnail: _toNullableString(
json['thumbnail'],
),
price: _toStringValue(
json['price'],
defaultValue: '0.00',
),
totalVideoCount: _toInt(
json['total_video_count'],
),
totalDuration: _toDouble(
json['total_duration'],
),
studentsCount: _toInt(
json['students_count'],
),
completionRate: _toDouble(
json['completion_rate'],
),
rating: _toDouble(json['rating']),
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
'subject_detail': subjectDetail.toJson(),
'thumbnail': thumbnail,
'price': price,
'total_video_count': totalVideoCount,
'total_duration': totalDuration,
'students_count': studentsCount,
'completion_rate': completionRate,
'rating': rating,
'created_at': createdAt.toIso8601String(),
'updated_at': updatedAt.toIso8601String(),
};
}
}

class SubjectDetail {
final int id;
final String name;
final String slug;
final int category;
final CategoryDetail categoryDetail;
final String description;
final DateTime createdAt;
final DateTime updatedAt;

const SubjectDetail({
required this.id,
required this.name,
required this.slug,
required this.category,
required this.categoryDetail,
required this.description,
required this.createdAt,
required this.updatedAt,
});

factory SubjectDetail.fromJson(
Map<String, dynamic> json,
) {
return SubjectDetail(
id: _toInt(json['id']),
name: _toStringValue(json['name']),
slug: _toStringValue(json['slug']),
category: _toInt(json['category']),
categoryDetail: CategoryDetail.fromJson(
json['category_detail'] as Map<String, dynamic>? ?? {},
),
description: _toStringValue(
json['description'],
),
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
'category_detail': categoryDetail.toJson(),
'description': description,
'created_at': createdAt.toIso8601String(),
'updated_at': updatedAt.toIso8601String(),
};
}
}

class CategoryDetail {
final int id;
final String name;
final String slug;
final DateTime createdAt;
final DateTime updatedAt;

const CategoryDetail({
required this.id,
required this.name,
required this.slug,
required this.createdAt,
required this.updatedAt,
});

factory CategoryDetail.fromJson(
Map<String, dynamic> json,
) {
return CategoryDetail(
id: _toInt(json['id']),
name: _toStringValue(json['name']),
slug: _toStringValue(json['slug']),
createdAt: _toDateTime(json['created_at']),
updatedAt: _toDateTime(json['updated_at']),
);
}

Map<String, dynamic> toJson() {
return {
'id': id,
'name': name,
'slug': slug,
'created_at': createdAt.toIso8601String(),
'updated_at': updatedAt.toIso8601String(),
};
}
}

class VideoDetail {
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
final DateTime createdAt;
final DateTime updatedAt;

const VideoDetail({
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

factory VideoDetail.fromJson(
Map<String, dynamic> json,
) {
return VideoDetail(
id: _toInt(json['id']),
title: _toStringValue(json['title']),
description: _toStringValue(
json['description'],
),
playlist: _toInt(json['playlist']),
owner: _toInt(json['owner']),
videoFile: _toNullableString(
json['video_file'],
),
thumbnail: _toNullableString(
json['thumbnail'],
),
duration: _toDouble(json['duration']),
views: _toInt(json['views']),
status: _toStringValue(json['status']),
approvalStatus: _toStringValue(
json['approval_status'],
),
rejectionReason: _toStringValue(
json['rejection_reason'],
),
transcript: _toStringValue(
json['transcript'],
),

// معالجة الحالتين المحتملتين من الـ API
mcqCount: _toInt(
json['mcqCount'] ?? json['mcq_count'],
),

accessStatus: _toStringValue(
json['access_status'],
),
canWatch: json['can_watch'] == true,
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
'created_at': createdAt.toIso8601String(),
'updated_at': updatedAt.toIso8601String(),
};
}
}

/* -------------------------------------------------------------------------- */
/*                              Helper functions                              */
/* -------------------------------------------------------------------------- */

int _toInt(dynamic value) {
if (value == null) {
return 0;
}

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

double _toDouble(dynamic value) {
if (value == null) {
return 0.0;
}

if (value is num) {
return value.toDouble();
}

return double.tryParse(value.toString()) ?? 0.0;
}

String _toStringValue(
dynamic value, {
String defaultValue = '',
}) {
if (value == null) {
return defaultValue;
}

return value.toString();
}

String? _toNullableString(dynamic value) {
if (value == null) {
return null;
}

final convertedValue = value.toString().trim();

if (convertedValue.isEmpty ||
convertedValue.toLowerCase() == 'null') {
return null;
}

return convertedValue;
}

DateTime _toDateTime(dynamic value) {
if (value == null) {
return DateTime.fromMillisecondsSinceEpoch(0);
}

return DateTime.tryParse(value.toString()) ??
DateTime.fromMillisecondsSinceEpoch(0);
}
