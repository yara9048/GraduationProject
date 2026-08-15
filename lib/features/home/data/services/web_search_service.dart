import 'package:dio/dio.dart';
import 'package:graduationprojct/features/home/data/models/web_search_model.dart';

class WebSearchService {
  late final Dio _dio;

  WebSearchService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'http://144.91.84.194:8000/',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );

    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
      ),
    );
  }

  Future<WebSearchModel> webSearch({
    required String question,
  }) async {
    try {
      final response = await _dio.post(
        'ask',
        data: {
          'question': question,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return WebSearchModel.fromJson(response.data);
      }

      throw Exception('فشل الطلب: ${response.statusCode}');
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw 'بيانات الإدخال خاطئة';
      }

      if (e.response?.statusCode == 401) {
        throw 'غير مصرح لك';
      }

      if (e.response?.statusCode == 404) {
        throw 'غير موجود';
      }

      final data = e.response?.data;

      if (data is Map<String, dynamic>) {
        throw data['message'] ??
            data['error'] ??
            data['detail'] ??
            'خطأ غير متوقع';
      }

      throw 'خطأ في الاتصال بالسيرفر';
    } catch (e) {
      throw 'خطأ: $e';
    }
  }
}