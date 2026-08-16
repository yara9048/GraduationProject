import 'dart:convert';

List<NotificationsModel> notificationsModelFromJson(
    String str,
    ) {
  try {
    final dynamic decoded = json.decode(str);

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

String notificationsModelToJson(
    List<NotificationsModel> data,
    ) {
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

  /// رابط للواجهة مثلاً:
  /// http://localhost:3000/courses/3
  ///
  /// إذا كان "" من API رح يتحول إلى null.
  final String? url;

  /// رابط API مثلاً:
  /// http://127.0.0.1:8000/ar/api/courses/3/
  ///
  /// إذا كان "" من API رح يتحول إلى null.
  final String? apiUrl;

  final bool isRead;

  /// مثال:
  /// 2026-08-16 11:13
  final String createdAt;

  const NotificationsModel({
    required this.id,
    required this.title,
    required this.message,
    required this.url,
    required this.apiUrl,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationsModel.fromJson(
      Map<String, dynamic>? json,
      ) {
    json ??= {};

    return NotificationsModel(
      id: _parseInt(
        json['id'],
      ),
      title: _parseString(
        json['title'],
      ),
      message: _parseString(
        json['message'],
      ),

      url: _parseNullableString(
        json['url'],
      ),

      apiUrl: _parseNullableString(
        json['api_url'],
      ),

      isRead: _parseBool(
        json['is_read'],
      ),

      createdAt: _parseString(
        json['created_at'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'url': url ?? '',
      'api_url': apiUrl ?? '',
      'is_read': isRead,
      'created_at': createdAt,
    };
  }

  /// هل الإشعار لديه رابط واجهة؟
  bool get hasUrl =>
      url != null &&
          url!.trim().isNotEmpty;

  /// هل الإشعار لديه API URL؟
  bool get hasApiUrl =>
      apiUrl != null &&
          apiUrl!.trim().isNotEmpty;

  /// هل يوجد أي رابط مرتبط بالإشعار؟
  bool get hasAction =>
      hasUrl || hasApiUrl;

  /// استخراج الوقت فقط من created_at.
  ///
  /// 2026-08-16 11:13
  /// ->
  /// 11:13
  String get formattedTime {
    final String value =
    createdAt.trim();

    if (value.isEmpty) {
      return '--:--';
    }

    try {
      final List<String> parts =
      value.split(RegExp(r'\s+'));

      if (parts.length < 2) {
        return '--:--';
      }

      final String timePart =
      parts[1].trim();

      final List<String> timeParts =
      timePart.split(':');

      if (timeParts.length < 2) {
        return '--:--';
      }

      final String hour =
      timeParts[0].padLeft(
        2,
        '0',
      );

      final String minute =
      timeParts[1].padLeft(
        2,
        '0',
      );

      return '$hour:$minute';
    } catch (_) {
      return '--:--';
    }
  }

  /// استخراج التاريخ فقط.
  ///
  /// 2026-08-16 11:13
  /// ->
  /// 2026-08-16
  String get formattedDate {
    final String value =
    createdAt.trim();

    if (value.isEmpty) {
      return '';
    }

    try {
      final List<String> parts =
      value.split(RegExp(r'\s+'));

      if (parts.isEmpty) {
        return '';
      }

      return parts.first;
    } catch (_) {
      return '';
    }
  }

  static int _parseInt(
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

    if (text.isEmpty) {
      return 0;
    }

    return int.tryParse(text) ??
        double.tryParse(text)?.toInt() ??
        0;
  }

  static String _parseString(
      dynamic value,
      ) {
    if (value == null) {
      return '';
    }

    return value.toString();
  }

  static String? _parseNullableString(
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

    return text;
  }

  static bool _parseBool(
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

    final String normalized =
    value
        .toString()
        .trim()
        .toLowerCase();

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

    return false;
  }
}