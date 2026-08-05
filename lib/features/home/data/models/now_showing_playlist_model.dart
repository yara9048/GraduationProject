import 'dart:convert';

List<NowShowingPlaylistModel>
nowShowingPlaylistModelFromJson(
String str,
) {
final dynamic decoded = json.decode(str);

if (decoded is! List) {
return [];
}

return decoded
    .whereType<Map>()
    .map(
(item) =>
NowShowingPlaylistModel.fromJson(
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
final int user;
final int video;
final VideoDetail? videoDetail;
final CourseDetail? courseDetail;
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
required this.lastWatchedAt,
});

factory NowShowingPlaylistModel.fromJson(
Map<String, dynamic> json,
) {
return NowShowingPlaylistModel(
id: _parseInt(json['id']),
user: _parseInt(json['user']),
video: _parseInt(json['video']),
videoDetail: _parseVideoDetail(
json['video_detail'],
),
courseDetail: _parseCourseDetail(
json['course_detail'],
),
progressSeconds: _parseInt(
json['progress_seconds'],
),
progressPercentage: _parseDouble(
json['progress_percentage'],
),
isCompleted: _parseBool(
json['is_completed'],
),
lastWatchedAt: _parseDateTime(
json['last_watched_at'],
),
);
}

Map<String, dynamic> toJson() {
return {
'id': id,
'user': user,
'video': video,
'video_detail': videoDetail?.toJson(),
'course_detail': courseDetail?.toJson(),
'progress_seconds': progressSeconds,
'progress_percentage':
progressPercentage,
'is_completed': isCompleted,
'last_watched_at':
lastWatchedAt?.toIso8601String(),
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
final SubjectDetail? subjectDetail;
final String? thumbnail;
final String price;
final int totalVideoCount;
final double? totalDuration;
final int studentsCount;
final double completionRate;
final dynamic rating;
final bool hasSubscription;
final bool hasActiveSubscription;
final bool canAccessContent;
final DateTime? createdAt;
final DateTime? updatedAt;

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
required this.hasSubscription,
required this.hasActiveSubscription,
required this.canAccessContent,
required this.createdAt,
required this.updatedAt,
});

factory CourseDetail.fromJson(
Map<String, dynamic> json,
) {
return CourseDetail(
id: _parseInt(json['id']),
name: _parseString(json['name']),
description: _parseString(
json['description'],
),
owner: json['owner'],
category: _parseString(
json['category'],
),
subject: _parseInt(json['subject']),
subjectDetail: _parseSubjectDetail(
json['subject_detail'],
),
thumbnail: _parseNullableString(
json['thumbnail'],
),
price: _parsePrice(json['price']),
totalVideoCount: _parseInt(
json['total_video_count'],
),
totalDuration: _parseNullableDouble(
json['total_duration'],
),
studentsCount: _parseInt(
json['students_count'],
),
completionRate: _parseDouble(
json['completion_rate'],
),
rating: _parseRating(
json['rating'],
),
hasSubscription: _parseBool(
json['has_subscription'],
),
hasActiveSubscription: _parseBool(
json['has_active_subscription'],
),
canAccessContent: _parseBool(
json['can_access_content'],
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
'name': name,
'description': description,
'owner': owner,
'category': category,
'subject': subject,
'subject_detail':
subjectDetail?.toJson(),
'thumbnail': thumbnail,
'price': price,
'total_video_count':
totalVideoCount,
'total_duration': totalDuration,
'students_count': studentsCount,
'completion_rate': completionRate,
'rating': rating,
'has_subscription':
hasSubscription,
'has_active_subscription':
hasActiveSubscription,
'can_access_content':
canAccessContent,
'created_at':
createdAt?.toIso8601String(),
'updated_at':
updatedAt?.toIso8601String(),
};
}
}

class SubjectDetail {
final int id;
final String name;
final String slug;
final int category;
final CategoryDetail? categoryDetail;
final String description;
final DateTime? createdAt;
final DateTime? updatedAt;

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
id: _parseInt(json['id']),
name: _parseString(json['name']),
slug: _parseString(json['slug']),
category: _parseInt(
json['category'],
),
categoryDetail:
_parseCategoryDetail(
json['category_detail'],
),
description: _parseString(
json['description'],
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
'name': name,
'slug': slug,
'category': category,
'category_detail':
categoryDetail?.toJson(),
'description': description,
'created_at':
createdAt?.toIso8601String(),
'updated_at':
updatedAt?.toIso8601String(),
};
}
}

class CategoryDetail {
final int id;
final String name;
final String slug;
final DateTime? createdAt;
final DateTime? updatedAt;

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
id: _parseInt(json['id']),
name: _parseString(json['name']),
slug: _parseString(json['slug']),
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
'name': name,
'slug': slug,
'created_at':
createdAt?.toIso8601String(),
'updated_at':
updatedAt?.toIso8601String(),
};
}
}

