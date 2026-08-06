import 'dart:convert';

CreateChatModel createChatModelFromJson(String str) =>
    CreateChatModel.fromJson(json.decode(str));

String createChatModelToJson(CreateChatModel data) =>
    json.encode(data.toJson());


class CreateChatModel {

  final int id;
  final int user;
  final int video;
  final String title;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<dynamic> messages;


  CreateChatModel({
    required this.id,
    required this.user,
    required this.video,
    required this.title,
    this.createdAt,
    this.updatedAt,
    required this.messages,
  });


  factory CreateChatModel.fromJson(
      Map<String, dynamic> json,
      ) {

    return CreateChatModel(

      id: json["id"] ?? 0,

      user: json["user"] ?? 0,

      video: json["video"] ?? 0,

      title: json["title"] ?? "",


      createdAt:
      json["created_at"] != null
          ? DateTime.tryParse(
        json["created_at"],
      )
          : null,


      updatedAt:
      json["updated_at"] != null
          ? DateTime.tryParse(
        json["updated_at"],
      )
          : null,


      messages:
      json["messages"] is List
          ? List<dynamic>.from(
        json["messages"],
      )
          : [],

    );
  }


  Map<String, dynamic> toJson() => {

    "id": id,

    "user": user,

    "video": video,

    "title": title,

    "created_at":
    createdAt?.toIso8601String(),

    "updated_at":
    updatedAt?.toIso8601String(),

    "messages": messages,

  };
}