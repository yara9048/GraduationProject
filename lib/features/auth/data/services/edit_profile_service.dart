import 'dart:io';

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
    File? image,
    required String token,
  }) async {
    try {
      final Map<String, dynamic> data = {};

      if (firstName != null) {
        data['first_name'] = firstName;
      }

      if (secondName != null) {
        data['last_name'] = secondName;
      }

      if (major != null) {
        data['major'] = major;
      }

      if (image != null) {
        final String imageName =
            image.path
                .split(Platform.pathSeparator)
                .last;

        data['image'] =
        await MultipartFile.fromFile(
          image.path,
          filename: imageName,
        );
      }

      final FormData formData =
      FormData.fromMap(data);

      final response = await _dio.put(
        ApiEndpoints.profile,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        return EditProfileModel.fromJson(
          response.data,
        );
      }

      throw 'فشل تعديل الملف الشخصي: '
          '${response.statusCode}';
    } on DioException catch (e) {
      if (e.response == null) {
        throw 'خطأ في الاتصال بالسيرفر';
      }

      final dynamic data = e.response?.data;

      if (data is Map) {
        if (data.containsKey('image')) {
          throw _extractErrorMessage(
            data['image'],
            fallback:
            'حدث خطأ أثناء رفع الصورة',
          );
        }

        if (data.containsKey('first_name')) {
          throw _extractErrorMessage(
            data['first_name'],
            fallback: 'الاسم غير صالح',
          );
        }

        if (data.containsKey('last_name')) {
          throw _extractErrorMessage(
            data['last_name'],
            fallback: 'الكنية غير صالحة',
          );
        }

        if (data.containsKey('major')) {
          throw _extractErrorMessage(
            data['major'],
            fallback: 'الاختصاص غير صالح',
          );
        }

        if (data.containsKey('message')) {
          throw _extractErrorMessage(
            data['message'],
            fallback: 'فشل تعديل الملف الشخصي',
          );
        }

        if (data.containsKey('error')) {
          throw _extractErrorMessage(
            data['error'],
            fallback: 'فشل تعديل الملف الشخصي',
          );
        }

        if (data.containsKey('detail')) {
          throw _extractErrorMessage(
            data['detail'],
            fallback: 'فشل تعديل الملف الشخصي',
          );
        }

        final String allErrors =
        data.entries.map((entry) {
          return _extractErrorMessage(
            entry.value,
            fallback: entry.value.toString(),
          );
        }).join('\n');

        if (allErrors.trim().isNotEmpty) {
          throw allErrors;
        }
      }

      final int? statusCode =
          e.response?.statusCode;

      if (statusCode == 400) {
        throw 'بيانات الإدخال خاطئة';
      }

      if (statusCode == 401) {
        throw 'انتهت صلاحية تسجيل الدخول';
      }

      if (statusCode == 404) {
        throw 'الحساب غير موجود';
      }

      throw 'خطأ غير متوقع: ${data.toString()}';
    } catch (e) {
      final String message = e.toString();

      if (message.startsWith('Exception: ')) {
        throw message.replaceFirst(
          'Exception: ',
          '',
        );
      }

      throw message;
    }
  }

  String _extractErrorMessage(
      dynamic value, {
        required String fallback,
      }) {
    if (value == null) {
      return fallback;
    }

    if (value is List) {
      return value
          .map((item) => item.toString())
          .join('\n');
    }

    if (value is Map) {
      return value.values
          .map(
            (item) => _extractErrorMessage(
          item,
          fallback: fallback,
        ),
      )
          .join('\n');
    }

    final String message = value.toString();

    if (message.trim().isEmpty) {
      return fallback;
    }

    return message;
  }
}