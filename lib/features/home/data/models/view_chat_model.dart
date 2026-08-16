import 'dart:convert';

ViewChatModel viewChatModelFromJson(String str) =>
    ViewChatModel.fromJson(json.decode(str));

String viewChatModelToJson(ViewChatModel data) =>
    json.encode(data.toJson());

class ViewChatModel {
  final int id;
  final int user;
  final int video;
  final String title;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<Message> messages;

  const ViewChatModel({
    required this.id,
    required this.user,
    required this.video,
    required this.title,
    this.createdAt,
    this.updatedAt,
    required this.messages,
  });

  factory ViewChatModel.fromJson(Map<String, dynamic> json) {
    return ViewChatModel(
      id: _toInt(json["id"]),
      user: _toInt(json["user"]),
      video: _toInt(json["video"]),
      title: json["title"]?.toString() ?? "",
      createdAt: _toDateTime(json["created_at"]),
      updatedAt: _toDateTime(json["updated_at"]),
      messages: json["messages"] is List
          ? (json["messages"] as List)
          .whereType<Map<String, dynamic>>()
          .map(Message.fromJson)
          .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "user": user,
    "video": video,
    "title": title,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "messages": messages.map((x) => x.toJson()).toList(),
  };
}

class Message {
  final int id;
  final int chat;
  final String sender;
  final String text;
  final Metadata metadata;
  final DateTime? createdAt;

  const Message({
    required this.id,
    required this.chat,
    required this.sender,
    required this.text,
    required this.metadata,
    this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: _toInt(json["id"]),
      chat: _toInt(json["chat"]),
      sender: json["sender"]?.toString() ?? "",
      text: json["text"]?.toString() ?? "",
      metadata: json["metadata"] is Map<String, dynamic>
          ? Metadata.fromJson(
        json["metadata"] as Map<String, dynamic>,
      )
          : const Metadata(),
      createdAt: _toDateTime(json["created_at"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "chat": chat,
    "sender": sender,
    "text": text,
    "metadata": metadata.toJson(),
    "created_at": createdAt?.toIso8601String(),
  };
}

class Metadata {
  final String? provider;
  final bool? webSearch;

  const Metadata({
    this.provider,
    this.webSearch,
  });

  factory Metadata.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const Metadata();
    }

    return Metadata(
      provider: json["provider"]?.toString(),
      webSearch: _toBool(json["web_search"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "provider": provider,
    "web_search": webSearch,
  };
}

/// Safe int converter.
/// Accepts:
/// 1
/// "1"
/// 1.0
/// null
int _toInt(dynamic value) {
  if (value == null) return 0;

  if (value is int) return value;

  if (value is num) return value.toInt();

  return int.tryParse(value.toString()) ?? 0;
}

/// Safe DateTime parser.
DateTime? _toDateTime(dynamic value) {
  if (value == null) return null;

  if (value is DateTime) return value;

  return DateTime.tryParse(value.toString());
}

/// Safe bool converter.
/// Accepts:
/// true
/// false
/// 1 / 0
/// "true" / "false"
/// "1" / "0"
bool? _toBool(dynamic value) {
  if (value == null) return null;

  if (value is bool) return value;

  if (value is num) {
    return value != 0;
  }

  final normalized = value.toString().trim().toLowerCase();

  if (normalized == "true" || normalized == "1") {
    return true;
  }

  if (normalized == "false" || normalized == "0") {
    return false;
  }

  return null;
}