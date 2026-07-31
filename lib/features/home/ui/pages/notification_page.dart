import 'package:flutter/material.dart';

import '../widgets/notification_card_template.dart';
import 'main_navigation_page.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              'assets/Images/Ellipse 4.png',
            ),
          ),

          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
              'assets/Images/Ellipse 7.png',
            ),
          ),

          Positioned(
            top: 10,
            right: 16,
            child: SafeArea(
              bottom: false,
              child: Row(
                children: [
                  const Text(
                    "الإشعارات",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xff2A9D8F),
                      fontFamily: "Tajawal",
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(width: 8),

                  IconButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context){return MainNavigationPage();})),
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      textDirection: TextDirection.rtl,
                      color: Color(0xff2A9D8F),
                      size: 20,
                    ),
                  ),


                ],
              ),
            ),
          ),
          Positioned.fill(
            top: 130,
            child: ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              children: const [
                NotificationCard(
                  title: "تم إضافة درس جديد",
                  message:
                  "تم إضافة درس الذكاء الاصطناعي إلى قائمة التشغيل الخاصة بك.",
                  time: "منذ 5 دقائق",
                ),

                NotificationCard(
                  title: "تم إكمال الاختبار",
                  message:
                  "تهانينا! لقد حصلت على 92% في اختبار Flutter.",
                  time: "اليوم 10:30",
                ),

                NotificationCard(
                  title: "تجديد الاشتراك",
                  message:
                  "يتبقى 3 أيام على انتهاء اشتراكك الحالي.",
                  time: "أمس",
                ),

                SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }
}