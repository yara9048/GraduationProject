import 'package:dio/dio.dart';
import 'package:graduationprojct/features/home/data/models/ai_features_model.dart';

import '../../../../core/dio.dart';
import '../../../../core/end_points.dart';
import '../models/regenerate_mcq_model.dart';

class RegenerateMcqService {
  Future<RegnerateMcqModel> regenerate({
    required String token,
    required int videoId,
  }) async {
    final response = await DioHelper().get(
      "mcqs/regenerate/",
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );
    print(response.data);

    return RegnerateMcqModel.fromJson(response.data);
  }
}