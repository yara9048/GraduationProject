import 'package:dio/dio.dart';

import '../../../../core/dio.dart';
import '../models/playlist_by_class_model.dart';

class PlaylistByClassService {
  Future<List<PlaylistByClassModel>> getPlaylists({
    required String token,
    required int classId,
  }) async {
    final response = await DioHelper().get(
      'courses/by-class/$classId/',
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    print(response.data);

    return List<PlaylistByClassModel>.from(
      response.data.map(
            (x) => PlaylistByClassModel.fromJson(x),
      ),
    );
  }
}