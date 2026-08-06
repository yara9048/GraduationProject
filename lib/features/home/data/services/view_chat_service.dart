import 'package:dio/dio.dart';
import 'package:graduationprojct/features/home/data/models/get_video_progress_model.dart';
import 'package:graduationprojct/features/home/data/models/view_chat_model.dart';

import '../../../../core/dio.dart';
import '../../../../core/end_points.dart';

class ViewChatService {
  final DioHelper _dio =
  DioHelper();

  Future<List<ViewChatModel>>
  getChat({
    required int id,
    required String token,
  }) async {
    final response =
    await _dio.get(
      ApiEndpoints.chats,
      options: Options(
        headers: {
          'Authorization':
          'Bearer $token',
        },
      ),
    );

    final dynamic responseData =
        response.data;

    if (responseData is! List) {
      throw Exception(
        'صيغة بيانات التقدم غير صحيحة',
      );
    }

    return responseData
        .whereType<Map>()
        .map(
          (item) =>
          ViewChatModel
              .fromJson(
            Map<String, dynamic>.from(
              item,
            ),
          ),
    )
        .toList();
  }
}