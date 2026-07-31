import 'dart:io';

import 'package:dio/dio.dart';

import '../../../../core/dio.dart';
import '../../../../core/end_points.dart';
import '../models/display_playlists_model.dart';
import '../../../auth/data/models/profile_model.dart';

class DisplayPlaylistsService {

  Future<List<DisplayPlaylistsModel>> getPlayLists({required String token}) async {
    final response = await DioHelper().get(
      ApiEndpoints.courses,
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );
     print(response.data);
    return List<DisplayPlaylistsModel>.from(
      response.data.map(
            (x) => DisplayPlaylistsModel.fromJson(x),
      ),
    );
  }
}
