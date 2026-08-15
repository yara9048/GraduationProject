// To parse this JSON data, do
//
//     final webSearchModel = webSearchModelFromJson(jsonString);

import 'dart:convert';

WebSearchModel webSearchModelFromJson(String str) => WebSearchModel.fromJson(json.decode(str));

String webSearchModelToJson(WebSearchModel data) => json.encode(data.toJson());

class WebSearchModel {
  String answer;

  WebSearchModel({
    required this.answer,
  });

  factory WebSearchModel.fromJson(Map<String, dynamic> json) => WebSearchModel(
    answer: json["answer"],
  );

  Map<String, dynamic> toJson() => {
    "answer": answer,
  };
}
