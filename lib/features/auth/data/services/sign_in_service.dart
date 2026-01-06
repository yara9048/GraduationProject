import 'package:dio/dio.dart';
import 'package:graduationprojct/core/end_points.dart';
import '../../../../core/dio.dart';
import '../models/sign_in_model.dart';

class SignInService {
  final DioHelper _dio = DioHelper();

  Future<SignUpModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        return SignUpModel.fromJson(response.data);
      } else if (response.statusCode == 400) {
        throw Exception("Wrong login data");
      } else {
        throw Exception('Failed with status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw e.response?.data['message'] ??
          e.response?.data['error'] ??
          'Login failed';
    } catch (e) {
      throw 'Unexpected error: $e';
    }
  }
}
