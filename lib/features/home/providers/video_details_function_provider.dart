import 'dart:async';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class VideoProgressSnapshot {
  final int progressSeconds;
  final int durationSeconds;
  final bool isCompleted;

  const VideoProgressSnapshot({
    required this.progressSeconds,
    required this.durationSeconds,
    required this.isCompleted,
  });
}

class VideoDetailsFunctionProvider with ChangeNotifier {
  static const String fallbackVideoUrl =
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4';

  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;

  Timer? _progressTimer;

  String? _currentVideoUrl;
  String? _requestedApiVideoUrl;

  String? _videoErrorMessage;

  bool _isVideoLoading = false;
  bool _isUsingFallbackVideo = false;

  bool _isPlaying = false;
  bool _isMuted = false;

  // ========================================
  // Progress
  // ========================================

  double _watchProgress = 0.0;
  double _initialWatchProgress = 0.0;

  Duration _videoPosition = Duration.zero;

  // ========================================
  // Duration
  //
  // المصدر الوحيد هو API
  // API يرجع بالدقائق
  // ========================================

  double? _apiDurationMinutes;
  int _apiDurationSeconds = 0;

  // ========================================
  // Getters
  // ========================================

  VideoPlayerController? get videoPlayerController =>
      _videoPlayerController;

  ChewieController? get chewieController =>
      _chewieController;

  bool get isVideoLoading => _isVideoLoading;

  bool get isUsingFallbackVideo => _isUsingFallbackVideo;

  String? get videoErrorMessage => _videoErrorMessage;

  String? get currentVideoUrl => _currentVideoUrl;

  String? get requestedApiVideoUrl => _requestedApiVideoUrl;

  bool get isPlaying => _isPlaying;

  bool get isMuted => _isMuted;

  Duration get videoPosition => _videoPosition;

  Duration get videoDuration => Duration(
    seconds: _apiDurationSeconds,
  );

  int get durationSeconds => _apiDurationSeconds;

  double get initialWatchProgress => _initialWatchProgress;

  bool get hasInitializedVideo =>
      _videoPlayerController != null &&
          _videoPlayerController!.value.isInitialized &&
          _chewieController != null;

  // ========================================
  // Current seconds
  // ========================================

  int get currentProgressSeconds {
    final int current =
    _videoPosition.inSeconds.clamp(
      0,
      _apiDurationSeconds > 0
          ? _apiDurationSeconds
          : 999999999,
    );

    final int saved =
    (_initialWatchProgress *
        _apiDurationSeconds)
        .round();

    return current > saved
        ? current
        : saved;
  }

  // ========================================
  // Watch progress
  // ========================================

  double get watchProgress {
    if (_apiDurationSeconds <= 0) {
      return _initialWatchProgress
          .clamp(0.0, 1.0)
          .toDouble();
    }

    final double current =
        _videoPosition.inMilliseconds /
            (_apiDurationSeconds * 1000);

    final double normalizedCurrent =
    current
        .clamp(0.0, 1.0)
        .toDouble();

    final double saved =
    _initialWatchProgress
        .clamp(0.0, 1.0)
        .toDouble();

    return normalizedCurrent > saved
        ? normalizedCurrent
        : saved;
  }

  bool get isCompleted {
    if (_apiDurationSeconds <= 0) {
      return false;
    }

    return watchProgress >= 0.995;
  }

  VideoProgressSnapshot get progressSnapshot {
    return VideoProgressSnapshot(
      progressSeconds:
      currentProgressSeconds,
      durationSeconds:
      _apiDurationSeconds,
      isCompleted: isCompleted,
    );
  }

  // ========================================
  // Initial saved progress
  // ========================================

  void setInitialWatchProgress(
      double progress,
      ) {
    _initialWatchProgress =
        progress
            .clamp(0.0, 1.0)
            .toDouble();

    notifyListeners();
  }

  // ========================================
  // Initialize
  // ========================================

