import 'package:dio/dio.dart';
import 'package:graduationprojct/features/home/data/models/ai_features_model.dart';

import '../../../../core/dio.dart';

class AiFeaturesService {
  Future<AiFeaturesModel> getAiFeatures({
    required String token,
    required int videoId,
  }) async {
    final response = await DioHelper().get(
      "videos/$videoId/ai_features/",
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );
    print(response.data);

    return AiFeaturesModel.fromJson(response.data);
  }
}