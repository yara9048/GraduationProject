import 'dart:convert';

List<NotificationsModel> notificationsModelFromJson(String str) {
  try {
    final decoded = json.decode(str);

    if (decoded is! List) {
      return [];
    }

    return decoded
        .whereType<Map>()
        .map(
          (x) => NotificationsModel.fromJson(
        Map<String, dynamic>.from(x),
      ),
    )
        .toList();
  } catch (_) {
    return [];
  }
}

String notificationsModelToJson(List<NotificationsModel> data) {
  try {
    return json.encode(
      data.map((x) => x.toJson()).toList(),
    );
  } catch (_) {
    return '[]';
  }
}

class NotificationsModel {
  final int id;
  final String title;
  final String message;
  final bool isRead;
  final String createdAt;

  NotificationsModel({
    required this.id,
    required this.title,
    required this.message,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationsModel.fromJson(Map<String, dynamic>? json) {
    json ??= {};

    return NotificationsModel(
      id: _parseInt(json["id"]),
      title: _parseString(json["title"]),
      message: _parseString(json["message"]),
      isRead: _parseBool(json["is_read"]),
      createdAt: _parseString(json["created_at"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "message": message,
    "is_read": isRead,
    "created_at": createdAt,
  };

  static int _parseInt(dynamic value) {
    if (value == null) return 0;

    if (value is int) return value;

    if (value is num) return value.toInt();

    if (value is String) {
      return int.tryParse(value.trim()) ?? 0;
    }

    return 0;
  }

  static String _parseString(dynamic value) {
    if (value == null) return '';

    if (value is String) return value;

    return value.toString();
  }

  static bool _parseBool(dynamic value) {
    if (value == null) return false;

    if (value is bool) return value;

    if (value is num) {
      return value != 0;
    }

    if (value is String) {
      final normalized = value.trim().toLowerCase();

      if (normalized == 'true' ||
          normalized == '1' ||
          normalized == 'yes') {
        return true;
      }

      if (normalized == 'false' ||
          normalized == '0' ||
          normalized == 'no' ||
          normalized.isEmpty) {
        return false;
      }
    }

    return false;
  }
}