  Future<void> initializeVideo(
      String? apiVideoUrl, {
        required Object? durationMinutes,
      }) async {
    final String? cleanedUrl =
    apiVideoUrl?.trim();

    _requestedApiVideoUrl =
        cleanedUrl;

    // ----------------------------
    // Duration من API فقط
    // ----------------------------

    _apiDurationMinutes =
        _parseDurationMinutes(
          durationMinutes,
        );

    _apiDurationSeconds =
        _minutesToSeconds(
          _apiDurationMinutes,
        );

    debugPrint(
      'API duration minutes: $_apiDurationMinutes',
    );

    debugPrint(
      'API duration seconds: $_apiDurationSeconds',
    );

    // لو عنده progress قديم
    final int initialSeconds =
    (_initialWatchProgress *
        _apiDurationSeconds)
        .round();

    _videoPosition = Duration(
      seconds: initialSeconds,
    );

    _watchProgress =
        _initialWatchProgress;

    _isPlaying = false;
    _isMuted = false;

    _isVideoLoading = true;
    _videoErrorMessage = null;
    _isUsingFallbackVideo = false;

    notifyListeners();

    final bool validApiUrl =
    isValidVideoUrl(
      cleanedUrl,
    );

    if (!validApiUrl) {
      _isUsingFallbackVideo = true;

      final success =
      await _initializeController(
        fallbackVideoUrl,
      );

      if (!success) {
        _videoErrorMessage =
        'تعذر تشغيل الفيديو';
      }

      _isVideoLoading = false;

      notifyListeners();

      return;
    }

    final bool success =
    await _initializeController(
      cleanedUrl!,
    );

    if (success) {
      _isUsingFallbackVideo = false;
      _isVideoLoading = false;

      notifyListeners();

      return;
    }

    _isUsingFallbackVideo = true;

    final fallbackSuccess =
    await _initializeController(
      fallbackVideoUrl,
    );

    if (!fallbackSuccess) {
      _videoErrorMessage =
      'تعذر تشغيل فيديو السيرفر والفيديو الاحتياطي';
    }

    _isVideoLoading = false;

    notifyListeners();
  }

  // ========================================
  // Initialize player
  //
  // لا يوجد أي استخدام لـ:
  // controller.value.duration
  // ========================================

  Future<bool> _initializeController(
      String videoUrl,
      ) async {
    VideoPlayerController? controller;

    try {
      await _disposeControllers();

      final Uri? uri =
      Uri.tryParse(videoUrl);

      if (uri == null) {
        return false;
      }

      controller =
          VideoPlayerController.networkUrl(
            uri,
            httpHeaders: const {
              'Accept':
              'video/mp4,video/*;q=0.9,*/*;q=0.8',
            },
            videoPlayerOptions:
            VideoPlayerOptions(
              mixWithOthers: false,
            ),
          );

      await controller.initialize();

      if (!controller
          .value.isInitialized) {
        await controller.dispose();

        return false;
      }

      _videoPlayerController =
          controller;

      _currentVideoUrl =
          videoUrl;

      // -------------------------------------
      // إذا في progress محفوظ حاول ننقل
      // الفيديو عليه.
      // إذا timestamps الفيديو مضروبة
      // وما زبط seek، ما بتأثر الواجهة.
      // -------------------------------------

      if (_videoPosition >
          Duration.zero) {
        try {
          await controller.seekTo(
            _videoPosition,
          );
        } catch (_) {}
      }

      _chewieController =
          ChewieController(
            videoPlayerController:
            controller,

            autoPlay: false,
            looping: false,

            showControls: true,

            allowFullScreen: true,
            allowMuting: true,

            autoInitialize: false,

            // ===================================
            // Controls الخاصة فينا
            // ===================================
            customControls:
            const ApiVideoControls(),

            placeholder:
            const ColoredBox(
              color: Colors.black,
              child: Center(
                child:
                CircularProgressIndicator(
                  color:
                  Color(0xffE9C46A),
                ),
              ),
            ),

            errorBuilder: (
                context,
                errorMessage,
                ) {
              return const ColoredBox(
                color: Colors.black,
                child: Center(
                  child: Icon(
                    Icons
                        .videocam_off_outlined,
                    color:
                    Colors.white54,
                    size: 45,
                  ),
                ),
              );
            },
          );

      _startProgressTimer();

      notifyListeners();

      return true;
    } catch (
    error,
    stackTrace
    ) {
    debugPrint(
    'VIDEO INITIALIZATION ERROR: $error',
    );

    debugPrint(
    'VIDEO STACK TRACE: $stackTrace',
    );

    if (controller != null) {
    try {
    await controller.dispose();
    } catch (_) {}
    }

    _videoPlayerController = null;
    _chewieController = null;

    _currentVideoUrl = null;

    _isPlaying = false;

    return false;
    }
  }

