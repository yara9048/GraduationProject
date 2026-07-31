import 'package:dio/dio.dart';
import 'package:graduationprojct/core/end_points.dart';
import 'package:graduationprojct/features/auth/data/models/new_password_model.dart';
import 'package:graduationprojct/features/auth/data/models/resend_otp_model.dart';
import 'package:graduationprojct/features/auth/data/models/reset_password_request_model.dart';
import 'package:graduationprojct/features/home/data/models/add_playlist_to_fav_model.dart';
import 'package:graduationprojct/features/home/data/models/funding_request_model.dart';
import 'package:graduationprojct/features/home/data/models/rating_playlist_model.dart';
import '../../../../../core/dio.dart';

class FundingRequestService {
  final DioHelper _dio = DioHelper();

  Future<FundingRequestModel> fund({
    required String token,
    required int amount,
    required String note,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.fundingRequest,
        data: {
          'amount': amount,
          'note':note,
        },
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return FundingRequestModel.fromJson(response.data);
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
