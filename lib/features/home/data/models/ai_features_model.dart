// To parse this JSON data, do
//
//     final aiFeaturesModel = aiFeaturesModelFromJson(jsonString);

import 'dart:convert';

AiFeaturesModel aiFeaturesModelFromJson(String str) => AiFeaturesModel.fromJson(json.decode(str));

String aiFeaturesModelToJson(AiFeaturesModel data) => json.encode(data.toJson());

class AiFeaturesModel {
  List<Summary> summaries;
  List<Mcq> mcqs;
  List<Chat> chats;

  AiFeaturesModel({
    required this.summaries,
    required this.mcqs,
    required this.chats,
  });

  factory AiFeaturesModel.fromJson(Map<String, dynamic> json) => AiFeaturesModel(
    summaries: List<Summary>.from(json["summaries"].map((x) => Summary.fromJson(x))),
    mcqs: List<Mcq>.from(json["mcqs"].map((x) => Mcq.fromJson(x))),
    chats: List<Chat>.from(json["chats"].map((x) => Chat.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "summaries": List<dynamic>.from(summaries.map((x) => x.toJson())),
    "mcqs": List<dynamic>.from(mcqs.map((x) => x.toJson())),
    "chats": List<dynamic>.from(chats.map((x) => x.toJson())),
  };
}

class Chat {
  int id;
  int user;
  int video;
  String title;
  DateTime createdAt;
  DateTime updatedAt;
  List<Message> messages;

  Chat({
    required this.id,
    required this.user,
    required this.video,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    required this.messages,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
    id: json["id"],
    user: json["user"],
    video: json["video"],
    title: json["title"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    messages: List<Message>.from(json["messages"].map((x) => Message.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user": user,
    "video": video,
    "title": title,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "messages": List<dynamic>.from(messages.map((x) => x.toJson())),
  };
}

class Message {
  int id;
  int chat;
  String sender;
  String text;
  String metadata;
  DateTime createdAt;

  Message({
    required this.id,
    required this.chat,
    required this.sender,
    required this.text,
    required this.metadata,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    id: json["id"],
    chat: json["chat"],
    sender: json["sender"],
    text: json["text"],
    metadata: json["metadata"],
    createdAt: DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "chat": chat,
    "sender": sender,
    "text": text,
    "metadata": metadata,
    "created_at": createdAt.toIso8601String(),
  };
}

class Mcq {
  int id;
  int video;
  String question;
  List<String> options;
  String answer;
  DateTime createdAt;
  DateTime updatedAt;

  Mcq({
    required this.id,
    required this.video,
    required this.question,
    required this.options,
    required this.answer,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Mcq.fromJson(Map<String, dynamic> json) => Mcq(
    id: json["id"],
    video: json["video"],
    question: json["question"],
    options: List<String>.from(json["options"].map((x) => x)),
    answer: json["answer"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "video": video,
    "question": question,
    "options": List<dynamic>.from(options.map((x) => x)),
    "answer": answer,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}

class Summary {
  int id;
  int video;
  String type;
  dynamic data;
  DateTime createdAt;
  DateTime updatedAt;

  Summary({
    required this.id,
    required this.video,
    required this.type,
    required this.data,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
    id: json["id"],
    video: json["video"],
    type: json["type"],
    data: json["data"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "video": video,
    "type": type,
    "data": data,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}

class DataClass {
  String text;

  DataClass({
    required this.text,
  });

  factory DataClass.fromJson(Map<String, dynamic> json) => DataClass(
    text: json["text"],
  );

  Map<String, dynamic> toJson() => {
    "text": text,
  };
}