  // ========================================
  // TIMER
  //
  // هذا هو مصدر الوقت الحالي الأساسي.
  // ما عاد نعتمد position تبع الفيديو
  // حتى يتحرك progress.
  // ========================================

  void _startProgressTimer() {
    _progressTimer?.cancel();

    _progressTimer =
        Timer.periodic(
          const Duration(
            milliseconds: 250,
          ),
              (_) {
            if (!_isPlaying) {
              return;
            }

            final controller =
                _videoPlayerController;

            if (controller == null ||
                !controller
                    .value.isInitialized) {
              return;
            }

            // لا نحسب buffering كوقت مشاهدة
            if (controller
                .value.isBuffering) {
              return;
            }

            if (_apiDurationSeconds <= 0) {
              return;
            }

            // ==================================
            // نحن نزيد الوقت بأنفسنا
            // ==================================

            _videoPosition +=
            const Duration(
              milliseconds: 250,
            );

            final Duration maxDuration =
            Duration(
              seconds:
              _apiDurationSeconds,
            );

            if (_videoPosition >=
                maxDuration) {
              _videoPosition =
                  maxDuration;

              _isPlaying = false;

              unawaited(
                controller.pause(),
              );
            }

            _watchProgress =
                watchProgress;

            notifyListeners();
          },
        );
  }

  // ========================================
  // PLAY
  // ========================================

  Future<void> play() async {
    final controller =
        _videoPlayerController;

    if (controller == null ||
        !controller
            .value.isInitialized) {
      return;
    }

    if (_apiDurationSeconds > 0 &&
        _videoPosition.inSeconds >=
            _apiDurationSeconds) {
      await seekToSeconds(0);
    }

    try {
      await controller.play();

      _isPlaying = true;

      notifyListeners();
    } catch (e) {
      debugPrint(
        'Play error: $e',
      );
    }
  }

  // ========================================
  // PAUSE
  // ========================================

  Future<void> pause() async {
    final controller =
        _videoPlayerController;

    if (controller == null) {
      return;
    }

    try {
      await controller.pause();
    } catch (_) {}

    _isPlaying = false;

    notifyListeners();
  }

  // ========================================
  // PLAY / PAUSE
  // ========================================

  Future<void>
  togglePlayPause() async {
    if (_isPlaying) {
      await pause();
    } else {
      await play();
    }
  }

  // ========================================
  // SEEK
  //
  // الـUI يتغير فوراً بناء على API duration.
  // نحاول أيضاً نحرك الفيديو الحقيقي.
  // ========================================

  Future<void> seekToSeconds(
      int seconds,
      ) async {
    if (_apiDurationSeconds <= 0) {
      return;
    }

    final int target =
    seconds.clamp(
      0,
      _apiDurationSeconds,
    );

    _videoPosition =
        Duration(
          seconds: target,
        );

    _watchProgress =
        watchProgress;

    notifyListeners();

    final controller =
        _videoPlayerController;

    if (controller == null ||
        !controller
            .value.isInitialized) {
      return;
    }

    try {
      await controller.seekTo(
        Duration(
          seconds: target,
        ),
      );
    } catch (e) {
      debugPrint(
        'Seek error: $e',
      );
    }
  }

  Future<void> seekBySeconds(
      int offset,
      ) async {
    final int target =
        _videoPosition.inSeconds +
            offset;

    await seekToSeconds(
      target,
    );
  }

  // ========================================
  // MUTE
  // ========================================

  Future<void> toggleMute() async {
    final controller =
        _videoPlayerController;

    if (controller == null ||
        !controller
            .value.isInitialized) {
      return;
    }

    _isMuted = !_isMuted;

    try {
      await controller.setVolume(
        _isMuted ? 0 : 1,
      );
    } catch (_) {}

    notifyListeners();
  }

