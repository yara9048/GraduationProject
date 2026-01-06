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
