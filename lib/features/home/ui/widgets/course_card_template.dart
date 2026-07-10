import 'package:flutter/material.dart';
import 'package:graduationprojct/features/auth/ui/widgets/progress_line.dart';

class CourseCardTemplate extends StatelessWidget {
  final String imagePath;
  final String title;
  final String durationText;
  final double progress;
  final double width;
  final double height;

  const CourseCardTemplate({
    super.key,
    required this.imagePath,
    required this.title,
    required this.durationText,
    required this.progress,
    this.width = 375,
    this.height = 280,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 20,
            offset: Offset(-3, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: SizedBox(
              height: 160,
              width: double.infinity,
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(
              left: 12,
              right: 12,
              top: 12,
            ),
            child: Align(
              alignment: Alignment.topRight,
              child: Text(
                title,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 19,
                  color: Color(0xff264653),
                  fontFamily: "Tajawal",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.access_time,
                    color: Color(0xff92A1A1),
                    size: 17,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    durationText,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 15,
                      fontFamily: "Tajawal",
                      color: Color(0xff92A1A1),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Spacer(),

          Padding(
            padding: const EdgeInsets.only(
              left: 12,
              right: 12,
              bottom: 20,
            ),
            child:CustomProgressLine(progress: progress),
            ),
        ],
      ),
    );
  }
}
