import 'package:dio/dio.dart';
import 'package:graduationprojct/core/end_points.dart';
import 'package:graduationprojct/features/auth/data/models/resend_otp_model.dart';
import '../../../../../core/dio.dart';

class ResendOtpService {
  final DioHelper _dio = DioHelper();

  Future<ResendOtpModel> resendOtp({
    required String email,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.resendOtp,
        data: {
          'email': email,
        },
      );

      if (response.statusCode == 200) {
        return ResendOtpModel.fromJson(response.data);
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
