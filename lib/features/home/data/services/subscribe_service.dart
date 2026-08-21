import 'package:dio/dio.dart';
import 'package:graduationprojct/core/end_points.dart';
import 'package:graduationprojct/features/home/data/models/subscribe_model.dart';

import '../../../../../core/dio.dart';

class SubscribeService {
  final DioHelper _dio = DioHelper();

  Future<SubscribeModel> subscribe({
    required int id,
    required String token,
    required int playlistId,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.purchaseSubscription,
        data: {
          'user': id,
          'is active': "true",
          'playlist': playlistId,
        },
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        return SubscribeModel.fromJson(response.data);
      } else {
        throw Exception(
          'فشل مع: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      final response = e.response;

      if (response != null) {
        final data = response.data;

        if (data is Map<String, dynamic>) {
          final errorMessage =
              data['error'] ??
                  data['message'] ??
                  data['detail'];

          if (errorMessage != null) {
            throw errorMessage.toString();
          }
        }

        if (response.statusCode == 404) {
          throw 'غير موجود';
        }

        if (response.statusCode == 400) {
          throw 'حدث خطأ في الاشتراك';
        }
      }

      throw 'خطأ غير متوقع';
    } catch (e) {
      throw 'خطأ: $e';
    }
  }
}