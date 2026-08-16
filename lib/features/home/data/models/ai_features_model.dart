import 'dart:convert';

AiFeaturesModel aiFeaturesModelFromJson(String str) =>
    AiFeaturesModel.fromJson(json.decode(str));

String aiFeaturesModelToJson(AiFeaturesModel data) =>
    json.encode(data.toJson());

class AiFeaturesModel {
  final List<Summary> summaries;
  final List<Mcq> mcqs;
  final List<Chat> chats;

  const AiFeaturesModel({
    required this.summaries,
    required this.mcqs,
    required this.chats,
  });

  factory AiFeaturesModel.fromJson(Map<String, dynamic> json) {
    return AiFeaturesModel(
      summaries: (json["summaries"] as List? ?? [])
          .whereType<Map<String, dynamic>>()
          .map((x) => Summary.fromJson(x))
          .toList(),

      mcqs: (json["mcqs"] as List? ?? [])
          .whereType<Map<String, dynamic>>()
          .map((x) => Mcq.fromJson(x))
          .toList(),

      chats: (json["chats"] as List? ?? [])
          .whereType<Map<String, dynamic>>()
          .map((x) => Chat.fromJson(x))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    "summaries": summaries
        .map((x) => x.toJson())
        .toList(),
    "mcqs": mcqs
        .map((x) => x.toJson())
        .toList(),
    "chats": chats
        .map((x) => x.toJson())
        .toList(),
  };
}

// =====================================================
// CHAT
// =====================================================

class Chat {
  final int id;
  final int user;
  final int video;
  final String title;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<Message> messages;

  const Chat({
    required this.id,
    required this.user,
    required this.video,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    required this.messages,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: _parseInt(json["id"]),
      user: _parseInt(json["user"]),
      video: _parseInt(json["video"]),
      title: json["title"]?.toString() ?? '',
      createdAt: _parseDateTime(json["created_at"]),
      updatedAt: _parseDateTime(json["updated_at"]),
      messages: (json["messages"] as List? ?? [])
          .whereType<Map<String, dynamic>>()
          .map((x) => Message.fromJson(x))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "user": user,
    "video": video,
    "title": title,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "messages": messages
        .map((x) => x.toJson())
        .toList(),
  };
}

// =====================================================
// MESSAGE
// =====================================================

class Message {
  final int id;
  final int chat;
  final String sender;
  final String text;

  /// الـ API يرجع metadata بالشكل:
  /// "metadata": {}
  ///
  /// لذلك لازم تكون Map وليس String.
  final Map<String, dynamic> metadata;

  final DateTime? createdAt;

  const Message({
    required this.id,
    required this.chat,
    required this.sender,
    required this.text,
    required this.metadata,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: _parseInt(json["id"]),
      chat: _parseInt(json["chat"]),
      sender: json["sender"]?.toString() ?? '',
      text: json["text"]?.toString() ?? '',
      metadata: _parseMetadata(json["metadata"]),
      createdAt: _parseDateTime(json["created_at"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "chat": chat,
    "sender": sender,
    "text": text,
    "metadata": metadata,
    "created_at": createdAt?.toIso8601String(),
  };
}

// =====================================================
// MCQ
// =====================================================

class Mcq {
  final int id;
  final int video;
  final String question;
  final String category;
  final List<String> options;
  final String answer;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Mcq({
    required this.id,
    required this.video,
    required this.question,
    required this.category,
    required this.options,
    required this.answer,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Mcq.fromJson(Map<String, dynamic> json) {
    return Mcq(
      id: _parseInt(json["id"]),
      video: _parseInt(json["video"]),
      question: json["question"]?.toString() ?? '',
      category: json["category"]?.toString() ?? '',
      options: _parseStringList(json["options"]),
      answer: json["answer"]?.toString() ?? '',
      createdAt: _parseDateTime(json["created_at"]),
      updatedAt: _parseDateTime(json["updated_at"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "video": video,
    "question": question,
    "category": category,
    "options": options,
    "answer": answer,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

// =====================================================
// SUMMARY
// =====================================================

class Summary {
  final int id;
  final int video;
  final String type;

  /// الـ API عندك يرجع data بأكثر من شكل:
  ///
  /// 1)
  /// "data": {
  ///   "text": "..."
  /// }
  ///
  /// 2)
  /// "data": "..."
  ///
  /// لذلك نخليها dynamic.
  final dynamic data;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Summary({
    required this.id,
    required this.video,
    required this.type,
    required this.data,
    required this.createdAt,
    required this.updatedAt,
  });

  /// استخدمي summary.text بالـ UI
  /// بدل summary.data مباشرة.
  String get text {
    if (data == null) {
      return '';
    }

    if (data is String) {
      return data as String;
    }

    if (data is Map) {
      final map = Map<String, dynamic>.from(
        data as Map,
      );

      if (map["text"] != null) {
        return map["text"].toString();
      }

      return map.toString();
    }

    return data.toString();
  }

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      id: _parseInt(json["id"]),
      video: _parseInt(json["video"]),
      type: json["type"]?.toString() ?? '',
      data: json["data"],
      createdAt: _parseDateTime(json["created_at"]),
      updatedAt: _parseDateTime(json["updated_at"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "video": video,
    "type": type,
    "data": data,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

// =====================================================
// DATA CLASS
// =====================================================

class DataClass {
  final String text;

  const DataClass({
    required this.text,
  });

  factory DataClass.fromJson(Map<String, dynamic> json) {
    return DataClass(
      text: json["text"]?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    "text": text,
  };
}

// =====================================================
// HELPERS
// =====================================================

int _parseInt(dynamic value) {
  if (value == null) {
    return 0;
  }

  if (value is int) {
    return value;
  }

  if (value is num) {
    return value.toInt();
  }

  return int.tryParse(
    value.toString(),
  ) ??
      0;
}

DateTime? _parseDateTime(dynamic value) {
  if (value == null) {
    return null;
  }

  final String text =
  value.toString().trim();

  if (text.isEmpty) {
    return null;
  }

  return DateTime.tryParse(text);
}

List<String> _parseStringList(dynamic value) {
  if (value == null) {
    return [];
  }

  if (value is List) {
    return value
        .map((item) => item.toString())
        .toList();
  }

  return [];
}

Map<String, dynamic> _parseMetadata(dynamic value) {
  if (value == null) {
    return <String, dynamic>{};
  }

  if (value is Map<String, dynamic>) {
    return value;
  }

  if (value is Map) {
    return Map<String, dynamic>.from(value);
  }

  // احتياط إذا رجع metadata كنص JSON
  if (value is String) {
    final String text = value.trim();

    if (text.isEmpty) {
      return <String, dynamic>{};
    }

    try {
      final decoded = json.decode(text);

      if (decoded is Map) {
        return Map<String, dynamic>.from(decoded);
      }
    } catch (_) {
      return <String, dynamic>{};
    }
  }

  return <String, dynamic>{};
}