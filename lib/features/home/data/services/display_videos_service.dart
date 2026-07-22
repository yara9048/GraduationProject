import 'dart:io';

import 'package:dio/dio.dart';
import 'package:graduationprojct/features/home/ui/pages/display_videos_page.dart';

import '../../../../core/dio.dart';
import '../models/display_playlists_model.dart';
import '../../../auth/data/models/profile_model.dart';
import '../models/display_videos_model.dart';

class DisplayVideosService {

  Future<List<DisplayVideosModel>> getPlayLists({required int id}) async {
    final response = await DioHelper().get(
      "/playlists/$id/videos/",
    );
    print(response.data);
    return List<DisplayVideosModel>.from(
      response.data.map(
            (x) => DisplayVideosModel.fromJson(x),
      ),
    );
  }
}
