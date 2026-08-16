import 'dart:io';

import 'package:dio/dio.dart';
import 'package:graduationprojct/features/home/data/models/playlist_details_model.dart';
import 'package:graduationprojct/features/home/data/models/video_details_model.dart';

import '../../../../core/dio.dart';
import '../../../../core/end_points.dart';

class PlayListDetailsService {

  Future<PlayListDetailsModel> getDetails({required int id, required String token}) async {
    final response = await DioHelper().get(
      ApiEndpoints.courseDetails(id),
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );
    print(response.data);
    return PlayListDetailsModel.fromJson(response.data);
  }
}