  // ========================================
  // Full screen
  // ========================================

  void enterFullScreen() {
    _chewieController
        ?.enterFullScreen();
  }

  // ========================================
  // Pause and sync
  // ========================================

  Future<void>
  pauseAndSyncProgress() async {
    await pause();
  }

  // ========================================
  // Duration parser
  // ========================================

  double? _parseDurationMinutes(
      Object? value,
      ) {
    if (value == null) {
      return null;
    }

    double? minutes;

    if (value is num) {
      minutes =
          value.toDouble();
    } else {
      minutes =
          double.tryParse(
            value
                .toString()
                .trim(),
          );
    }

    if (minutes == null ||
        minutes <= 0) {
      return null;
    }

    return minutes;
  }

  int _minutesToSeconds(
      double? minutes,
      ) {
    if (minutes == null ||
        minutes <= 0) {
      return 0;
    }

    return (minutes * 60)
        .round();
  }

  // ========================================
  // Format duration
  // ========================================

  String formatDuration(
      Duration duration,
      ) {
    final int totalSeconds =
        duration.inSeconds;

    final int hours =
        totalSeconds ~/ 3600;

    final int minutes =
        (totalSeconds % 3600) ~/
            60;

    final int seconds =
        totalSeconds % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:'
          '${minutes.toString().padLeft(2, '0')}:'
          '${seconds.toString().padLeft(2, '0')}';
    }

    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  // ========================================
  // URL
  // ========================================

  bool isValidVideoUrl(
      String? value,
      ) {
    if (value == null) {
      return false;
    }

    final String cleaned =
    value.trim();

    if (cleaned.isEmpty ||
        cleaned.toLowerCase() ==
            'null') {
      return false;
    }

    final Uri? uri =
    Uri.tryParse(cleaned);

    if (uri == null) {
      return false;
    }

    return uri.hasScheme &&
        uri.hasAuthority &&
        (uri.scheme == 'http' ||
            uri.scheme ==
                'https');
  }

  // ========================================
  // AI features
  // ========================================

  bool canAccessFeatures() {
    return isCompleted;
  }

  // ========================================
  // Retry
  // ========================================

  Future<void> retryCurrentVideo(
      String? apiVideoUrl,
      ) async {
    await initializeVideo(
      apiVideoUrl,
      durationMinutes:
      _apiDurationMinutes,
    );
  }

  // ========================================
  // Dispose controllers فقط
  // بدون تصفير API duration
  // ========================================

  Future<void>
  _disposeControllers() async {
    _progressTimer?.cancel();
    _progressTimer = null;

    final oldChewie =
        _chewieController;

    final oldVideo =
        _videoPlayerController;

    _chewieController = null;
    _videoPlayerController = null;

    try {
      oldChewie?.dispose();
    } catch (_) {}

    if (oldVideo != null) {
      try {
        await oldVideo.dispose();
      } catch (_) {}
    }

    _isPlaying = false;
  }

  // ========================================
  // Release
  // ========================================

  Future<void> releaseVideo({
    bool notify = true,
    bool resetProgress = false,
  }) async {
    await _disposeControllers();

    _currentVideoUrl = null;

    if (resetProgress) {
      _videoPosition =
          Duration.zero;

      _watchProgress = 0.0;
    }

    if (notify) {
      notifyListeners();
    }
  }

  // ========================================
  // Reset
  // ========================================

  Future<void> reset() async {
    await releaseVideo(
      notify: false,
      resetProgress: true,
    );

    _apiDurationMinutes = null;
    _apiDurationSeconds = 0;

    _initialWatchProgress = 0.0;
    _watchProgress = 0.0;

    _videoPosition =
        Duration.zero;

    _isVideoLoading = false;
    _isUsingFallbackVideo = false;

    _videoErrorMessage = null;
    _requestedApiVideoUrl = null;
    _currentVideoUrl = null;

    _isPlaying = false;
    _isMuted = false;

    notifyListeners();
  }

