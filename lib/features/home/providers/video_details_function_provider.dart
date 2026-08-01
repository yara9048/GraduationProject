import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoDetailsFunctionProvider
    with ChangeNotifier {
  static const String fallbackVideoUrl =
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4';

  double _watchProgress = 0.0;

  Duration _videoDuration = Duration.zero;
  Duration _videoPosition = Duration.zero;

  bool _isVideoLoading = false;
  bool _isUsingFallbackVideo = false;

  String? _videoErrorMessage;
  String? _currentVideoUrl;
  String? _requestedApiVideoUrl;

  /*
   * نحفظ مدة الـ API بالثواني لاستخدامها
   * فقط إذا لم يستطع الفيديو إعطاء مدة صحيحة.
   */
  int? _requestedDurationSeconds;

  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;

  double get watchProgress {
    if (_videoDuration.inMilliseconds <= 0) {
      return 0.0;
    }

    return _watchProgress.clamp(
      0.0,
      1.0,
    );
  }

  Duration get videoDuration =>
      _videoDuration;

  Duration get videoPosition =>
      _videoPosition;

  bool get isCompleted {
    final int durationMilliseconds =
        _videoDuration.inMilliseconds;

    final int positionMilliseconds =
        _videoPosition.inMilliseconds;

    if (durationMilliseconds <= 0) {
      return false;
    }

    /*
     * نعتبر الفيديو مكتملًا إذا بقيت
     * ثانية واحدة أو أقل.
     */
    return durationMilliseconds > 1000 &&
        positionMilliseconds >=
            durationMilliseconds - 1000;
  }

  bool get isVideoLoading =>
      _isVideoLoading;

  bool get isUsingFallbackVideo =>
      _isUsingFallbackVideo;

  String? get videoErrorMessage =>
      _videoErrorMessage;

  String? get currentVideoUrl =>
      _currentVideoUrl;

  String? get requestedApiVideoUrl =>
      _requestedApiVideoUrl;

  VideoPlayerController?
  get videoPlayerController =>
      _videoPlayerController;

  ChewieController?
  get chewieController =>
      _chewieController;

  bool get hasInitializedVideo =>
      _videoPlayerController != null &&
          _videoPlayerController!
              .value.isInitialized &&
          _chewieController != null;

  Future<void> initializeVideo(
      String? apiVideoUrl, {
        required Object? durationSeconds,
      }) async {
    final String? cleanedApiUrl =
    apiVideoUrl?.trim();

    _requestedApiVideoUrl =
        cleanedApiUrl;

    _requestedDurationSeconds =
        _parseDurationSeconds(
          durationSeconds,
        );

    _watchProgress = 0.0;
    _videoPosition = Duration.zero;

    /*
   * المدة تؤخذ فقط من الـ API.
   */
    _videoDuration = Duration(
      seconds:
      _requestedDurationSeconds ?? 0,
    );

    _isVideoLoading = true;
    _videoErrorMessage = null;
    _isUsingFallbackVideo = false;

    notifyListeners();

    final bool validApiUrl =
    isValidVideoUrl(
      cleanedApiUrl,
    );

    if (!validApiUrl) {
      _isUsingFallbackVideo = true;

      final bool fallbackInitialized =
      await _initializeController(
        fallbackVideoUrl,
      );

      if (!fallbackInitialized) {
        _videoErrorMessage =
        'تعذر تشغيل الفيديو';
      }

      _isVideoLoading = false;
      notifyListeners();

      return;
    }

    final bool apiVideoInitialized =
    await _initializeController(
      cleanedApiUrl!,
    );

    if (apiVideoInitialized) {
      _isUsingFallbackVideo = false;
      _isVideoLoading = false;

      notifyListeners();

      return;
    }

    _isUsingFallbackVideo = true;

    final bool fallbackInitialized =
    await _initializeController(
      fallbackVideoUrl,
    );

    if (!fallbackInitialized) {
      _videoErrorMessage =
      'تعذر تشغيل فيديو السيرفر والفيديو الاحتياطي';
    }

    _isVideoLoading = false;
    notifyListeners();
  }

  Future<bool> _initializeController(
      String videoUrl) async {
    VideoPlayerController? controller;

    try {
      await releaseVideo(
        notify: false,
        resetProgress: true,
      );

      _videoPosition = Duration.zero;
      _watchProgress = 0.0;

      debugPrint(
        'Trying video URL: $videoUrl',
      );

      final Uri? uri =
      Uri.tryParse(videoUrl);

      if (uri == null) {
        debugPrint(
          'Invalid video URI: $videoUrl',
        );

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

      debugPrint(
        'Initializing video controller...',
      );

      await controller.initialize();

      if (!controller.value.isInitialized) {
        debugPrint(
          'Controller returned without initialization',
        );

        await controller.dispose();

        return false;
      }

      _videoPlayerController =
          controller;

      _currentVideoUrl =
          videoUrl;

      _videoPosition =
          controller.value.position;

      _watchProgress = 0.0;

      debugPrint(
        'Video initialized successfully',
      );

      debugPrint(
        'CONTROLLER DURATION: '
            '${controller.value.duration}',
      );

      debugPrint(
        'EFFECTIVE DURATION: '
            '$_videoDuration',
      );

      debugPrint(
        'VIDEO POSITION: '
            '${controller.value.position}',
      );

      debugPrint(
        'VIDEO SIZE: '
            '${controller.value.size}',
      );

      debugPrint(
        'VIDEO ASPECT RATIO: '
            '${controller.value.aspectRatio}',
      );

      controller.addListener(() {
        /*
         * تجاهل Listener تابع لفيديو قديم.
         */
        if (_videoPlayerController !=
            controller) {
          return;
        }

        final VideoPlayerValue value =
            controller!.value;

        if (value.hasError) {
          debugPrint(
            'VIDEO PLAYER ERROR: '
                '${value.errorDescription}',
          );

          return;
        }

        if (!value.isInitialized) {
          return;
        }

        final Duration newPosition =
            value.position;

        final Duration oldPosition =
            _videoPosition;

        final double oldProgress =
            _watchProgress;

        _videoPosition =
            newPosition;

        final int durationMilliseconds =
            _videoDuration.inMilliseconds;

        final int positionMilliseconds =
            _videoPosition.inMilliseconds;

        double newProgress = 0.0;

        if (durationMilliseconds > 0) {
          newProgress =
              positionMilliseconds /
                  durationMilliseconds;

          newProgress =
              newProgress.clamp(
                0.0,
                1.0,
              );

          final bool reachedEnd =
              durationMilliseconds > 1000 &&
                  positionMilliseconds >=
                      durationMilliseconds -
                          1000;

          if (reachedEnd) {
            newProgress = 1.0;
          }
        }

        _watchProgress =
            newProgress;


        final bool positionChanged =
            (oldPosition.inMilliseconds -
                _videoPosition
                    .inMilliseconds)
                .abs() >=
                300;

        final bool progressChanged =
            (oldProgress -
                _watchProgress)
                .abs() >=
                0.001;

        if (positionChanged ||
            progressChanged) {
          notifyListeners();
        }
      });

      _chewieController =
          ChewieController(
            videoPlayerController:
            controller,
            autoPlay: false,
            looping: false,
            allowFullScreen: true,
            allowMuting: true,
            showControls: true,
            autoInitialize: false,
            materialProgressColors:
            ChewieProgressColors(
              playedColor:
              const Color(
                0xffE9C46A,
              ),
              handleColor:
              const Color(
                0xffE9C46A,
              ),
              bufferedColor:
              Colors.grey,
              backgroundColor:
              Colors.white24,
            ),
            placeholder:
            const ColoredBox(
              color: Colors.black,
              child: Center(
                child:
                CircularProgressIndicator(
                  color: Color(
                    0xffE9C46A,
                  ),
                ),
              ),
            ),
            errorBuilder: (
                context,
                errorMessage,
                ) {
              debugPrint(
                'CHEWIE ERROR: '
                    '$errorMessage',
              );

              return ColoredBox(
                color: Colors.black,
                child: Center(
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Text(
                      errorMessage
                          .trim()
                          .isEmpty
                          ? 'تعذر تشغيل الفيديو'
                          : errorMessage,
                      textAlign:
                      TextAlign.center,
                      style:
                      const TextStyle(
                        color:
                        Colors.white,
                        fontFamily:
                        'Tajawal',
                      ),
                    ),
                  ),
                ),
              );
            },
          );

      notifyListeners();

      return true;
    } catch (error, stackTrace) {
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

  /*
   * لا نصفر _videoDuration لأنها قادمة من API.
   */
  _videoPosition = Duration.zero;
  _watchProgress = 0.0;

  return false;
}
  }

  /*
   * تقبل المدة سواء كانت:
   * 375
   * 375.0
   * "375"
   */
  int? _parseDurationSeconds(
      Object? value,
      ) {
    if (value == null) {
      return null;
    }

    if (value is num) {
      final int seconds =
      value.round();

      return seconds > 0
          ? seconds
          : null;
    }

    final double? parsedValue =
    double.tryParse(
      value.toString().trim(),
    );

    if (parsedValue == null ||
        parsedValue <= 0) {
      return null;
    }

    return parsedValue.round();
  }

  bool isValidVideoUrl(
      String? value,
      ) {
    if (value == null) {
      return false;
    }

    final String cleanedValue =
    value.trim();

    if (cleanedValue.isEmpty ||
        cleanedValue.toLowerCase() ==
            'null') {
      return false;
    }

    final Uri? uri =
    Uri.tryParse(
      cleanedValue,
    );

    if (uri == null) {
      return false;
    }

    return uri.hasScheme &&
        uri.hasAuthority &&
        (uri.scheme == 'http' ||
            uri.scheme == 'https');
  }

  String formatDuration(
      Duration duration,
      ) {
    final int totalSeconds =
        duration.inSeconds;

    final int hours =
        totalSeconds ~/ 3600;

    final int minutes =
        (totalSeconds % 3600) ~/ 60;

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

  bool canAccessFeatures() {
    return isCompleted;
  }

  Future<void> retryCurrentVideo(
      String? apiVideoUrl,
      ) async {
    await initializeVideo(
      apiVideoUrl,
      durationSeconds:
      _requestedDurationSeconds,
    );
  }

  Future<void> releaseVideo({
    bool notify = true,
    bool resetProgress = false,
  }) async {
    final ChewieController?
    oldChewieController =
        _chewieController;

    final VideoPlayerController?
    oldVideoController =
        _videoPlayerController;

    /*
     * تصفير المراجع أولًا حتى يتوقف
     * Listener الفيديو السابق.
     */
    _chewieController = null;
    _videoPlayerController = null;

    try {
      oldChewieController?.dispose();
    } catch (error) {
      debugPrint(
        'Error disposing Chewie controller: '
            '$error',
      );
    }

    if (oldVideoController != null) {
      try {
        await oldVideoController.dispose();
      } catch (error) {
        debugPrint(
          'Error disposing video controller: '
              '$error',
        );
      }
    }

    _currentVideoUrl = null;
    _videoPosition = Duration.zero;

    if (resetProgress) {
      _watchProgress = 0.0;
    }

    if (notify) {
      notifyListeners();
    }
  }

  Future<void> reset() async {
    await releaseVideo(
      notify: false,
      resetProgress: true,
    );

    _isVideoLoading = false;
    _isUsingFallbackVideo = false;

    _videoErrorMessage = null;
    _currentVideoUrl = null;
    _requestedApiVideoUrl = null;
    _requestedDurationSeconds = null;

    _videoDuration = Duration.zero;
    _videoPosition = Duration.zero;
    _watchProgress = 0.0;

    notifyListeners();
  }

  @override
  void dispose() {
    try {
      _chewieController?.dispose();
    } catch (_) {}

    try {
      _videoPlayerController?.dispose();
    } catch (_) {}

    _chewieController = null;
    _videoPlayerController = null;

    super.dispose();
  }
}