import 'package:flutter/material.dart';
import 'package:graduationprojct/features/home/ui/pages/video_details_page.dart';
import 'package:graduationprojct/features/home/ui/widgets/subjects_card_template.dart';

import '../widgets/new_added_course_template.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        child: Column(
          children: [
            SizedBox(
              height: 150,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Image.asset('assets/Images/Ellipse 4.png'),
                  ),

                  Positioned(
                    top: 55,
                    right: 16,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        textDirection: TextDirection.rtl,
                        color: Color(0xff2A9D8F),
                        size: 30,
                      ),
                    ),
                  ),

                  Positioned(
                    top: 50,
                    right: 70,
                    child: Text(
                      "مسار",
                      style: TextStyle(
                        fontSize: 43,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff2A9D8F),
                        fontFamily: "Tajawal",
                        shadows: [
                          Shadow(
                            offset: Offset(-1, 4),
                            blurRadius: 16,
                            color: Colors.black26,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Directionality(
              textDirection: TextDirection.rtl,
              child:  Padding(
                padding: const EdgeInsets.only(right: 30,left: 30),
                child: Text(
                  "فيديوهات قانون أصول المحاكمات الجزائية :",
                  style: const TextStyle(
                    color: Color(0xff1A2429),
                    fontWeight: FontWeight.bold,
                    fontFamily: "Tajawal",
                    fontSize: 22,
                  ),
                ),
              ),
            ),
            Expanded(
              child: MediaQuery.removePadding(
                removeTop: true,
                context: context,
                child: ListView(
                children: [
                  NewAddedCourseTemplate(
                    id: 1,
                    imagePath: 'assets/Images/700ccaab9d6c5bae720cc6ee03954b805e4c490e.jpg',
                    title: 'مقدمة في قانون أصول المحاكمات الجزائية',
                    duration: '2 ساعة',
                    color: Color(0xffE76F51),
                  ),
                  NewAddedCourseTemplate(
                    id: 1,
                    imagePath: 'assets/Images/download (2) 1.png',
                    title: 'مقدمة في قانون أصول المحاكمات الجزائية',
                    duration: '2 ساعة',
                    color: Color(0xffE2A9D8F),
                  ),

                ],
              ),
                            )

            )],
        ),
      ),
    );
  }
}