import 'package:dio/dio.dart';
import 'package:graduationprojct/features/home/data/models/now_showing_playlist_model.dart';

import '../../../../core/dio.dart';
import '../../../../core/end_points.dart';

class NowShowingPlaylistsService {
  Future<List<NowShowingPlaylistModel>> getNowShowingPlaylists(
      String token,
      ) async {
    final response = await DioHelper().get(
      ApiEndpoints.watchingNow,
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    final data = response.data;

    if (data is! List) {
      throw Exception(
        "Expected API response to be a list, but received: ${data.runtimeType}",
      );
    }

    return data
        .map(
          (item) => NowShowingPlaylistModel.fromJson(
        Map<String, dynamic>.from(item),
      ),
    )
        .toList();
  }
}