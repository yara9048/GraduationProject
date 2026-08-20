// To parse this JSON data, do
//
//     final signInModel = signInModelFromJson(jsonString);

import 'dart:convert';

SignInModel signInModelFromJson(String str) => SignInModel.fromJson(json.decode(str));

String signInModelToJson(SignInModel data) => json.encode(data.toJson());

class SignInModel {
  String access;
  String refresh;
  User user;

  SignInModel({
    required this.access,
    required this.refresh,
    required this.user,
  });

  factory SignInModel.fromJson(Map<String, dynamic> json) => SignInModel(
    access: json["access"],
    refresh: json["refresh"],
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "access": access,
    "refresh": refresh,
    "user": user.toJson(),
  };
}

class User {
  int id;
  String email;
  String firstName;
  String lastName;
  String role;
  String major;
  int classId;
  String image;
  dynamic fcmToken;
  bool isActive;
  DateTime dateJoined;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.major,
    required this.classId,
    required this.image,
    required this.fcmToken,
    required this.isActive,
    required this.dateJoined,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    email: json["email"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    role: json["role"],
    major: json["major"],
    classId: json["class_id"],
    image: json["image"],
    fcmToken: json["fcm_token"],
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
    "class_id": classId,
    "image": image,
    "fcm_token": fcmToken,
    "is_active": isActive,
    "date_joined": dateJoined.toIso8601String(),
  };
}
