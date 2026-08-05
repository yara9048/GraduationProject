import 'package:flutter/material.dart';
import 'package:graduationprojct/features/home/data/models/video_progress_model.dart';
import 'package:graduationprojct/features/home/data/services/video_progress_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'video_details_function_provider.dart';

class VideoProgressProvider
    with ChangeNotifier {
  final VideoProgressService _service =
  VideoProgressService();

  bool _isLoading = false;
  bool _isSuccess = false;

  String? _errorMessage;

  VideoProgessModel? _response;

  bool get isLoading => _isLoading;

  bool get isSuccess => _isSuccess;

  String? get errorMessage =>
      _errorMessage;

  VideoProgessModel? get response =>
      _response;

  Future<bool> progress({
    required int videoId,
    required bool isCompleted,
    required int seconds,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _isSuccess = false;
    _response = null;

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

      final int safeSeconds =
      seconds < 0 ? 0 : seconds;

      _response =
      await _service.postProgress(
        token: token,
        videoId: videoId,
        seconds: safeSeconds,
        isCompleted: isCompleted,
      );

      _isSuccess = true;
      _errorMessage = null;

      return true;
    } catch (e, stackTrace) {
      _isSuccess = false;

      _errorMessage =
          _cleanErrorMessage(
            e.toString(),
          );

      debugPrint(
        'Video progress error: $e',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> saveProgressSnapshot({
    required int videoId,
    required VideoProgressSnapshot snapshot,
  }) async {
    debugPrint(
      'Saving video progress after leaving page',
    );

    debugPrint(
      'Video ID: $videoId',
    );

    debugPrint(
      'Progress seconds: '
          '${snapshot.progressSeconds}',
    );

    debugPrint(
      'Duration seconds: '
          '${snapshot.durationSeconds}',
    );

    debugPrint(
      'Is completed: '
          '${snapshot.isCompleted}',
    );

    return progress(
      videoId: videoId,
      seconds: snapshot.progressSeconds,
      isCompleted: snapshot.isCompleted,
    );
  }

  void reset() {
    _isLoading = false;
    _isSuccess = false;
    _errorMessage = null;
    _response = null;

    notifyListeners();
  }

  String _cleanErrorMessage(
      String error,
      ) {
    return error
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
}