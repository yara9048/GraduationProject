import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/chat_message_provider.dart';
import '../widgets/bot_message_template.dart';
import '../widgets/user_mesaage_template.dart';
import 'video_details_page.dart';

class ChatPage extends StatefulWidget {
  final int id; // video id
  final int chatId; // chat id
  final String name;
  final int playlistId;

  const ChatPage({
    super.key,
    required this.id,
    required this.chatId,
    required this.name,
    required this.playlistId,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();

  final List<Map<String, String>> messages = [
    {
      "type": "bot",
      "text": "مرحباً، أنا هنا لمساعدتك في فهم محتوى الفيديو. ما هو سؤالك؟",
    },
  ];

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();

    if (text.isEmpty) {
      return;
    }

    setState(() {
      messages.add({"type": "user", "text": text});
    });

    _controller.clear();

    final provider = context.read<ChatMessageProvider>();

    await provider.create(id: widget.chatId, text: text);

    if (!mounted) return;

    if (provider.isSuccess && provider.response != null) {
      setState(() {
        messages.add({"type": "bot", "text": provider.response!.text});
      });
    } else {
      setState(() {
        messages.add({
          "type": "bot",

          "text": provider.errorMessage ?? "حدث خطأ أثناء إرسال الرسالة",
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChatMessageProvider>();

    return Directionality(
      textDirection: TextDirection.rtl,

      child: Scaffold(
        backgroundColor: const Color(0xffF8F8F8),

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

              child: const Icon(Icons.smart_toy_rounded, color: Colors.white),
            ),
          ),

          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,

                  MaterialPageRoute(
                    builder: (_) => VideoDetailsPage(
                      videoId: widget.id,

                      videoName: widget.name,

                      playlistId: widget.playlistId,
                    ),
                  ),
                );
              },

              icon: const Icon(
                Icons.arrow_forward_ios_rounded,

                color: Color(0xffD9A63A),
              ),
            ),
          ],
        ),

        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),

                  itemCount: messages.length,

                  itemBuilder: (context, index) {
                    final message = messages[index];

                    if (message["type"] == "user") {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),

                        child: UserMessage(text: message["text"]!),
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),

                        child: BotMessage(text: message["text"]!),
                      );
                    }
                  },
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),

                color: Colors.white,

                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,

                        maxLines: 3,

                        minLines: 1,

                        decoration: InputDecoration(
                          hintText: "اكتب سؤالك...",

                          hintStyle: const TextStyle(fontFamily: "Tajawal"),

                          filled: true,

                          fillColor: const Color(0xffF5FAF9),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),

                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    IconButton(
                      onPressed: provider.isLoading ? null : _sendMessage,

                      icon: provider.isLoading
                          ? const SizedBox(
                              width: 22,

                              height: 22,

                              child: CircularProgressIndicator(
                                strokeWidth: 2,

                                color: Color(0xff2A9D8F),
                              ),
                            )
                          : const Icon(
                              Icons.send_rounded,

                              color: Color(0xff2A9D8F),
                            ),
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
