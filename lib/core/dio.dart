import 'package:dio/dio.dart';

class DioHelper {
  static final DioHelper _instance = DioHelper._internal();
  late final Dio _dio;

  factory DioHelper() => _instance;

  DioHelper._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://kenan.graduate.sheenvalue.com/ar/api',
        headers: {
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
      ),
    );
  }

  Future<Response> get(
      String endpoint, {
        Map<String, dynamic>? query,
        Options? options,
      }) async {
    return _dio.get(
      endpoint,
      queryParameters: query,
      options: options,
    );
  }

  Future<Response> post(
      String endpoint, {
        dynamic data,
        Map<String, dynamic>? query,
        Options? options,
      }) async {
    return _dio.post(
      endpoint,
      data: data,
      queryParameters: query,
      options: options,
    );
  }
}
