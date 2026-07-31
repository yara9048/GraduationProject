import 'dart:io';

import 'package:dio/dio.dart';

import '../../../../core/dio.dart';
import '../../../../core/end_points.dart';
import '../models/profile_model.dart';

class ProfileService {

  Future<ProfileModel> getProfile(String token) async {
    final response = await DioHelper().get(
      ApiEndpoints.profile,
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    return ProfileModel.fromJson(response.data);
  }
}
