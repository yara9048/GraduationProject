import 'dart:convert';

ViewChatModel viewChatModelFromJson(String str) =>
    ViewChatModel.fromJson(
      json.decode(str) as Map<String, dynamic>,
    );

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
      messages: _parseMapList(json["messages"])
          .map(Message.fromJson)
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
    "messages": messages.map((e) => e.toJson()).toList(),
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
      metadata: Metadata.fromJson(
        _toMap(json["metadata"]),
      ),
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
  final int? videoId;
  final List<String> sourceIds;
  final List<VideoSource> whereInVideo;
  final ServiceResponse? serviceResponse;

  const Metadata({
    this.provider,
    this.webSearch,
    this.videoId,
    this.sourceIds = const [],
    this.whereInVideo = const [],
    this.serviceResponse,
  });

  factory Metadata.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const Metadata();
    }

    return Metadata(
      provider: json["provider"]?.toString(),
      webSearch: _toBool(json["web_search"]),
      videoId: json["video_id"] != null
          ? _toInt(json["video_id"])
          : null,
      sourceIds: _toStringList(json["source_ids"]),
      whereInVideo: _parseMapList(json["where_in_video"])
          .map(VideoSource.fromJson)
          .toList(),
      serviceResponse: json["service_response"] is Map
          ? ServiceResponse.fromJson(
        _toMap(json["service_response"])!,
      )
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    if (provider != null) "provider": provider,
    if (webSearch != null) "web_search": webSearch,
    if (videoId != null) "video_id": videoId,
    if (sourceIds.isNotEmpty) "source_ids": sourceIds,
    if (whereInVideo.isNotEmpty)
      "where_in_video":
      whereInVideo.map((e) => e.toJson()).toList(),
    if (serviceResponse != null)
      "service_response": serviceResponse!.toJson(),
  };
}

class ServiceResponse {
  final String? answer;
  final String? question;
  final List<VideoSource> citations;
  final List<String> timestamps;
  final int? contextWords;
  final String? questionType;
  final List<VideoSource> whereInVideo;
  final StructuredOutput? structuredOutput;

  const ServiceResponse({
    this.answer,
    this.question,
    this.citations = const [],
    this.timestamps = const [],
    this.contextWords,
    this.questionType,
    this.whereInVideo = const [],
    this.structuredOutput,
  });

  factory ServiceResponse.fromJson(Map<String, dynamic> json) {
    return ServiceResponse(
      answer: json["answer"]?.toString(),
      question: json["question"]?.toString(),
      citations: _parseMapList(json["citations"])
          .map(VideoSource.fromJson)
          .toList(),
      timestamps: _toStringList(json["timestamps"]),
      contextWords: json["context_words"] != null
          ? _toInt(json["context_words"])
          : null,
      questionType: json["question_type"]?.toString(),
      whereInVideo: _parseMapList(json["where_in_video"])
          .map(VideoSource.fromJson)
          .toList(),
      structuredOutput: json["structured_output"] is Map
          ? StructuredOutput.fromJson(
        _toMap(json["structured_output"])!,
      )
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    if (answer != null) "answer": answer,
    if (question != null) "question": question,
    if (citations.isNotEmpty)
      "citations": citations.map((e) => e.toJson()).toList(),
    if (timestamps.isNotEmpty) "timestamps": timestamps,
    if (contextWords != null) "context_words": contextWords,
    if (questionType != null) "question_type": questionType,
    if (whereInVideo.isNotEmpty)
      "where_in_video":
      whereInVideo.map((e) => e.toJson()).toList(),
    if (structuredOutput != null)
      "structured_output": structuredOutput!.toJson(),
  };
}

class VideoSource {
  final double start;
  final double end;
  final String text;
  final String sourceId;
  final String timestamp;
  final int segmentId;

  const VideoSource({
    required this.start,
    required this.end,
    required this.text,
    required this.sourceId,
    required this.timestamp,
    required this.segmentId,
  });

  factory VideoSource.fromJson(Map<String, dynamic> json) {
    return VideoSource(
      start: _toDouble(json["start"]),
      end: _toDouble(json["end"]),
      text: json["text"]?.toString() ?? "",
      sourceId: json["source_id"]?.toString() ?? "",
      timestamp: json["timestamp"]?.toString() ?? "",
      segmentId: _toInt(json["segment_id"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "start": start,
    "end": end,
    "text": text,
    "source_id": sourceId,
    "timestamp": timestamp,
    "segment_id": segmentId,
  };
}

class StructuredOutput {
  final String? answer;
  final List<String> sourceIds;

  const StructuredOutput({
    this.answer,
    this.sourceIds = const [],
  });

  factory StructuredOutput.fromJson(Map<String, dynamic> json) {
    return StructuredOutput(
      answer: json["answer"]?.toString(),
      sourceIds: _toStringList(json["source_ids"]),
    );
  }

  Map<String, dynamic> toJson() => {
    if (answer != null) "answer": answer,
    "source_ids": sourceIds,
  };
}

int _toInt(dynamic value) {
  if (value == null) return 0;

  if (value is int) return value;

  if (value is num) return value.toInt();

  return int.tryParse(value.toString()) ?? 0;
}

double _toDouble(dynamic value) {
  if (value == null) return 0.0;

  if (value is double) return value;

  if (value is num) return value.toDouble();

  return double.tryParse(value.toString()) ?? 0.0;
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

  final normalized =
  value.toString().trim().toLowerCase();

  if (normalized == "true" || normalized == "1") {
    return true;
  }

  if (normalized == "false" || normalized == "0") {
    return false;
  }

  return null;
}

List<String> _toStringList(dynamic value) {
  if (value is! List) {
    return [];
  }

  return value
      .where((e) => e != null)
      .map((e) => e.toString())
      .toList();
}

List<Map<String, dynamic>> _parseMapList(dynamic value) {
  if (value is! List) {
    return [];
  }

  return value
      .whereType<Map>()
      .map(
        (e) => Map<String, dynamic>.from(e),
  )
      .toList();
}

Map<String, dynamic>? _toMap(dynamic value) {
  if (value is Map<String, dynamic>) {
    return value;
  }

  if (value is Map) {
    return Map<String, dynamic>.from(value);
  }

  return null;
}