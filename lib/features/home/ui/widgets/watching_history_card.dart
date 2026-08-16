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

    // =========================================
    // مدة الفيديو من API بالدقائق
    // =========================================
    final double durationMinutes =
    _parseDouble(video.duration);

    // نحول مدة الفيديو لثواني
    final double durationSeconds =
        durationMinutes * 60;

    // الوقت الذي شاهده المستخدم بالثواني
    final double watchedSeconds =
        history.progressSeconds;

    // =========================================
    // Progress الصحيح بين 0 و 1
    // =========================================
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
            _buildThumbnail(
              video.thumbnail,
            ),

            const SizedBox(
              width: 12,
            ),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  // =================================
                  // Title + Status
                  // =================================

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

                  // =================================
                  // Course
                  // =================================

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

                  // =================================
                  // Progress
                  // =================================

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

                  // =================================
                  // Duration
                  // =================================

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

  // =========================================
  // Thumbnail
  // =========================================

  Widget _buildThumbnail(
      dynamic thumbnail,
      ) {
    final bool hasThumbnail =
        thumbnail != null &&
            thumbnail
                .toString()
                .trim()
                .isNotEmpty;

    return ClipRRect(
      borderRadius:
      BorderRadius.circular(14),
      child: SizedBox(
        width: 105,
        height: 105,
        child: hasThumbnail
            ? Image.network(
          thumbnail.toString(),
          fit: BoxFit.cover,
          errorBuilder: (
              context,
              error,
              stackTrace,
              ) {
            return _thumbnailFallback();
          },
        )
            : _thumbnailFallback(),
      ),
    );
  }

  Widget _thumbnailFallback() {
    return Container(
      color:
      const Color(0xffE9F5F3),
      child: const Center(
        child: Icon(
          Icons
              .play_circle_outline_rounded,
          size: 42,
          color:
          Color(0xff2A9D8F),
        ),
      ),
    );
  }

  // =========================================
  // Duration
  //
  // API:
  // 15.5 = 15.5 دقيقة
  // 90 = ساعة و30 دقيقة
  // =========================================

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

  // =========================================
  // Safe number parser
  // =========================================

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

  // =========================================
  // Date
  // =========================================

  String _formatDate(
      DateTime date,
      ) {
    final localDate =
    date.toLocal();

    final day =
    localDate.day
        .toString()
        .padLeft(
      2,
      '0',
    );

    final month =
    localDate.month
        .toString()
        .padLeft(
      2,
      '0',
    );

    final hour =
    localDate.hour
        .toString()
        .padLeft(
      2,
      '0',
    );

    final minute =
    localDate.minute
        .toString()
        .padLeft(
      2,
      '0',
    );

    return '$day/$month/${localDate.year} - $hour:$minute';
  }
}