import 'package:flutter/material.dart';

import '../pages/video_details_page.dart';
import '../pages/videos_page.dart';

class NewAddedCourseTemplate extends StatelessWidget {
  final String imagePath;
  final String title;
  final String duration;
  final Color color;

  const NewAddedCourseTemplate({
    super.key,
    required this.imagePath,
    required this.color,
    required this.title,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20,left: 20,top: 20),
      child: Container(
        width: 290,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(22),
                  ),
                  child: Image.asset(
                    imagePath,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    alignment: const Alignment(0,0.3),
                  ),
                ),

                Positioned(
                  bottom: -18,
                  right: 18,
                  child: Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.play_arrow_outlined,
                        color: color,
                        size: 45,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 35),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  title,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontFamily: "Tajawal",
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff264653),
                  ),
                ),
              ),
            ),

            const SizedBox(height:2),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      color: Color(0xffB6B6B6),
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      duration,
                      style: const TextStyle(
                        fontSize: 15,
                        fontFamily: "Tajawal",
                        color: Color(0xff92A1A1),
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const Spacer(),

                    ElevatedButton(
                      onPressed :(){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => VideoDetailsPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(145, 34),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        "التفاصيل",
                        style: TextStyle(
                          fontFamily: "Tajawal",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),
          ],
        ),
      ),
    );
  }
}