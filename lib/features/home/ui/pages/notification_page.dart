import 'package:flutter/material.dart';
import 'package:graduationprojct/features/home/providers/notifications_provider.dart';
import 'package:provider/provider.dart';

import '../widgets/notification_card_template.dart';
import 'main_navigation_page.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationsProvider>().getNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationsProvider>();
    final notifications = provider.notifications;

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

          Positioned.fill(
            top: 110,
            child: notifications.isEmpty
                ? const Center(
              child: Text(
                "لا يوجد إشعارات حالياً",
                style: TextStyle(
                  fontFamily: "Tajawal",
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              scrollDirection: Axis.vertical,
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];

                return NotificationCard(
                  title: notification.title,
                  message: notification.message,
                  time: notification.createdAt,
                );
              },
            ),
          ),
          Positioned(
            top: 55,
            right: 16,
            child: InkWell(
              borderRadius:
              BorderRadius.circular(20),
              onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context){return MainNavigationPage();}));},
              child: const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Text(
                      "سجل الاشعارات",
                      style: TextStyle(
                        fontWeight:
                        FontWeight.bold,
                        color:
                        Color(0xff2A9D8F),
                        fontFamily: "Tajawal",
                        fontSize: 20,
                      ),
                    ),

                    SizedBox(width: 10),
                    Icon(
                      Icons
                          .arrow_back_ios_new_rounded,
                      textDirection:
                      TextDirection.rtl,
                      color:
                      Color(0xff2A9D8F),
                      size: 20,
                    ),

                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}