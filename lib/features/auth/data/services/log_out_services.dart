import 'package:dio/dio.dart';

import '../../../../core/dio.dart';

class LogoutService {
  Future<void> logout(String token) async {
    await DioHelper().post(
      "logout/",
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );
  }
}