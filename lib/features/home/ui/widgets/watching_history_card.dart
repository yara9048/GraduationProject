import 'package:flutter/material.dart';

import '../../data/models/watching_history_nodel.dart';

class WatchingHistoryCard extends StatelessWidget {
  final WatchingHistoryModel history;
  final VoidCallback? onTap;

  const WatchingHistoryCard({
    super.key,
    required this.history,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final video = history.videoDetail;
    final course = history.courseDetail;
    final double durationMinutes =
    _parseDouble(video.duration);
    final double durationSeconds =
        durationMinutes * 60;
    final double watchedSeconds =
        history.progressSeconds;
    final double progress =
    durationSeconds > 0
        ? (watchedSeconds / durationSeconds)
        .clamp(0.0, 1.0)
        .toDouble()
        : 0.0;
    final int progressPercentage =
    (progress * 100)
        .round()
        .clamp(0, 100);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        margin: const EdgeInsets.only(
          bottom: 14,
        ),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
          BorderRadius.circular(18),
          border: Border.all(
            color:
            const Color(0xffE0ECEA),
          ),
          boxShadow: [
            BoxShadow(
              color:
              Colors.black.withOpacity(
                0.06,
              ),
              blurRadius: 12,
              offset:
              const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
        ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(
          width: 105,
          height: 105,
          child: video.thumbnail != null &&
              video.thumbnail!.isNotEmpty
              ? Image.network(
            'http://144.91.84.194:8459${video.thumbnail}',
            fit: BoxFit.cover,

            loadingBuilder: (
                context,
                child,
                loadingProgress,
                ) {
              if (loadingProgress == null) {
                return child;
              }

              return Container(
                color: const Color(0xffE9F5F3),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xff2A9D8F),
                  ),
                ),
              );
            },

            errorBuilder: (
                context,
                error,
                stackTrace,
                ) {
              debugPrint(
                'IMAGE ERROR: $error',
              );

              debugPrint(
                'IMAGE URL: http://144.91.84.194:8459${video.thumbnail}',
              );

              return Container(
                color: const Color(0xffE9F5F3),
                child: const Center(
                  child: Icon(
                    Icons.play_circle_outline_rounded,
                    size: 42,
                    color: Color(0xff2A9D8F),
                  ),
                ),
              );
            },
          )
              : Container(
            color: const Color(0xffE9F5F3),
            child: const Center(
              child: Icon(
                Icons.play_circle_outline_rounded,
                size: 42,
                color: Color(0xff2A9D8F),
              ),
            ),
          ),
        ),
      ),

            const SizedBox(
              width: 12,
            ),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          video.title,
                          maxLines: 2,
                          overflow:
                          TextOverflow.ellipsis,
                          style:
                          const TextStyle(
                            fontFamily:
                            'Tajawal',
                            fontSize: 15,
                            fontWeight:
                            FontWeight.bold,
                            color:
                            Color(
                              0xff264653,
                            ),
                            height: 1.4,
                          ),
                        ),
                      ),

                      const SizedBox(
                        width: 8,
                      ),

                      Container(
                        padding:
                        const EdgeInsets
                            .symmetric(
                          horizontal: 8,
                          vertical: 5,
                        ),
                        decoration:
                        BoxDecoration(
                          color: history
                              .isCompleted
                              ? const Color(
                            0xff2A9D8F,
                          ).withOpacity(
                            0.12,
                          )
                              : const Color(
                            0xffE9C46A,
                          ).withOpacity(
                            0.20,
                          ),
                          borderRadius:
                          BorderRadius
                              .circular(
                            12,
                          ),
                        ),
                        child: Text(
                          history.isCompleted
                              ? 'مكتمل'
                              : 'قيد المشاهدة',
                          style:
                          TextStyle(
                            fontFamily:
                            'Tajawal',
                            fontSize: 10,
                            fontWeight:
                            FontWeight.bold,
                            color: history
                                .isCompleted
                                ? const Color(
                              0xff2A9D8F,
                            )
                                : const Color(
                              0xffB7791F,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 5,
                  ),

                  Row(
                    children: [
                      const Icon(
                        Icons
                            .playlist_play_rounded,
                        size: 17,
                        color:
                        Color(
                          0xff2A9D8F,
                        ),
                      ),

                      const SizedBox(
                        width: 5,
                      ),

                      Expanded(
                        child: Text(
                          course.name,
                          maxLines: 1,
                          overflow:
                          TextOverflow.ellipsis,
                          style:
                          const TextStyle(
                            fontFamily:
                            'Tajawal',
                            fontSize: 12,
                            color:
                            Color(
                              0xff6C7A7A,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 11,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius:
                          BorderRadius
                              .circular(
                            20,
                          ),
                          child:
                          LinearProgressIndicator(
                            value:
                            progress,
                            minHeight: 7,
                            backgroundColor:
                            const Color(
                              0xffE5F1EF,
                            ),
                            valueColor:
                            const AlwaysStoppedAnimation<
                                Color>(
                              Color(
                                0xff2A9D8F,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(
                        width: 10,
                      ),

                      Text(
                        '$progressPercentage%',
                        style:
                        const TextStyle(
                          fontFamily:
                          'Tajawal',
                          fontSize: 12,
                          fontWeight:
                          FontWeight.bold,
                          color:
                          Color(
                            0xff2A9D8F,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  Directionality(
                    textDirection:
                    TextDirection.rtl,
                    child: Row(
                      children: [
                        const Icon(
                          Icons
                              .schedule_rounded,
                          size: 16,
                          color:
                          Color(
                            0xff839493,
                          ),
                        ),

                        const SizedBox(
                          width: 4,
                        ),

                        Flexible(
                          child: Text(
                            _formatDuration(
                              durationMinutes,
                            ),
                            maxLines: 1,
                            overflow:
                            TextOverflow
                                .ellipsis,
                            style:
                            const TextStyle(
                              fontFamily:
                              'Tajawal',
                              fontSize: 11,
                              color:
                              Color(
                                0xff839493,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  String _formatDuration(
      double totalMinutes,
      ) {
    if (totalMinutes <= 0) {
      return '0 دقيقة';
    }

    final int roundedMinutes =
    totalMinutes.round();

    final int hours =
        roundedMinutes ~/ 60;

    final int minutes =
        roundedMinutes % 60;

    if (hours > 0 &&
        minutes > 0) {
      return '$hours ساعة و $minutes دقيقة';
    }

    if (hours > 0) {
      return '$hours ساعة';
    }

    return '$minutes دقيقة';
  }

  double _parseDouble(
      dynamic value,
      ) {
    if (value == null) {
      return 0.0;
    }

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(
      value
          .toString()
          .trim(),
    ) ??
        0.0;
  }
}