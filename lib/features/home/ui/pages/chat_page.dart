import 'package:flutter/material.dart';
import 'package:graduationprojct/features/home/ui/pages/video_details_page.dart';

import '../widgets/bot_message_template.dart';
import '../widgets/user_mesaage_template.dart';

class ChatPage extends StatelessWidget {
  final int id;
  final int chatId;
  final String name;
  final int playlistId;
  const ChatPage({super.key, required this.id, required this.name, required this.playlistId, required this.chatId});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xffE9C46A).withOpacity(0.1),
          elevation: 0,
          automaticallyImplyLeading: false,
          toolbarHeight: 80,
          centerTitle: true,

          title: const Text(
            "المساعد الذكي",
            style: TextStyle(
              fontFamily: "Tajawal",
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xff181C1F),
            ),
          ),

          leading: Padding(
            padding: const EdgeInsets.all(8),
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xff2A9D8F),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.smart_toy_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),

          actions: [
            IconButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context){return VideoDetailsPage(videoId: id, videoName: name, playlistId: playlistId,);})),
              icon: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Color(0xffD9A63A),
                size: 24,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xffF8F8F8),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: const [
                    BotMessage(
                      text:
                      "مرحباً، أنا هنا لمساعدتك في فهم محتوى الفيديو. ما هو سؤالك؟",
                    ),

                    SizedBox(height: 16),

                    UserMessage(
                      text:
                      "ما هي الجهة المختصة بإصدار مذكرة التوقيف في الجنايات وفقاً لقانون أصول المحاكمات الجزائرية؟",
                    ),

                    SizedBox(height: 16),

                    BotMessage(
                      text:
                      "إن الجهة المختصة بإصدار مذكرة التوقيف في الجنايات وفقاً لقانون أصول المحاكمات الجزائية هي قاضي التحقيق. ويصدرها عندما تتوفر الشروط القانونية لذلك، وتُستخدم لضمان حضور المتهم أو تنفيذ الإجراءات القضائية.",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


