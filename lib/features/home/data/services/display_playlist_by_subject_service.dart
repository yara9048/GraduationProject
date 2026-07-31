import 'package:dio/dio.dart';

import '../../../../core/dio.dart';
import '../../../../core/end_points.dart';
import '../models/display_favourite_model.dart';
import '../models/display_playlist_by_subject_model.dart';

class DisplayPlaylistBySubjectService {
  Future<List<DisplayPlayListBySubjectModel>> getPlaylists({required String token, required int id}) async {
    final response = await DioHelper().get(
      ApiEndpoints.coursesBySubject(id),
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    print(response.data);

    return List<DisplayPlayListBySubjectModel>.from(
      response.data.map(
            (x) => DisplayPlayListBySubjectModel.fromJson(x),
      ),
    );
  }
}