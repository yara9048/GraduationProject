import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:graduationprojct/features/home/data/models/get_video_progress_model.dart';
import 'package:graduationprojct/features/home/data/services/get_video_progress_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetVideoProgressProvider
    with ChangeNotifier {
  final GetVideoProgressService _service =
  GetVideoProgressService();

  bool _isLoading = false;
  String? _errorMessage;
  int? _statusCode;

  List<GetVideoProgressModel> _progress = [];

  bool get isLoading => _isLoading;

  String? get errorMessage =>
      _errorMessage;

  int? get statusCode =>
      _statusCode;

  List<GetVideoProgressModel> get progress =>
      List.unmodifiable(_progress);

  Future<void> getProgress({
    required int id,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _statusCode = null;

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
          token.isEmpty) {
        throw Exception(
          'Authentication token not found',
        );
      }

      _progress =
      await _service.getProgress(
        token: token,
        id: id,
      );

      debugPrint(
        'Loaded video progress count: '
            '${_progress.length}',
      );
    } on DioException catch (e) {
      _statusCode =
          e.response?.statusCode;

      _progress = [];

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
                'تعذر تحميل التقدم';
      } else if (responseData
      is String &&
          responseData.isNotEmpty) {
        _errorMessage =
            responseData;
      } else {
        _errorMessage =
            e.message ??
                'حدث خطأ أثناء تحميل التقدم';
      }

      debugPrint(
        'Progress status code: '
            '$_statusCode',
      );

      debugPrint(
        'Progress error: '
            '$_errorMessage',
      );
    } catch (e, stackTrace) {
      _progress = [];
      _errorMessage =
          e.toString();

      debugPrint(
        'Display progress error: $e',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  GetVideoProgressModel? progressForVideo(
      int videoId,
      ) {
    for (final item in _progress) {
      if (item.video == videoId) {
        return item;
      }
    }

    return null;
  }

  double initialProgressForVideo(
      int videoId,
      ) {
    final GetVideoProgressModel? item =
    progressForVideo(videoId);

    if (item == null) {
      return 0.0;
    }

    final double percentage =
    item.progressPercentage
        .toDouble();

    return (percentage / 100)
        .clamp(0.0, 1.0)
        .toDouble();
  }

  int initialSecondsForVideo(
      int videoId,
      ) {
    final GetVideoProgressModel? item =
    progressForVideo(videoId);

    if (item == null) {
      return 0;
    }

    return item.progressSeconds
        .toInt();
  }

  void reset() {
    _isLoading = false;
    _errorMessage = null;
    _statusCode = null;
    _progress = [];

    notifyListeners();
  }
}