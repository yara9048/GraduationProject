import 'package:flutter/material.dart';
import '../../data/models/watching_history_nodel.dart';

class WatchingHistoryCard extends StatelessWidget {
  final WatchingHistoryModel history;
  final VoidCallback? onTap;

  const WatchingHistoryCard({super.key, required this.history, this.onTap});

  @override
  Widget build(BuildContext context) {
    final video = history.videoDetail;
    final course = history.courseDetail;

    final double progress = history.progressSeconds;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xffE0ECEA)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildThumbnail(video.thumbnail),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          video.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Tajawal',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff264653),
                            height: 1.4,
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: history.isCompleted
                              ? const Color(0xff2A9D8F).withOpacity(0.12)
                              : const Color(0xffE9C46A).withOpacity(0.20),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          history.isCompleted ? 'مكتمل' : 'قيد المشاهدة',
                          style: TextStyle(
                            fontFamily: 'Tajawal',
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: history.isCompleted
                                ? const Color(0xff2A9D8F)
                                : const Color(0xffB7791F),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 5),

                  Row(
                    children: [
                      const Icon(
                        Icons.playlist_play_rounded,
                        size: 17,
                        color: Color(0xff2A9D8F),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          course.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Tajawal',
                            fontSize: 12,
                            color: Color(0xff6C7A7A),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 11),

                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 7,
                            backgroundColor: const Color(0xffE5F1EF),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xff2A9D8F),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      Text(
                        '${(progress * 100).round()}%',
                        style: const TextStyle(
                          fontFamily: 'Tajawal',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff2A9D8F),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.schedule_rounded,
                            size: 16,
                            color: const Color(0xff839493),
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              video.duration.toString(),

                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: 'Tajawal',
                                fontSize: 11,
                                color: Color(0xff839493),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.history_rounded,
                              size: 16,
                              color: const Color(0xff839493),
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                _formatDate(history.lastWatchedAt),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontFamily: 'Tajawal',
                                  fontSize: 11,
                                  color: Color(0xff839493),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail(dynamic thumbnail) {
    final bool hasThumbnail =
        thumbnail != null && thumbnail.toString().trim().isNotEmpty;

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        width: 105,
        height: 105,
        child: hasThumbnail
            ? Image.network(
                thumbnail.toString(),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
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
    );
  }

  String _formatDate(DateTime date) {
    final localDate = date.toLocal();

    final day = localDate.day.toString().padLeft(2, '0');

    final month = localDate.month.toString().padLeft(2, '0');

    final hour = localDate.hour.toString().padLeft(2, '0');

    final minute = localDate.minute.toString().padLeft(2, '0');

    return '$day/$month/${localDate.year} - $hour:$minute';
  }
}
