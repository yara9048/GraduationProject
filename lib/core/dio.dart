import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioHelper {
  static final DioHelper _instance = DioHelper._internal();

  late final Dio _dio;
  late final Dio _refreshDio;

  factory DioHelper() => _instance;

  DioHelper._internal() {
    const String baseUrl = 'http://144.91.84.194:8459/en/api/';

    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
      ),
    );

    _refreshDio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
      ),
    );

    _dio.interceptors.add(
      QueuedInterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();

          final String? accessToken =
          prefs.getString('auth_token');

          if (accessToken != null &&
              accessToken.trim().isNotEmpty) {
            options.headers['Authorization'] =
            'Bearer ${accessToken.trim()}';
          }

          handler.next(options);
        },

        onError: (DioException error, handler) async {
          final int? statusCode = error.response?.statusCode;
          final String path = error.requestOptions.path;

          final bool isAuthRequest =
              path.contains('login') ||
                  path.contains('register') ||
                  path.contains('token/refresh') ||
                  path.contains('verify');

          if (isAuthRequest) {
            return handler.next(error);
          }

          if (statusCode != 401) {
            return handler.next(error);
          }

          final RequestOptions requestOptions =
              error.requestOptions;

          if (requestOptions.extra['retried'] == true) {
            return handler.next(error);
          }

          requestOptions.extra['retried'] = true;

          final prefs =
          await SharedPreferences.getInstance();

          final String? refreshToken =
          prefs.getString('refresh_token');

          if (refreshToken == null ||
              refreshToken.trim().isEmpty) {
            await _clearTokens();

            return handler.next(error);
          }

          try {
            print('Access token expired...');
            print('Trying refresh token...');

            final Response refreshResponse =
            await _refreshDio.post(
              'token/refresh/',
              data: {
                'refresh': refreshToken.trim(),
              },
            );

            final dynamic data = refreshResponse.data;

            if (data is! Map) {
              throw Exception(
                'Invalid refresh response',
              );
            }

            final String? newAccessToken =
            data['access']?.toString();

            if (newAccessToken == null ||
                newAccessToken.trim().isEmpty) {
              throw Exception(
                'Server did not return new access token',
              );
            }

            await prefs.setString(
              'auth_token',
              newAccessToken.trim(),
            );

            final String? newRefreshToken =
            data['refresh']?.toString();

            if (newRefreshToken != null &&
                newRefreshToken.trim().isNotEmpty) {
              await prefs.setString(
                'refresh_token',
                newRefreshToken.trim(),
              );
            }

            print('Access token refreshed successfully');

            requestOptions.headers['Authorization'] =
            'Bearer ${newAccessToken.trim()}';

            final Response response =
            await _dio.fetch(requestOptions);

            return handler.resolve(response);
          } on DioException catch (refreshError) {
            print(
              'Refresh token failed: '
                  '${refreshError.response?.data}',
            );

            await _clearTokens();

            return handler.next(error);
          } catch (e) {
            print('Refresh token error: $e');

            await _clearTokens();

            return handler.next(error);
          }
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

  static Future<void> _clearTokens() async {
    final prefs =
    await SharedPreferences.getInstance();

    await prefs.remove('auth_token');
    await prefs.remove('refresh_token');
    await prefs.remove('user_pk');
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

  Future<Response> put(
      String endpoint, {
        dynamic data,
        Map<String, dynamic>? query,
        Options? options,
      }) async {
    return _dio.put(
      endpoint,
      data: data,
      queryParameters: query,
      options: options,
    );
  }
}