import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/chat_page_provider.dart';
import '../widgets/bot_message_template.dart';
import '../widgets/user_mesaage_template.dart';
import 'video_details_page.dart';

class ChatPage extends StatefulWidget {
  final int id;
  final int chatId;
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

  final ScrollController _scrollController = ScrollController();

  static const int fixedChatId = 2;

  bool webSearch = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<ChatPageProvider>().loadHistory(chatId: fixedChatId);

      _scrollToBottom();
    });
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();

    if (text.isEmpty) return;

    _controller.clear();

    final provider = context.read<ChatPageProvider>();

    await provider.sendMessage(text: text);

    if (!mounted) return;

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,

        duration: const Duration(milliseconds: 300),

        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();

    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChatPageProvider>();

    return Directionality(
      textDirection: TextDirection.rtl,

      child: Scaffold(
        backgroundColor: const Color(0xffF6F8F8),

        appBar: _buildAppBar(),

        body: SafeArea(
          child: Column(
            children: [
              Expanded(child: _buildMessagesArea(provider)),

              if (provider.errorMessage != null) _buildErrorMessage(provider),

              _buildMessageInput(provider),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,

      toolbarHeight: 78,

      elevation: 0,

      centerTitle: true,

      backgroundColor: Colors.white,

      title: const Column(
        mainAxisSize: MainAxisSize.min,

        children: [
          Text(
            "المساعد الذكي",

            style: TextStyle(
              fontFamily: "Tajawal",

              fontSize: 20,

              fontWeight: FontWeight.bold,

              color: Color(0xff181C1F),
            ),
          ),

          SizedBox(height: 4),

          Text(
            "جاهز لمساعدتك",

            style: TextStyle(
              fontFamily: "Tajawal",

              fontSize: 12,

              color: Color(0xff777777),
            ),
          ),
        ],
      ),

      leading: Padding(
        padding: const EdgeInsets.all(12),

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
            Navigator.pushReplacement(
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

      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),

        child: Divider(height: 1, color: Color(0xffEEEEEE)),
      ),
    );
  }

  Widget _buildMessagesArea(ChatPageProvider provider) {
    if (provider.isLoadingHistory && provider.messages.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xff2A9D8F)),
      );
    }

    if (provider.messages.isEmpty) {
      return const Center(
        child: Text(
          "ابدأ المحادثة مع المساعد",

          style: TextStyle(fontFamily: "Tajawal", color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,

      padding: const EdgeInsets.all(16),

      itemCount: provider.messages.length + (provider.isSending ? 1 : 0),

      itemBuilder: (context, index) {
        if (provider.isSending && index == provider.messages.length) {
          return const Align(
            alignment: Alignment.centerRight,

            child: Padding(
              padding: EdgeInsets.all(12),

              child: Text(
                "جاري التفكير...",

                style: TextStyle(fontFamily: "Tajawal", color: Colors.grey),
              ),
            ),
          );
        }

        final message = provider.messages[index];

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),

          child: message.isUser
              ? UserMessage(text: message.text)
              : BotMessage(text: message.text),
        );
      },
    );
  }

  Widget _buildErrorMessage(ChatPageProvider provider) {
    return Container(
      margin: const EdgeInsets.all(10),

      padding: const EdgeInsets.all(10),

      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),

        borderRadius: BorderRadius.circular(12),
      ),

      child: Text(
        provider.errorMessage!,

        style: const TextStyle(fontFamily: "Tajawal", color: Colors.red),
      ),
    );
  }

  Widget _buildMessageInput(ChatPageProvider provider) {
    return Container(
      padding: const EdgeInsets.all(10),

      color: Colors.white,

      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,

              maxLines: 4,

              minLines: 1,

              decoration: InputDecoration(
                hintText: "اكتب سؤالك...",

                hintStyle: const TextStyle(fontFamily: "Tajawal"),

                filled: true,

                fillColor: const Color(0xffF5FAF9),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22),

                  borderSide: BorderSide.none,
                ),

                suffixIcon: IconButton(
                  tooltip: webSearch
                      ? "إيقاف البحث عبر الويب"
                      : "تفعيل البحث عبر الويب",
                  onPressed: () {
                    setState(() {
                      webSearch = !webSearch;
                      print(webSearch);
                    });
                  },

                  icon: Icon(
                    webSearch
                        ? Icons.travel_explore_rounded
                        : Icons.travel_explore_outlined,

                    color: webSearch ? const Color(0xff2A9D8F) : Colors.grey,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          GestureDetector(
            onTap: provider.isSending ? null : _sendMessage,

            child: CircleAvatar(
              radius: 25,

              backgroundColor: const Color(0xff2A9D8F),

              child: provider.isSending
                  ? const SizedBox(
                      width: 20,

                      height: 20,

                      child: CircularProgressIndicator(
                        color: Colors.white,

                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.send_rounded, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
