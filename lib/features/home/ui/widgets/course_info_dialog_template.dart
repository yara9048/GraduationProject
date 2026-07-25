import 'package:flutter/material.dart';
import 'package:graduationprojct/features/home/data/models/playlist_details_model.dart';

import 'description_card_template.dart';
import 'info_row_template.dart';

class CourseInfoDialogTemplate extends StatelessWidget {
  final PlayListDetailsModel course;

  const CourseInfoDialogTemplate({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
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
                  Icons.school_outlined,
                  color: Colors.white,
                  size: 34,
                ),
              ),

              const SizedBox(height: 18),

              Text(
                course.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: "Tajawal",
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff264653),
                ),
              ),

              const SizedBox(height: 18),

              DescriptionCard(
                description: course.description,
              ),

              const SizedBox(height: 18),

              InfoRow(
                icon: Icons.category_outlined,
                title: "التصنيف",
                value: course.category,
              ),

              InfoRow(
                icon: Icons.play_circle_outline,
                title: "عدد الفيديوهات",
                value: "${course.totalVideoCount}",
              ),

              InfoRow(
                icon: Icons.schedule,
                title: "إجمالي المدة",
                value: "${course.totalDuration} دقيقة",
              ),

              InfoRow(
                icon: Icons.people_outline,
                title: "عدد الطلاب",
                value: "${course.studentsCount}",
              ),

              InfoRow(
                icon: Icons.star_rounded,
                title: "التقييم",
                value: "${course.rating}/5",
                valueColor: Colors.amber,
              ),

              InfoRow(
                icon: Icons.trending_up,
                title: "معدل الإنجاز",
                value: "${course.completionRate}%",
                valueColor: const Color(0xff2A9D8F),
              ),

              const SizedBox(height: 24),

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
      ),
    );
  }
}