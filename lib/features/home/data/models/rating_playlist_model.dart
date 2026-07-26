// To parse this JSON data, do
//
//     final ratingPlaylistModel = ratingPlaylistModelFromJson(jsonString);

import 'dart:convert';

RatingPlaylistModel ratingPlaylistModelFromJson(String str) => RatingPlaylistModel.fromJson(json.decode(str));

String ratingPlaylistModelToJson(RatingPlaylistModel data) => json.encode(data.toJson());

class RatingPlaylistModel {
  int id;
  int user;
  String userName;
  int playlist;
  int rating;
  String review;
  DateTime createdAt;

  RatingPlaylistModel({
    required this.id,
    required this.user,
    required this.userName,
    required this.playlist,
    required this.rating,
    required this.review,
    required this.createdAt,
  });

  factory RatingPlaylistModel.fromJson(Map<String, dynamic> json) => RatingPlaylistModel(
    id: json["id"],
    user: json["user"],
    userName: json["user_name"],
    playlist: json["playlist"],
    rating: json["rating"],
    review: json["review"],
    createdAt: DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user": user,
    "user_name": userName,
    "playlist": playlist,
    "rating": rating,
    "review": review,
    "created_at": createdAt.toIso8601String(),
  };
}
