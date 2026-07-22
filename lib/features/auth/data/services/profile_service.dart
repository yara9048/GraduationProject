import 'dart:io';

import 'package:dio/dio.dart';

import '../../../../core/dio.dart';
import '../models/profile_model.dart';

class ProfileService {

  Future<ProfileModel> getProfile(String token) async {
    final response = await DioHelper().get(
      "profile/",
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    return ProfileModel.fromJson(response.data);
  }
}
