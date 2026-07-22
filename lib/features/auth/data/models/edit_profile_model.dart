// To parse this JSON data, do
//
//     final editProfileModel = editProfileModelFromJson(jsonString);

import 'dart:convert';

EditProfileModel editProfileModelFromJson(String str) => EditProfileModel.fromJson(json.decode(str));

String editProfileModelToJson(EditProfileModel data) => json.encode(data.toJson());

class EditProfileModel {
  int id;
  String email;
  String firstName;
  String lastName;
  String role;
  String major;
  dynamic image;
  bool isActive;
  DateTime dateJoined;

  EditProfileModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.major,
    required this.image,
    required this.isActive,
    required this.dateJoined,
  });

  factory EditProfileModel.fromJson(Map<String, dynamic> json) => EditProfileModel(
    id: json["id"],
    email: json["email"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    role: json["role"],
    major: json["major"],
    image: json["image"],
    isActive: json["is_active"],
    dateJoined: DateTime.parse(json["date_joined"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "first_name": firstName,
    "last_name": lastName,
    "role": role,
    "major": major,
    "image": image,
    "is_active": isActive,
    "date_joined": dateJoined.toIso8601String(),
  };
}
