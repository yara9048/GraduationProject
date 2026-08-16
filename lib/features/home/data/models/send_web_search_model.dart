// To parse this JSON data, do:
//
//     final sendWebSearchModel = sendWebSearchModelFromJson(jsonString);

import 'dart:convert';

SendWebSearchModel sendWebSearchModelFromJson(String str) =>
    SendWebSearchModel.fromJson(json.decode(str));

String sendWebSearchModelToJson(SendWebSearchModel data) =>
    json.encode(data.toJson());

class SendWebSearchModel {
  final UserMessage userMessage;
  final AiMessage aiMessage;
  final String answer;

  const SendWebSearchModel({
    required this.userMessage,
    required this.aiMessage,
    required this.answer,
  });

  factory SendWebSearchModel.fromJson(Map<String, dynamic> json) {
    return SendWebSearchModel(
      userMessage: json["user_message"] is Map<String, dynamic>
          ? UserMessage.fromJson(
        json["user_message"] as Map<String, dynamic>,
      )
          : const UserMessage(),
      aiMessage: json["ai_message"] is Map<String, dynamic>
          ? AiMessage.fromJson(
        json["ai_message"] as Map<String, dynamic>,
      )
          : const AiMessage(),
      answer: json["answer"]?.toString() ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "user_message": userMessage.toJson(),
    "ai_message": aiMessage.toJson(),
    "answer": answer,
  };
}

class AiMessage {
  final int id;
  final int chat;
  final String sender;
  final String text;
  final AiMessageMetadata metadata;
  final DateTime? createdAt;

  const AiMessage({
    this.id = 0,
    this.chat = 0,
    this.sender = "",
    this.text = "",
    this.metadata = const AiMessageMetadata(),
    this.createdAt,
  });

  factory AiMessage.fromJson(Map<String, dynamic> json) {
    return AiMessage(
      id: _toInt(json["id"]),
      chat: _toInt(json["chat"]),
      sender: json["sender"]?.toString() ?? "",
      text: json["text"]?.toString() ?? "",
      metadata: json["metadata"] is Map<String, dynamic>
          ? AiMessageMetadata.fromJson(
        json["metadata"] as Map<String, dynamic>,
      )
          : const AiMessageMetadata(),
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

class AiMessageMetadata {
  final String? provider;
  final bool? webSearch;

  const AiMessageMetadata({
    this.provider,
    this.webSearch,
  });

  factory AiMessageMetadata.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const AiMessageMetadata();
    }

    return AiMessageMetadata(
      provider: json["provider"]?.toString(),
      webSearch: _toBool(json["web_search"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "provider": provider,
    "web_search": webSearch,
  };
}

class UserMessage {
  final int id;
  final int chat;
  final String sender;
  final String text;
  final UserMessageMetadata metadata;
  final DateTime? createdAt;

  const UserMessage({
    this.id = 0,
    this.chat = 0,
    this.sender = "",
    this.text = "",
    this.metadata = const UserMessageMetadata(),
    this.createdAt,
  });

  factory UserMessage.fromJson(Map<String, dynamic> json) {
    return UserMessage(
      id: _toInt(json["id"]),
      chat: _toInt(json["chat"]),
      sender: json["sender"]?.toString() ?? "",
      text: json["text"]?.toString() ?? "",
      metadata: json["metadata"] is Map<String, dynamic>
          ? UserMessageMetadata.fromJson(
        json["metadata"] as Map<String, dynamic>,
      )
          : const UserMessageMetadata(),
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

class UserMessageMetadata {
  const UserMessageMetadata();

  factory UserMessageMetadata.fromJson(Map<String, dynamic>? json) {
    return const UserMessageMetadata();
  }

  Map<String, dynamic> toJson() => {};
}

int _toInt(dynamic value) {
  if (value == null) return 0;

  if (value is int) return value;

  if (value is num) return value.toInt();

  return int.tryParse(value.toString()) ?? 0;
}

DateTime? _toDateTime(dynamic value) {
  if (value == null) return null;

  if (value is DateTime) return value;

  return DateTime.tryParse(value.toString());
}

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