class VideoDetail {
final int id;
final String title;
final String description;
final int playlist;
final PlaylistDetail? playlistDetail;
final int owner;
final OwnerDetail? ownerDetail;
final String? videoFile;
final String? thumbnail;
final double? duration;
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

const VideoDetail({
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
id: _parseInt(json['id']),
title: _parseString(
json['title'],
),
description: _parseString(
json['description'],
),
playlist: _parseInt(
json['playlist'],
),
playlistDetail:
_parsePlaylistDetail(
json['playlist_detail'],
),
owner: _parseInt(json['owner']),
ownerDetail: _parseOwnerDetail(
json['owner_detail'],
),
videoFile: _parseNullableString(
json['video_file'],
),
thumbnail: _parseNullableString(
json['thumbnail'],
),
duration: _parseNullableDouble(
json['duration'],
),
views: _parseInt(json['views']),
status: _parseString(
json['status'],
),
approvalStatus: _parseString(
json['approval_status'],
),
rejectionReason: _parseString(
json['rejection_reason'],
),
transcript: _parseString(
json['transcript'],
),
mcqCount: _parseInt(
json['mcqCount'] ??
json['mcq_count'],
),
accessStatus: _parseString(
json['access_status'],
),
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
'mcqCount': mcqCount,
'access_status': accessStatus,
'can_watch': canWatch,
'created_at':
createdAt?.toIso8601String(),
'updated_at':
updatedAt?.toIso8601String(),
};
}
}

class OwnerDetail {
final int id;
final String name;
final String email;

const OwnerDetail({
required this.id,
required this.name,
required this.email,
});

factory OwnerDetail.fromJson(
Map<String, dynamic> json,
) {
return OwnerDetail(
id: _parseInt(json['id']),
name: _parseString(json['name']),
email: _parseString(
json['email'],
),
);
}

Map<String, dynamic> toJson() {
return {
'id': id,
'name': name,
'email': email,
};
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
id: _parseInt(json['id']),
name: _parseString(json['name']),
);
}

Map<String, dynamic> toJson() {
return {
'id': id,
'name': name,
};
}
}

VideoDetail? _parseVideoDetail(
dynamic value,
) {
final map = _parseMap(value);

if (map == null) {
return null;
}

return VideoDetail.fromJson(map);
}

CourseDetail? _parseCourseDetail(
dynamic value,
) {
final map = _parseMap(value);

if (map == null) {
return null;
}

return CourseDetail.fromJson(map);
}

SubjectDetail? _parseSubjectDetail(
dynamic value,
) {
final map = _parseMap(value);

if (map == null) {
return null;
}

return SubjectDetail.fromJson(map);
}

CategoryDetail? _parseCategoryDetail(
dynamic value,
) {
final map = _parseMap(value);

if (map == null) {
return null;
}

return CategoryDetail.fromJson(map);
}

PlaylistDetail? _parsePlaylistDetail(
dynamic value,
) {
final map = _parseMap(value);

if (map == null) {
return null;
}

return PlaylistDetail.fromJson(map);
}

OwnerDetail? _parseOwnerDetail(
dynamic value,
) {
final map = _parseMap(value);

if (map == null) {
return null;
}

return OwnerDetail.fromJson(map);
}

Map<String, dynamic>? _parseMap(
dynamic value,
) {
if (value is Map<String, dynamic>) {
return value;
}

if (value is Map) {
return Map<String, dynamic>.from(
value,
);
}

return null;
}

int _parseInt(
dynamic value,
) {
if (value == null) {
return 0;
}

if (value is int) {
return value;
}

if (value is num) {
return value.toInt();
}

final text = value.toString().trim();

return int.tryParse(text) ??
double.tryParse(text)?.toInt() ??
0;
}

double _parseDouble(
dynamic value,
) {
if (value == null) {
return 0.0;
}

if (value is num) {
return value.toDouble();
}

return double.tryParse(
value.toString().trim(),
) ??
0.0;
}

double? _parseNullableDouble(
dynamic value,
) {
if (value == null) {
return null;
}

if (value is num) {
return value.toDouble();
}

final text = value.toString().trim();

if (text.isEmpty ||
text.toLowerCase() == 'null' ||
text.toUpperCase() == 'N/A') {
return null;
}

return double.tryParse(text);
}

String _parseString(
dynamic value,
) {
if (value == null) {
return '';
}

return value.toString();
}

String? _parseNullableString(
dynamic value,
) {
if (value == null) {
return null;
}

final text = value.toString().trim();

if (text.isEmpty ||
text.toLowerCase() == 'null') {
return null;
}

return text;
}

String _parsePrice(
dynamic value,
) {
if (value == null) {
return '0.00';
}

if (value is num) {
return value
    .toDouble()
    .toStringAsFixed(2);
}

final text = value.toString().trim();

if (text.isEmpty) {
return '0.00';
}

return text;
}

dynamic _parseRating(
dynamic value,
) {
if (value == null) {
return 'N/A';
}

if (value is num) {
return value.toDouble();
}

final text = value.toString().trim();

if (text.isEmpty ||
text.toLowerCase() == 'null' ||
text.toUpperCase() == 'N/A') {
return 'N/A';
}

return double.tryParse(text) ?? text;
}

bool _parseBool(
dynamic value,
) {
if (value == null) {
return false;
}

if (value is bool) {
return value;
}

if (value is num) {
return value != 0;
}

final text = value
    .toString()
    .trim()
    .toLowerCase();

return text == 'true' ||
text == '1' ||
text == 'yes';
}

DateTime? _parseDateTime(
dynamic value,
) {
if (value == null) {
return null;
}

final text = value.toString().trim();

if (text.isEmpty ||
text.toLowerCase() == 'null') {
return null;
}

return DateTime.tryParse(text);
}
