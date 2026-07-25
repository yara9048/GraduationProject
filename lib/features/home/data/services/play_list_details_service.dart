import 'dart:io';

import 'package:dio/dio.dart';
import 'package:graduationprojct/features/home/data/models/playlist_details_model.dart';
import 'package:graduationprojct/features/home/data/models/video_details_model.dart';

import '../../../../core/dio.dart';

class PlayListDetailsService {

  Future<PlayListDetailsModel> getDetails({required int id}) async {
    final response = await DioHelper().get(
      "/playlists/$id/",
    );

    return PlayListDetailsModel.fromJson(response.data);
  }
}
