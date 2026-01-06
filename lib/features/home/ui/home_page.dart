import 'package:flutter/material.dart';

import '../../auth/ui/widgets/course_card_template.dart';
import '../../auth/ui/widgets/text_field_template.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
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
              SizedBox(height: 60),
              Padding(
                padding: const EdgeInsets.only(right: 30),
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

              SizedBox(height: 20),
              TextFieldTemplate(
                hint: 'ابجث هنا',
                size: 20,
                size2: 21,
                icon: Icons.search,
              ),

              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(right: 30.0),
                child: Text(
                  ": تتابعه الآن",
                  style: TextStyle(
                    color: Color(0xff1A2429),
                    fontWeight: FontWeight.bold,
                    fontFamily: "Tajawal",
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(right: 30.0),
                child: CourseCardTemplate(
                  imagePath:
                  'assets/Images/Gemini_Generated_Image_hy81hehy81hehy81 1.png',
                  title: 'حقوق المرأة في المجتمع السوري',
                  durationText: '2 ساعة',
                  progress: 0.2,
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(right: 30.0,top: 40,left: 30),
                child:Directionality(
                  textDirection: TextDirection.rtl,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "المقررات الأكاديمية :",
                        style: TextStyle(
                          color: Color(0xff1A2429),
                          fontWeight: FontWeight.bold,
                          fontFamily: "Tajawal",
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        "عرض الكل",
                        style: TextStyle(
                          color: Color(0xffE9C46A),
                          fontWeight: FontWeight.bold,
                          fontFamily: "Tajawal",
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),]
          ),
        ],
      ),
    );
  }
}

