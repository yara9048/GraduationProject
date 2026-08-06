import 'package:dio/dio.dart';
import 'package:graduationprojct/features/home/data/models/teacher_model.dart';

import '../../../../core/dio.dart';
import '../../../../core/end_points.dart';
import '../models/display_favourite_model.dart';

class TeachersServices {
  Future<List<TeacherModel>> getTeachers({required String token, required int id}) async {
    final response = await DioHelper().get(
      ApiEndpoints.teachers(id),
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    print(response.data);

    return List<TeacherModel>.from(
      response.data.map(
            (x) => TeacherModel.fromJson(x),
      ),
    );
  }
}