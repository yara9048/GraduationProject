import 'package:dio/dio.dart';

import '../../../../core/dio.dart';
import '../../../../core/end_points.dart';

class LogoutService {
  Future<void> logout(String token) async {
    await DioHelper().post(
      ApiEndpoints.logout,
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );
  }
}