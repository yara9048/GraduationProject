import 'package:dio/dio.dart';
import 'package:graduationprojct/features/auth/data/models/edit_profile_model.dart';
import '../../../../../core/dio.dart';
import '../../../../core/end_points.dart';

class EditProfileService {
  final DioHelper _dio = DioHelper();

  Future<EditProfileModel> editProfile({
    String? firstName,
    String? secondName,
    String? major,
    String? token
  }) async {
    try {
      final data = <String, dynamic>{};

      if (firstName != null) {
        data['first_name'] = firstName;
      }

      if (secondName != null) {
        data['last_name'] = secondName;
      }

      if (major != null) {
        data['major'] = major;
      }

      final response = await _dio.put(
        ApiEndpoints.profile,
        data: data,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      if (response.statusCode == 200) {
        return EditProfileModel.fromJson(response.data);
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
