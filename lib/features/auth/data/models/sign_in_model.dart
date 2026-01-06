// To parse this JSON data, do
//
//     final signUpModel = signUpModelFromJson(jsonString);

import 'dart:convert';

SignUpModel signUpModelFromJson(String str) => SignUpModel.fromJson(json.decode(str));

String signUpModelToJson(SignUpModel data) => json.encode(data.toJson());

class SignUpModel {
  String access;
  String refresh;
  User user;

  SignUpModel({
    required this.access,
    required this.refresh,
    required this.user,
  });

  factory SignUpModel.fromJson(Map<String, dynamic> json) => SignUpModel(
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
  int pk;
  String email;
  String firstName;
  String lastName;

  User({
    required this.pk,
    required this.email,
    required this.firstName,
    required this.lastName,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    pk: json["pk"],
    email: json["email"],
    firstName: json["first_name"],
    lastName: json["last_name"],
  );

  Map<String, dynamic> toJson() => {
    "pk": pk,
    "email": email,
    "first_name": firstName,
    "last_name": lastName,
  };
}
