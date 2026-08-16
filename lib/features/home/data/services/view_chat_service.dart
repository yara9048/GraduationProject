import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../models/view_chat_model.dart';
import '../../../../core/dio.dart';
import '../../../../core/end_points.dart';

class ViewChatService {
  Future<ViewChatModel> getChat({
    required String token,
    required int videoId,
  }) async {
    try {
      debugPrint('========== VIEW CHAT SERVICE ==========');
      debugPrint('videoId: $videoId');
      debugPrint(
        'endpoint: /en/api/chats/get-or-create/',
      );
      debugPrint(
        'query: {"video_id": $videoId}',
      );

      final response = await DioHelper().get(
       "chats/get-or-create/",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
        query: {
          'video_id': videoId,
        },
      );

      debugPrint('========== VIEW CHAT RESPONSE ==========');
      debugPrint('statusCode: ${response.statusCode}');
      debugPrint('Response Text:');
      debugPrint('${response.data}');
      debugPrint('========================================');

      final model = ViewChatModel.fromJson(
        response.data,
      );

      debugPrint('CHAT ID = ${model.id}');
      debugPrint(
        'MESSAGES COUNT = ${model.messages.length}',
      );

      return model;
    } on DioException catch (e) {
      debugPrint('========== VIEW CHAT DIO ERROR ==========');
      debugPrint('statusCode: ${e.response?.statusCode}');
      debugPrint('response: ${e.response?.data}');
      debugPrint('message: ${e.message}');
      debugPrint('=========================================');

      rethrow;
    } catch (e, stackTrace) {
      debugPrint('========== VIEW CHAT ERROR ==========');
      debugPrint('$e');
      debugPrint('$stackTrace');
      debugPrint('=====================================');

      rethrow;
    }
  }
}