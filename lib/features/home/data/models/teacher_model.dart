import 'dart:convert';

List<TeacherModel> teacherModelFromJson(String str) => List<TeacherModel>.from(
  json.decode(str).map((x) => TeacherModel.fromJson(x)),
);

String teacherModelToJson(List<TeacherModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TeacherModel {
  final int id;
  final String email;
  final String name;
  final String firstName;
  final String lastName;
  final String role;
  final String major;
  final List<TeachingClass> teachingClasses;
  final String? image;

  TeacherModel({
    required this.id,
    required this.email,
    required this.name,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.major,
    required this.teachingClasses,
    this.image,
  });

  factory TeacherModel.fromJson(Map<String, dynamic> json) {
    return TeacherModel(
      id: json["id"] ?? 0,

      email: json["email"] ?? "",

      name: json["name"] ?? "",

      firstName: json["first_name"] ?? "",

      lastName: json["last_name"] ?? "",

      role: json["role"] ?? "",

      major: json["major"] ?? "",

      teachingClasses: json["teaching_classes"] is List
          ? List<TeachingClass>.from(
              json["teaching_classes"].map((x) => TeachingClass.fromJson(x)),
            )
          : [],

      image: json["image"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,

      "email": email,

      "name": name,

      "first_name": firstName,

      "last_name": lastName,

      "role": role,

      "major": major,

      "teaching_classes": teachingClasses.map((e) => e.toJson()).toList(),

      "image": image,
    };
  }
}

class TeachingClass {
  final int id;
  final String name;
  final String slug;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  TeachingClass({
    required this.id,

    required this.name,

    required this.slug,

    this.createdAt,

    this.updatedAt,
  });

  factory TeachingClass.fromJson(Map<String, dynamic> json) {
    return TeachingClass(
      id: json["id"] ?? 0,

      name: json["name"] ?? "",

      slug: json["slug"] ?? "",

      createdAt: json["created_at"] != null
          ? DateTime.tryParse(json["created_at"])
          : null,

      updatedAt: json["updated_at"] != null
          ? DateTime.tryParse(json["updated_at"])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,

      "name": name,

      "slug": slug,

      "created_at": createdAt?.toIso8601String(),

      "updated_at": updatedAt?.toIso8601String(),
    };
  }
}
