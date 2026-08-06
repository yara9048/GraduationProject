import 'dart:convert';

List<ViewChatModel> viewChatModelFromJson(String str) =>
    List<ViewChatModel>.from(
      json.decode(str).map(
            (x) => ViewChatModel.fromJson(x),
      ),
    );

String viewChatModelToJson(List<ViewChatModel> data) =>
    json.encode(
      List<dynamic>.from(
        data.map((x) => x.toJson()),
      ),
    );


class ViewChatModel {
  final int id;
  final int user;
  final int video;
  final String title;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<Message> messages;

  ViewChatModel({
    required this.id,
    required this.user,
    required this.video,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    required this.messages,
  });


  factory ViewChatModel.fromJson(Map<String, dynamic> json) {
    return ViewChatModel(
      id: json["id"] ?? 0,
      user: json["user"] ?? 0,
      video: json["video"] ?? 0,
      title: json["title"] ?? "",

      createdAt: _parseDate(json["created_at"]),
      updatedAt: _parseDate(json["updated_at"]),

      messages: json["messages"] != null
          ? List<Message>.from(
        (json["messages"] as List)
            .map(
              (x) => Message.fromJson(x),
        ),
      )
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


  Message({
    required this.id,
    required this.chat,
    required this.sender,
    required this.text,
    required this.metadata,
    required this.createdAt,
  });


  factory Message.fromJson(Map<String, dynamic> json) {

    return Message(
      id: json["id"] ?? 0,
      chat: json["chat"] ?? 0,
      sender: json["sender"] ?? "",
      text: json["text"] ?? "",

      metadata: json["metadata"] != null
          ? Metadata.fromJson(json["metadata"])
          : Metadata(),

      createdAt: _parseDate(json["created_at"]),
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

  Metadata();


  factory Metadata.fromJson(Map<String, dynamic>? json) {
    return Metadata();
  }


  Map<String, dynamic> toJson() => {};
}





DateTime? _parseDate(dynamic value) {

  if(value == null || value.toString().isEmpty){
    return null;
  }

  try {

    return DateTime.parse(value.toString());

  } catch(e){

    return null;

  }
}