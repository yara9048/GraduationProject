import 'dart:io';

import 'package:dio/dio.dart';
import 'package:graduationprojct/features/home/data/models/video_details_model.dart';

import '../../../../core/dio.dart';
import '../../../../core/end_points.dart';

class VideoDetailsService {

  Future<VideoDetailsModel> getDetails({required int id}) async {
    final response = await DioHelper().get(
      ApiEndpoints.videoDetails(id),
    );

    return VideoDetailsModel.fromJson(response.data);
  }
}
