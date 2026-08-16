import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:graduationprojct/features/home/providers/video_details_function_provider.dart';
import 'package:provider/provider.dart';

class VideoPlayerSection
    extends StatelessWidget {
  final String? apiVideoUrl;

  const VideoPlayerSection({
    super.key,
    required this.apiVideoUrl,
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
        final bool isWaitingForVideo =
            provider.isVideoLoading ||
                (!provider
                    .hasInitializedVideo &&
                    provider
                        .videoErrorMessage ==
                        null);

        final bool hasReadyVideo =
            provider.chewieController !=
                null &&
                provider
                    .hasInitializedVideo;

        return Directionality(
          textDirection:
          TextDirection.ltr,
          child: ClipRect(
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: SizedBox(
                width:
                double.infinity,
                child:
                isWaitingForVideo
                    ? const ColoredBox(
                  color:
                  Colors.black,
                  child:
                  Center(
                    child:
                    CircularProgressIndicator(
                      color:
                      Color(
                        0xffE9C46A,
                      ),
                    ),
                  ),
                )
                    : hasReadyVideo
                    ? Chewie(
                  controller:
                  provider
                      .chewieController!,
                )
                    : ColoredBox(
                  color:
                  Colors.black,
                  child:
                  Center(
                    child:
                    Padding(
                      padding:
                      const EdgeInsets
                          .symmetric(
                        horizontal:
                        25,
                      ),
                      child:
                      Column(
                        mainAxisSize:
                        MainAxisSize
                            .min,
                        children: [
                          const Icon(
                            Icons
                                .video_file_outlined,
                            color:
                            Colors.white,
                            size:
                            48,
                          ),
                          const SizedBox(
                            height:
                            10,
                          ),
                          Text(
                            provider
                                .videoErrorMessage ??
                                'تعذر تشغيل الفيديو',
                            textAlign:
                            TextAlign.center,
                            style:
                            const TextStyle(
                              color:
                              Colors.white,
                              fontFamily:
                              'Tajawal',
                              fontSize:
                              15,
                            ),
                          ),
                          const SizedBox(
                            height:
                            15,
                          ),
                          OutlinedButton
                              .icon(
                            onPressed:
                                () {
                              context
                                  .read<
                                  VideoDetailsFunctionProvider>()
                                  .retryCurrentVideo(
                                apiVideoUrl,
                              );
                            },
                            style:
                            OutlinedButton
                                .styleFrom(
                              foregroundColor:
                              const Color(
                                0xffE9C46A,
                              ),
                              side:
                              const BorderSide(
                                color:
                                Color(
                                  0xffE9C46A,
                                ),
                              ),
                            ),
                            icon:
                            const Icon(
                              Icons
                                  .refresh_rounded,
                            ),
                            label:
                            const Text(
                              'إعادة المحاولة',
                              style:
                              TextStyle(
                                fontFamily:
                                'Tajawal',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ========================================================
// Progress الموجود تحت الفيديو
// ========================================================

class VideoWatchProgress
    extends StatelessWidget {
  const VideoWatchProgress({
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
        final bool hasDuration =
            provider.durationSeconds >
                0;

        final double displayedProgress =
        hasDuration
            ? provider
            .watchProgress
            .clamp(
          0.0,
          1.0,
        )
            .toDouble()
            : 0.0;

        final int progressPercentage =
        (displayedProgress *
            100)
            .round()
            .clamp(
          0,
          100,
        );

        final String currentPosition =
        provider.formatDuration(
          provider.videoPosition,
        );

        final String totalDuration =
        hasDuration
            ? provider
            .formatDuration(
          Duration(
            seconds:
            provider
                .durationSeconds,
          ),
        )
            : '--:--';

        return Padding(
          padding:
          const EdgeInsets
              .symmetric(
            horizontal: 15,
          ),
          child: Column(
            children: [
              Directionality(
                textDirection:
                TextDirection.ltr,
                child: Row(
                  children: [
                    Text(
                      currentPosition,
                      style:
                      const TextStyle(
                        fontFamily:
                        'Tajawal',
                        fontSize: 12,
                        color:
                        Color(
                          0xff92A1A1,
                        ),
                        fontWeight:
                        FontWeight
                            .w600,
                      ),
                    ),

                    const Text(
                      ' / ',
                      style:
                      TextStyle(
                        color:
                        Color(
                          0xff92A1A1,
                        ),
                      ),
                    ),

                    Text(
                      totalDuration,
                      style:
                      const TextStyle(
                        fontFamily:
                        'Tajawal',
                        fontSize: 12,
                        color:
                        Color(
                          0xff92A1A1,
                        ),
                        fontWeight:
                        FontWeight
                            .w600,
                      ),
                    ),

                    const Spacer(),

                    Text(
                      '$progressPercentage%',
                      style:
                      const TextStyle(
                        fontWeight:
                        FontWeight
                            .bold,
                        color:
                        Color(
                          0xffE9C46A,
                        ),
                        fontSize:
                        13,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 8,
              ),

              ClipRRect(
                borderRadius:
                BorderRadius
                    .circular(
                  20,
                ),
                child:
                LinearProgressIndicator(
                  value:
                  displayedProgress,
                  minHeight: 8,
                  color:
                  const Color(
                    0xffE9C46A,
                  ),
                  backgroundColor:
                  Colors.grey
                      .shade300,
                ),
              ),

              const SizedBox(
                height: 8,
              ),

              Align(
                alignment:
                Alignment
                    .centerRight,
                child: Text(
                  !hasDuration
                      ? 'جاري قراءة مدة الفيديو...'
                      : displayedProgress >=
                      1.0
                      ? 'تمت مشاهدة كامل الفيديو'
                      : 'تمت مشاهدة $progressPercentage% من الفيديو',
                  textDirection:
                  TextDirection.rtl,
                  style:
                  const TextStyle(
                    fontSize: 13,
                    fontFamily:
                    'Tajawal',
                    fontWeight:
                    FontWeight
                        .bold,
                    color:
                    Color(
                      0xff1A2429,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}