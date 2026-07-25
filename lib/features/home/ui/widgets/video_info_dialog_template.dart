import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../data/models/video_details_model.dart';
import 'description_card_template.dart';
import 'info_row_template.dart';

class VideoInfoDialog extends StatelessWidget {
  final VideoDetailsModel video;

  const VideoInfoDialog({
    super.key,
    required this.video,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 130,
              height: 65,
              decoration: const BoxDecoration(
                color: Color(0xff2A9D8F),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.info_outline_rounded,
                color: Colors.white,
                size: 34,
              ),
            ),

            const SizedBox(height: 18),

            Text(
              video.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: "Tajawal",
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xff264653),
              ),
            ),

            const SizedBox(height: 18),

            DescriptionCard(description: video.description),

            const SizedBox(height: 14),
            InfoRow(
              icon: Icons.access_time_rounded,
              title: "المدة",
              value: "${video.duration} دقيقة",
            ),

            InfoRow(
              icon: Icons.visibility_outlined,
              title: "المشاهدات",
              value: "${video.views}",
            ),

            InfoRow(
              icon: Icons.check_circle_outline,
              title: "الحالة",
              value: video.status,
              valueColor: const Color(0xff2A9D8F),
            ),

            InfoRow(
              icon: Icons.quiz_outlined,
              title: "عدد الأسئلة",
              value: "${video.mcqCount}",
            ),

            const SizedBox(height: 12),

            if (video.transcript.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xffF5F7F8),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  video.transcript,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontFamily: "Tajawal",
                    fontSize: 14,
                    height: 1.6,
                  ),
                ),
              ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff2A9D8F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    "إغلاق",
                    style: TextStyle(
                      fontFamily: "Tajawal",
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }}