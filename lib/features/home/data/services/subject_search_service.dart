import 'package:dio/dio.dart';
import 'package:graduationprojct/features/home/data/models/display_subjects_model.dart';
import 'package:graduationprojct/features/home/data/models/now_showing_playlist_model.dart';

import '../../../../core/dio.dart';
import '../../../../core/end_points.dart';

class SubjectSearchService {
  Future<List<DisplaySubjectsModel>> subjectSearch(
      String token,
      String query
      ) async {
    final response = await DioHelper().get(
      ApiEndpoints.subjects,
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },

      ),query: {'search':query}
    );

    final data = response.data;

    if (data is! List) {
      throw Exception(
        "Expected API response to be a list, but received: ${data.runtimeType}",
      );
    }
    print(response.requestOptions.uri);
    print(response.data);
    return data
        .map(
          (item) => DisplaySubjectsModel.fromJson(
        Map<String, dynamic>.from(item),
      ),
    )
        .toList();
  }
}