  @override
  void dispose() {
    _progressTimer?.cancel();

    try {
      _chewieController
          ?.dispose();
    } catch (_) {}

    try {
      _videoPlayerController
          ?.dispose();
    } catch (_) {}

    super.dispose();
  }
}

// ========================================================
// CUSTOM VIDEO CONTROLS
//
// لا نستخدم مدة Chewie نهائياً.
// ========================================================

class ApiVideoControls
    extends StatelessWidget {
  const ApiVideoControls({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<
        VideoDetailsFunctionProvider>(
      builder: (
          context,
          provider,
          child,
          ) {
        final int totalSeconds =
            provider.durationSeconds;

        final int currentSeconds =
        provider
            .videoPosition
            .inSeconds
            .clamp(
          0,
          totalSeconds > 0
              ? totalSeconds
              : 0,
        );

        final String current =
        provider.formatDuration(
          Duration(
            seconds:
            currentSeconds,
          ),
        );

        final String total =
        provider.formatDuration(
          Duration(
            seconds:
            totalSeconds,
          ),
        );

        return Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              // =================================
              // وسط الشاشة
              // =================================

              Center(
                child: Row(
                  mainAxisSize:
                  MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        provider
                            .seekBySeconds(
                          -10,
                        );
                      },
                      icon:
                      const Icon(
                        Icons
                            .replay_10_rounded,
                        color:
                        Colors.white,
                        size: 32,
                      ),
                    ),

                    const SizedBox(
                      width: 22,
                    ),

                    Container(
                      width: 58,
                      height: 58,
                      decoration:
                      BoxDecoration(
                        color: Colors.black
                            .withValues(
                          alpha: 0.35,
                        ),
                        shape:
                        BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () {
                          provider
                              .togglePlayPause();
                        },
                        icon: Icon(
                          provider.isPlaying
                              ? Icons
                              .pause_rounded
                              : Icons
                              .play_arrow_rounded,
                          color:
                          Colors.white,
                          size: 40,
                        ),
                      ),
                    ),

                    const SizedBox(
                      width: 22,
                    ),

                    IconButton(
                      onPressed: () {
                        provider
                            .seekBySeconds(
                          10,
                        );
                      },
                      icon:
                      const Icon(
                        Icons
                            .forward_10_rounded,
                        color:
                        Colors.white,
                        size: 32,
                      ),
                    ),
                  ],
                ),
              ),

              // =================================
              // Bottom controls
              // =================================

              Positioned(
                left: 14,
                right: 14,
                bottom: 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 0,
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 5,
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 6,
                          ),
                          overlayShape: SliderComponentShape.noOverlay,
                          trackShape: const RectangularSliderTrackShape(),
                          tickMarkShape: SliderTickMarkShape.noTickMark,
                        ),
                        child: Slider(
                          min: 0,
                          max: totalSeconds > 0
                              ? totalSeconds.toDouble()
                              : 1,
                          value: totalSeconds > 0
                              ? currentSeconds.toDouble()
                              : 0,
                          activeColor: const Color(0xffE9C46A),
                          inactiveColor: Colors.white38,
                          onChanged: totalSeconds <= 0
                              ? null
                              : (value) {
                            provider.seekToSeconds(
                              value.round(),
                            );
                          },
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '$current / $total',
                          style:
                          const TextStyle(
                            color:
                            Colors.white,
                            fontSize:
                            13,
                            fontFamily:
                            'Tajawal',
                            fontWeight:
                            FontWeight
                                .w600,
                          ),
                        ),

                        const SizedBox(
                          width: 8,
                        ),

                        IconButton(
                          onPressed:
                          provider
                              .toggleMute,
                          icon: Icon(
                            provider
                                .isMuted
                                ? Icons
                                .volume_off_rounded
                                : Icons
                                .volume_up_rounded,
                            color:
                            Colors.white,
                            size: 25,
                          ),
                        ),

                        const Spacer(),

                        IconButton(
                          onPressed:
                          provider
                              .enterFullScreen,
                          icon:
                          const Icon(
                            Icons
                                .fullscreen_rounded,
                            color:
                            Colors.white,
                            size: 29,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}