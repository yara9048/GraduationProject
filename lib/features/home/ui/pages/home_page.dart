import 'package:flutter/material.dart';
import 'package:graduationprojct/features/home/ui/widgets/new_added_course_template.dart';
import 'package:graduationprojct/features/home/ui/widgets/subjects_card_template.dart';

import '../widgets/course_card_template.dart';
import '../../../auth/ui/widgets/text_field_template.dart';
import '../widgets/section_title_template.dart';
import 'course_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: Image.asset('assets/Images/Ellipse 4.png'),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 50,
                      right: 30,
                      bottom: 30,
                    ),
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
                ),

                TextFieldTemplate(
                  hint: 'ابحث هنا',
                  size: 20,
                  size2: 21,
                  icon: Icons.search,
                ),

                const SizedBox(height: 30),

                Expanded(
                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 30),
                          child: const SectionTitle(title: "تتابعه الآن :"),
                        ),

                        const SizedBox(height: 10),

                        Padding(
                          padding: const EdgeInsets.only(right: 20, left: 20),
                          child: CourseCardTemplate(
                            imagePath:
                                'assets/Images/Gemini_Generated_Image_hy81hehy81hehy81 1.png',
                            title: 'حقوق المرأة في المجتمع السوري',
                            durationText: '2 ساعة',
                            progress: 0.2,
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(
                            right: 30,
                            left: 30,
                            top: 40,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SectionTitle(
                                title: "المقررات الأكاديمية :",
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => CourseView(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "عرض الكل",
                                  style: TextStyle(
                                    color: Color(0xffE9C46A),
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Tajawal",
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 10),

                        SizedBox(
                          height: 110,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              SubjectsCard(
                                title: "القانون المدني",
                                imagePath: 'assets/Images/Group 47.png',
                                textColor: Color(0xffA67500),
                                width: 220,
                              ),
                              SubjectsCard(
                                title: "قانون أصول المحاكمات الجزئية",
                                imagePath: 'assets/Images/Group 43.png',
                                textColor: Color(0xff009A87),
                                width: 220,
                                width2: 160,
                                top: 5,
                                size: 24,
                              ),
                              SubjectsCard(
                                title: "قانون العقوبات العام 3",
                                imagePath: 'assets/Images/Group 42.png',
                                textColor: Color(0xffE76F51),
                                width: 220,
                                width2: 150,
                              ),
                            ],
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(right: 30, top: 35),
                          child: const SectionTitle(title: "المضاف حديثا :"),
                        ),
                        NewAddedCourseTemplate(
                          imagePath: 'assets/Images/700ccaab9d6c5bae720cc6ee03954b805e4c490e.jpg',
                          title: 'مقدمة في قانون أصول المحاكمات الجزائية',
                          duration: '2 ساعة',
                          color: Color(0xffE76F51),
                          onPlayPressed: () {},
                          onDetailsPressed: () {},
                        ),
                        NewAddedCourseTemplate(
                          imagePath: 'assets/Images/download (2) 1.png',
                          title: 'مقدمة في قانون أصول المحاكمات الجزائية',
                          duration: '2 ساعة',
                          color: Color(0xffE2A9D8F),
                          onPlayPressed: () {},
                          onDetailsPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
