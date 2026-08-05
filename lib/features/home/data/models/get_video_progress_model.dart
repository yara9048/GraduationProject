import 'dart:convert';

List<GetVideoProgressModel>
getVideoProgressModelFromJson(
String str,
) {
final dynamic decoded = json.decode(str);

if (decoded is! List) {
return [];
}

return decoded
    .whereType<Map>()
    .map(
(item) => GetVideoProgressModel.fromJson(
Map<String, dynamic>.from(item),
),
)
    .toList();
}

String getVideoProgressModelToJson(
List<GetVideoProgressModel> data,
) {
return json.encode(
data
    .map(
(item) => item.toJson(),
)
    .toList(),
);
}

class GetVideoProgressModel {
final int id;
final int user;
final int video;

/// قد يرجع:
/// 20
/// 20.0
/// "20"
final double progressSeconds;

/// قد يرجع:
/// 100
/// 100.0
/// 25.5
final double progressPercentage;

final bool isCompleted;
final String accessStatus;
final DateTime? lastWatchedAt;

const GetVideoProgressModel({
required this.id,
required this.user,
required this.video,
required this.progressSeconds,
required this.progressPercentage,
required this.isCompleted,
required this.accessStatus,
required this.lastWatchedAt,
});

factory GetVideoProgressModel.fromJson(
Map<String, dynamic> json,
) {
return GetVideoProgressModel(
id: _parseInt(
json['id'],
),
user: _parseInt(
json['user'],
),
video: _parseInt(
json['video'],
),
progressSeconds: _parseDouble(
json['progress_seconds'],
),
progressPercentage: _parseDouble(
json['progress_percentage'],
),
isCompleted: _parseBool(
json['is_completed'],
),
accessStatus: _parseString(
json['access_status'],
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
'progress_seconds':
progressSeconds,
'progress_percentage':
progressPercentage,
'is_completed':
isCompleted,
'access_status':
accessStatus,
'last_watched_at':
lastWatchedAt?.toIso8601String(),
};
}

/// القيمة المناسبة لـ LinearProgressIndicator
/// من 0.0 إلى 1.0
double get normalizedProgress {
return (progressPercentage / 100)
    .clamp(
0.0,
1.0,
)
    .toDouble();
}

/// تستخدم إذا احتجت الثواني كـ int
int get progressSecondsAsInt {
return progressSeconds.round();
}
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

final String text =
value.toString().trim();

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

final String text =
value.toString().trim();

return double.tryParse(text) ??
0.0;
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

final String text = value
    .toString()
    .trim()
    .toLowerCase();

return text == 'true' ||
text == '1' ||
text == 'yes';
}

String _parseString(
dynamic value,
) {
if (value == null) {
return '';
}

return value.toString();
}

DateTime? _parseDateTime(
dynamic value,
) {
if (value == null) {
return null;
}

final String text =
value.toString().trim();

if (text.isEmpty ||
text.toLowerCase() == 'null') {
return null;
}

return DateTime.tryParse(text);
}
