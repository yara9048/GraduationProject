// To parse this JSON data, do
//
//     final addVideoToFavModel = addVideoToFavModelFromJson(jsonString);

import 'dart:convert';

AddVideoToFavModel addVideoToFavModelFromJson(String str) => AddVideoToFavModel.fromJson(json.decode(str));

String addVideoToFavModelToJson(AddVideoToFavModel data) => json.encode(data.toJson());

class AddVideoToFavModel {
  String status;

  AddVideoToFavModel({
    required this.status,
  });

  factory AddVideoToFavModel.fromJson(Map<String, dynamic> json) => AddVideoToFavModel(
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
  };
}
