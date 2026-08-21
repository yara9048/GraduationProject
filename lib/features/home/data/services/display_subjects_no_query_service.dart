import 'package:dio/dio.dart';

import '../../../../core/dio.dart';
import '../../../../core/end_points.dart';
import '../models/display_subjects_model.dart';

class DisplaySubjectsNoQueryService {
  Future<List<DisplaySubjectsModel>> getSubjects() async {
    final response = await DioHelper().get(
      ApiEndpoints.subjects,
    );

    print('SUBJECT RESPONSE: ${response.data}');

    return List<DisplaySubjectsModel>.from(
      response.data.map(
            (x) => DisplaySubjectsModel.fromJson(x),
      ),
    );
  }
}