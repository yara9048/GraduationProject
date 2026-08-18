import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/display_videos_model.dart';
import '../data/services/display_videos_service.dart';

class DisplayVideosProvider with ChangeNotifier {
  final DisplayVideosService _service =
  DisplayVideosService();

  bool _isLoading = false;

  String? _errorMessage;

  int? _statusCode;

  List<DisplayVideosModel> _videos = [];


  bool get isLoading =>
      _isLoading;

  String? get errorMessage =>
      _errorMessage;

  int? get statusCode =>
      _statusCode;

  List<DisplayVideosModel> get videos =>
      List.unmodifiable(
        _videos,
      );

  bool get hasVideos =>
      _videos.isNotEmpty;

  bool get hasError =>
      _errorMessage != null;

  String get cleanedErrorMessage {
    final String message =
        _errorMessage ??
            'حدث خطأ غير معروف';

    return message
        .replaceFirst(
      'Exception:',
      '',
    )
        .replaceFirst(
      'DioException:',
      '',
    )
        .replaceAll(
      RegExp(r'\s+'),
      ' ',
    )
        .trim();
  }


  bool get subscriptionRequired {
    if (_statusCode == 403) {
      return true;
    }

    final String error =
    (_errorMessage ?? '')
        .toLowerCase();

    return error.contains(
      'subscription',
    ) ||
        error.contains(
          'subscribe',
        ) ||
        error.contains(
          'active subscription',
        ) ||
        error.contains(
          'unlock this playlist',
        ) ||
        error.contains(
          'اشتراك',
        ) ||
        error.contains(
          'مشترك',
        );
  }


  Future<void> getVideos({
    required int id,
  }) async {
    if (_isLoading) {
      return;
    }

    _isLoading = true;

    _errorMessage = null;

    _statusCode = null;

    _videos = [];

    notifyListeners();

    try {
      final prefs =
      await SharedPreferences
          .getInstance();

      final String? token =
      prefs.getString(
        'auth_token',
      );

      if (token == null ||
          token.trim().isEmpty) {
        throw Exception(
          'Authentication token not found',
        );
      }

      final result =
      await _service
          .getPlayLists(
        token: token,
        id: id,
      );

      _videos = result;
    } on DioException catch (e) {
      _statusCode =
          e.response?.statusCode;

      _videos = [];

      final responseData =
          e.response?.data;

      if (responseData is Map) {
        _errorMessage =
            responseData['detail']
                ?.toString() ??
                responseData['message']
                    ?.toString() ??
                responseData['error']
                    ?.toString() ??
                'تعذر تحميل الفيديوهات';
      } else if (responseData
      is String &&
          responseData.isNotEmpty) {
        _errorMessage =
            responseData;
      } else {
        _errorMessage =
            e.message ??
                'حدث خطأ أثناء تحميل الفيديوهات';
      }

      debugPrint(
        'Videos status code: $_statusCode',
      );

      debugPrint(
        'Videos error: $_errorMessage',
      );
    } catch (
    e,
    stackTrace
    ) {
    _videos = [];

    _errorMessage =
    e.toString();

    debugPrint(
    'Display videos error: $e',
    );

    debugPrintStack(
    stackTrace:
    stackTrace,
    );
    } finally {
    _isLoading = false;

    notifyListeners();
    }
  }

  void reset() {
    _isLoading = false;

    _errorMessage = null;

    _statusCode = null;

    _videos = [];

    notifyListeners();
  }
}