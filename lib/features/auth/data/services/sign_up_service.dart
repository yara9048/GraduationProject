import 'dart:io';

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
    required String major,
    required String password1,
    required String password2,
    required File image,
  }) async {
    try {
      final String imageName =
          image.path.split(Platform.pathSeparator).last;

      final FormData formData = FormData.fromMap({
        'email': email,
        'password1': password1,
        'password2': password2,
        'last_name': lastName,
        'first_name': firstName,
        'major': major,
        'image': await MultipartFile.fromFile(
          image.path,
          filename: imageName,
        ),
      });

      final response = await _dio.post(
        ApiEndpoints.register,
        data: formData,
      );

      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        return SignUpModel.fromJson(response.data);
      }

      throw 'فشل إنشاء الحساب: ${response.statusCode}';
    } on DioException catch (e) {
      if (e.response == null) {
        throw 'خطأ في الاتصال بالسيرفر';
      }

      final dynamic data = e.response?.data;

      if (data is Map) {
        if (data.containsKey('email')) {
          throw _extractErrorMessage(
            data['email'],
            fallback: 'البريد الإلكتروني غير صالح',
          );
        }

        if (data.containsKey('image')) {
          throw _extractErrorMessage(
            data['image'],
            fallback: 'حدث خطأ أثناء رفع الصورة',
          );
        }

        if (data.containsKey('password1')) {
          throw _extractErrorMessage(
            data['password1'],
            fallback: 'كلمة المرور غير صالحة',
          );
        }

        if (data.containsKey('password2')) {
          throw _extractErrorMessage(
            data['password2'],
            fallback: 'تأكيد كلمة المرور غير صالح',
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
            fallback: 'فشل إنشاء الحساب',
          );
        }

        if (data.containsKey('error')) {
          throw _extractErrorMessage(
            data['error'],
            fallback: 'فشل إنشاء الحساب',
          );
        }

        if (data.containsKey('detail')) {
          throw _extractErrorMessage(
            data['detail'],
            fallback: 'فشل إنشاء الحساب',
          );
        }

        final String allErrors = data.entries.map((entry) {
          return _extractErrorMessage(
            entry.value,
            fallback: entry.value.toString(),
          );
        }).join('\n');

        if (allErrors.isNotEmpty) {
          throw allErrors;
        }
      }

      final String errorString = data.toString();

      if (errorString.contains('duplicate key value') ||
          errorString.toLowerCase().contains('already exists') ||
          errorString.toLowerCase().contains('already registered')) {
        throw 'البريد الإلكتروني مستخدم مسبقًا';
      }

      throw 'خطأ غير متوقع: $errorString';
    } catch (e) {
      final String message = e.toString();

      if (message.startsWith('Exception: ')) {
        throw message.replaceFirst('Exception: ', '');
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
      return value.map((item) => item.toString()).join('\n');
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