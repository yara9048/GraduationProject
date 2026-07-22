
// To parse this JSON data, do
//
//     final addToFavModel = addToFavModelFromJson(jsonString);

import 'dart:convert';

AddToFavModel addToFavModelFromJson(String str) => AddToFavModel.fromJson(json.decode(str));

String addToFavModelToJson(AddToFavModel data) => json.encode(data.toJson());

class AddToFavModel {
  String status;

  AddToFavModel({
    required this.status,
  });

  factory AddToFavModel.fromJson(Map<String, dynamic> json) => AddToFavModel(
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
  };
}
