import 'package:dio/dio.dart';
import 'package:graduationprojct/core/end_points.dart';
import 'package:graduationprojct/features/auth/data/models/new_password_model.dart';
import 'package:graduationprojct/features/auth/data/models/resend_otp_model.dart';
import 'package:graduationprojct/features/auth/data/models/reset_password_request_model.dart';
import 'package:graduationprojct/features/home/data/models/add_playlist_to_fav_model.dart';
import 'package:graduationprojct/features/home/data/models/rating_playlist_model.dart';
import '../../../../../core/dio.dart';
import '../models/send_rag_message_model.dart';

class SendRagMessageService {
  final DioHelper _dio = DioHelper();

  Future<SendRagMessage> sendRag({
    required String token,
    required String question,
    required int videoId,
  }) async {
    try {
      final response = await _dio.post(
        'chats/ask-service/',
        data: {
          'question':question,
          'video_id':videoId
        },
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return SendRagMessage.fromJson(response.data);
      } else {
        throw Exception('فشل مع: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode == 400) {
        throw 'بيانات الادخال خاطئة';
      }
      else if (e.response != null && e.response!.statusCode == 404) {
        throw 'غير موجود';
      } else {
        throw e.response?.data['message'] ??
            e.response?.data['error'] ??
            'خطأ غير متوقع';
      }
    } catch (e) {
      throw 'خطأ: $e';
    }
  }
}
