import 'package:dio/dio.dart';

import '../../../../core/dio.dart';
import '../../../../core/end_points.dart';
import '../models/display_subjects_model.dart';

class DisplaySubjectsNoQueryService {
  Future<List<DisplaySubjectsModel>> getSubjects({
    required String token,
  }) async {
    final response = await DioHelper().get(
      ApiEndpoints.subjects,
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    print('SUBJECT RESPONSE: ${response.data}');

    return List<DisplaySubjectsModel>.from(
      response.data.map(
            (x) => DisplaySubjectsModel.fromJson(x),
      ),
    );
  }
}