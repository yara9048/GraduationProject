// To parse this JSON data, do
//
//     final sendRagMessage = sendRagMessageFromJson(jsonString);

import 'dart:convert';

SendRagMessage sendRagMessageFromJson(String str) => SendRagMessage.fromJson(json.decode(str));

String sendRagMessageToJson(SendRagMessage data) => json.encode(data.toJson());

class SendRagMessage {
  String answer;
  List<WhereInVideo> whereInVideo;

  SendRagMessage({
    required this.answer,
    required this.whereInVideo,
  });

  factory SendRagMessage.fromJson(Map<String, dynamic> json) => SendRagMessage(
    answer: json["answer"],
    whereInVideo: List<WhereInVideo>.from(json["where_in_video"].map((x) => WhereInVideo.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "answer": answer,
    "where_in_video": List<dynamic>.from(whereInVideo.map((x) => x.toJson())),
  };
}

class WhereInVideo {
  String sourceId;
  int segmentId;
  double start;
  double end;
  String timestamp;

  WhereInVideo({
    required this.sourceId,
    required this.segmentId,
    required this.start,
    required this.end,
    required this.timestamp,
  });

  factory WhereInVideo.fromJson(Map<String, dynamic> json) => WhereInVideo(
    sourceId: json["source_id"],
    segmentId: json["segment_id"],
    start: json["start"]?.toDouble(),
    end: json["end"]?.toDouble(),
    timestamp: json["timestamp"],
  );

  Map<String, dynamic> toJson() => {
    "source_id": sourceId,
    "segment_id": segmentId,
    "start": start,
    "end": end,
    "timestamp": timestamp,
  };
}
