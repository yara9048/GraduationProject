import 'package:flutter/material.dart';
import 'package:graduationprojct/features/home/ui/widgets/subjects_card_template.dart';

class CourseView extends StatefulWidget {
  const CourseView({super.key});

  @override
  State<CourseView> createState() => _CourseViewState();
}

class _CourseViewState extends State<CourseView> {
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

            Expanded(
              child: MediaQuery.removePadding(
                removeTop: true,
                context: context,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ListView(
                    children: [
                      SizedBox(
                        height: 90,
                        child: SubjectsCard(
                          title: "القانون المدني",
                          imagePath: 'assets/Images/Group 51.png',
                          textColor: Color(0xffA67500),
                          width: 300,
                          top: 10,
                          width2: 250,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        height: 90,
                        child: SubjectsCard(
                          title: "قانون اصول المحاكمات الجزئية",
                          imagePath: 'assets/Images/Group 50.png',
                          textColor: Color(0xff009A87),
                          width: 100,
                          top: 10,
                          size: 22,
                          width2: 200,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        height: 90,
                        child: SubjectsCard(
                          title: "قانون العقوبات العام 3",
                          imagePath: 'assets/Images/Group 42.png',
                          textColor: Color(0xffE76F51),
                          width: 300,
                          top: 10,
                          width2: 230,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        height: 90,
                        child: SubjectsCard(
                          title: "قانون التجارة البحرية",
                          imagePath: 'assets/Images/Group 51.png',
                          textColor: Color(0xffA67500),
                          width: 300,
                          top: 10,
                          width2: 250,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        height: 90,
                        child: SubjectsCard(
                          title: "التنفيذ الجبري (اجراءات التنفيذ)",
                          imagePath: 'assets/Images/Group 50.png',
                          textColor: Color(0xff009A87),
                          width: 100,
                          top: 10,
                          size: 22,
                          width2: 200,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}