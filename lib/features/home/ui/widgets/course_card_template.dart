import 'package:flutter/material.dart';
import 'package:graduationprojct/features/auth/ui/widgets/progress_line.dart';

import '../pages/display_videos_page.dart';

class CourseCardTemplate extends StatelessWidget {
  final String imagePath;
  final String description;

  final String title;
  final String durationText;
  final double progress;
  final double width;
  final double height;

  const CourseCardTemplate({
    super.key,
    required this.imagePath,
    required this.description,
    required this.title,
    required this.durationText,
    required this.progress,
    this.width = 375,
    this.height = 280,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){ Navigator.push(context, MaterialPageRoute(builder: (context){
        return DisplayVideosPage();
      }));},
      child: Container(
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
          crossAxisAlignment: CrossAxisAlignment.start,
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

            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(
                description,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 15,
                  fontFamily: "Tajawal",
                  color: Color(0xff92A1A1),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

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
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
                bottom: 20,
                top: 7
              ),
              child:CustomProgressLine(progress: progress),
              ),
          ],
        ),
      ),
    );
  }
}
