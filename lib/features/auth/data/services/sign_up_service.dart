import 'package:dio/dio.dart';
import 'package:graduationprojct/core/end_points.dart';
import 'package:graduationprojct/features/auth/data/models/sign_up_model.dart';
import '../../../../../core/dio.dart';

class SignUpService {
  final DioHelper _dio = DioHelper();

  Future<SignUpModel> signUp({
    required String email,
    required String firstName,
    required String lastName,
    required String password1,
    required String password2,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.register,
        data: {
          'email': email,
          'password1': password1,
          'password2': password2,
          'last_name': lastName,
          'first_name': firstName,
        },
      );

      if (response.statusCode == 201) {
        return SignUpModel.fromJson(response.data);
      } else {
        throw Exception('فشل مع: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final data = e.response!.data;
        if (data is Map<String, dynamic>) {
          if (data.containsKey('message')) {
            throw data['message'];
          } else if (data.containsKey('error')) {
            throw data['error'];
          }
        }
        final errorString = data.toString();
        if (errorString.contains('duplicate key value')) {
          throw 'البريد الإلكتروني مستخدم مسبقًا';
        }
        throw 'خطأ غير متوقع: ${errorString}';
      } else {
        throw 'خطأ في الاتصال بالسيرفر';
      }
    } catch (e) {
      throw 'خطأ: $e';
    }
  }
}
