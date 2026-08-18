import 'dart:async';

import 'package:flutter/material.dart';

import 'add_video_to_fav_provider.dart';
import 'get_video_progress_provider.dart';
import 'video_details_function_provider.dart';
import 'video_details_provider.dart';
import 'video_progress_provider.dart';
import 'view_chat_provider.dart';

class FunctionsForVideoDetailsProvider with ChangeNotifier {
  bool _isFavorite = false;
  bool _videoInitialized = false;
  bool _isLeavingPage = false;
  bool _segmentFinished = false;
  Timer? _segmentTimer;

  bool get isFavorite => _isFavorite;
  bool get videoInitialized => _videoInitialized;
  bool get isLeavingPage => _isLeavingPage;

  Future<void> loadVideo({
    required int videoId,
    required double? startAtSeconds,
    required double? endAtSeconds,
    required VideoDetailsProvider detailsProvider,
    required VideoDetailsFunctionProvider videoFunctionProvider,
    required GetVideoProgressProvider getProgressProvider,
  }) async {
    _segmentTimer?.cancel();
    _segmentTimer = null;
    _segmentFinished = false;
    _videoInitialized = false;
    _isLeavingPage = false;
    _isFavorite = false;
    notifyListeners();

    await detailsProvider.getDetails(id: videoId);

    final details = detailsProvider.videoDetails;
    final String? videoUrl = details?.videoFile;
    final Object? durationMinutes = details?.duration;

    await getProgressProvider.getProgress(id: videoId);

    final double initialProgress =
    getProgressProvider.initialProgressForVideo(videoId);

    videoFunctionProvider.setInitialWatchProgress(initialProgress);

    await videoFunctionProvider.initializeVideo(
      videoUrl,
      durationMinutes: durationMinutes,
    );

    await _applyRequestedVideoSegment(
      provider: videoFunctionProvider,
      startAtSeconds: startAtSeconds,
      endAtSeconds: endAtSeconds,
    );

    _videoInitialized = true;
    notifyListeners();
  }

  Future<void> reloadVideo({
    required int videoId,
    required double? startAtSeconds,
    required double? endAtSeconds,
    required VideoDetailsProvider detailsProvider,
    required VideoDetailsFunctionProvider videoFunctionProvider,
    required GetVideoProgressProvider getProgressProvider,
  }) async {
    await videoFunctionProvider.releaseVideo(
      notify: false,
      resetProgress: true,
    );

    await loadVideo(
      videoId: videoId,
      startAtSeconds: startAtSeconds,
      endAtSeconds: endAtSeconds,
      detailsProvider: detailsProvider,
      videoFunctionProvider: videoFunctionProvider,
      getProgressProvider: getProgressProvider,
    );
  }

  Future<void> _applyRequestedVideoSegment({
    required VideoDetailsFunctionProvider provider,
    required double? startAtSeconds,
    required double? endAtSeconds,
  }) async {
    if (startAtSeconds == null) {
      return;
    }

    final controller = provider.videoPlayerController;

    if (controller == null || !controller.value.isInitialized) {
      return;
    }

    _segmentTimer?.cancel();
    _segmentFinished = false;

    int targetMilliseconds = (startAtSeconds * 1000).round();
    final int videoDurationMilliseconds =
        controller.value.duration.inMilliseconds;

    if (targetMilliseconds < 0) {
      targetMilliseconds = 0;
    }

    if (videoDurationMilliseconds > 0 &&
        targetMilliseconds > videoDurationMilliseconds) {
      targetMilliseconds = videoDurationMilliseconds;
    }

    try {
      await provider.seekToSeconds(targetMilliseconds ~/ 1000);

      await controller.seekTo(
        Duration(milliseconds: targetMilliseconds),
      );

      await provider.play();

      _startTimestampSegmentWatcher(
        provider: provider,
        endAtSeconds: endAtSeconds,
      );
    } catch (error) {
      debugPrint('Failed to open timestamp segment: $error');
    }
  }

  void _startTimestampSegmentWatcher({
    required VideoDetailsFunctionProvider provider,
    required double? endAtSeconds,
  }) {
    if (endAtSeconds == null || endAtSeconds <= 0) {
      return;
    }

    _segmentTimer?.cancel();

    _segmentTimer = Timer.periodic(
      const Duration(milliseconds: 100),
          (_) {
        if (_segmentFinished) {
          return;
        }

        final controller = provider.videoPlayerController;

        if (controller == null || !controller.value.isInitialized) {
          return;
        }

        final double currentSeconds =
            controller.value.position.inMilliseconds / 1000.0;

        if (currentSeconds >= endAtSeconds) {
          _segmentFinished = true;
          _segmentTimer?.cancel();
          _segmentTimer = null;
          unawaited(provider.pause());
        }
      },
    );
  }

  String cleanAttachmentName(
      dynamic originalName,
      int index,
      ) {
    String name = originalName?.toString().trim() ?? '';

    if (name.isEmpty) {
      return 'ملف المحاضرة ${index + 1}';
    }

    name = name.replaceAll(
      RegExp(
        r'\.pdf$',
        caseSensitive: false,
      ),
      '',
    );

    name = name.replaceAll('_', ' ');
    name = name.replaceAll(RegExp(r'\s+'), ' ');

    return name.trim();
  }

  Future<bool> toggleFavorite({
    required int videoId,
    required AddVideoToFavProvider favProvider,
  }) async {
    await favProvider.addVidToFav(id: videoId);

    if (!favProvider.isSuccess) {
      return false;
    }

    _isFavorite = !_isFavorite;
    notifyListeners();

    return true;
  }

  Future<bool> loadChat({
    required int videoId,
    required ViewChatProvider viewProvider,
  }) async {
    await viewProvider.getChat(videoId: videoId);

    return viewProvider.errorMessage == null &&
        viewProvider.chat != null;
  }

  bool beginLeaving() {
    if (_isLeavingPage) {
      return false;
    }

    _isLeavingPage = true;
    _segmentTimer?.cancel();
    _segmentTimer = null;
    notifyListeners();

    return true;
  }

  Future<bool> saveProgress({
    required int videoId,
    required VideoDetailsFunctionProvider videoFunctionProvider,
    required VideoProgressProvider progressProvider,
  }) async {
    final VideoProgressSnapshot snapshot =
        videoFunctionProvider.progressSnapshot;

    return progressProvider.saveProgressSnapshot(
      videoId: videoId,
      snapshot: snapshot,
    );
  }

  void disposeVideo(
      VideoDetailsFunctionProvider? videoFunctionProvider,
      ) {
    _segmentTimer?.cancel();
    _segmentTimer = null;

    if (videoFunctionProvider != null) {
      unawaited(
        videoFunctionProvider.releaseVideo(
          notify: false,
          resetProgress: true,
        ),
      );
    }
  }
}
