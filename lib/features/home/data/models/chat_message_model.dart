import 'dart:convert';

ChatMessageModel chatMessageModelFromJson(String str) =>
    ChatMessageModel.fromJson(json.decode(str));

String chatMessageModelToJson(ChatMessageModel data) =>
    json.encode(data.toJson());

class ChatMessageModel {
  final int id;
  final int chat;
  final String sender;
  final String text;
  final Map<String, dynamic> metadata;
  final DateTime? createdAt;

  ChatMessageModel({
    required this.id,
    required this.chat,
    required this.sender,
    required this.text,
    required this.metadata,
    this.createdAt,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'] ?? 0,

      chat: json['chat'] ?? 0,

      sender: json['sender'] ?? '',

      text: json['text'] ?? '',

      metadata: json['metadata'] is Map
          ? Map<String, dynamic>.from(json['metadata'])
          : {},

      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,

      'chat': chat,

      'sender': sender,

      'text': text,

      'metadata': metadata,

      'created_at': createdAt?.toIso8601String(),
    };
  }
}
