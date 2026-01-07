import 'package:dio/dio.dart';
import 'package:graduationprojct/core/end_points.dart';
import 'package:graduationprojct/features/auth/data/models/new_password_model.dart';
import 'package:graduationprojct/features/auth/data/models/resend_otp_model.dart';
import 'package:graduationprojct/features/auth/data/models/reset_password_request_model.dart';
import '../../../../../core/dio.dart';

class NewPasswordService {
  final DioHelper _dio = DioHelper();

  Future<NewPasswordModel> newPassword({
    required String email,
    required String password1,
    required String password2,

  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.newPassword,
        data: {
          'email': email,
          'new_password1': password1,
          'new_password2': password2,

        },
      );

      if (response.statusCode == 200) {
        return NewPasswordModel.fromJson(response.data);
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
