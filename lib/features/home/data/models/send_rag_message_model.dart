// To parse this JSON data, do:
//
//     final sendRagMessage = sendRagMessageFromJson(jsonString);

import 'dart:convert';

SendRagMessage sendRagMessageFromJson(String str) =>
    SendRagMessage.fromJson(json.decode(str));

String sendRagMessageToJson(SendRagMessage data) =>
    json.encode(data.toJson());

class SendRagMessage {
  final int id;
  final int chat;
  final String sender;
  final String text;
  final Metadata metadata;
  final DateTime? createdAt;

  const SendRagMessage({
    required this.id,
    required this.chat,
    required this.sender,
    required this.text,
    required this.metadata,
    this.createdAt,
  });

  factory SendRagMessage.fromJson(Map<String, dynamic> json) {
    return SendRagMessage(
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
  const Metadata();

  factory Metadata.fromJson(Map<String, dynamic>? json) {
    return const Metadata();
  }

  Map<String, dynamic> toJson() => {};
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