import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/view_chat_model.dart';
import '../../providers/chat_logic_provider.dart';
import 'video_details_page.dart';

class ChatPage extends StatefulWidget {
  final int id;
  final int chatId;

  final ViewChatModel initialChat;

  final String name;
  final int playlistId;

  const ChatPage({
    super.key,
    required this.id,
    required this.chatId,
    required this.initialChat,
    required this.name,
    required this.playlistId,
  });

  @override
  State<ChatPage> createState() =>
      _ChatPageState();
}

class _ChatPageState
    extends State<ChatPage> {
  final TextEditingController
  _controller =
  TextEditingController();

  final ScrollController
  _scrollController =
  ScrollController();

  // =============================================================
  // Init
  // =============================================================

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance
        .addPostFrameCallback(
          (_) {
        if (!mounted) return;

        context
            .read<
            ChatLogicProvider>()
            .initialize(
          videoId: widget.id,
          chatId: widget.chatId,
          initialChat:
          widget.initialChat,
        );

        _scrollToBottom();
      },
    );
  }

  // =============================================================
  // Scroll
  // =============================================================

  void _scrollToBottom() {
    WidgetsBinding.instance
        .addPostFrameCallback(
          (_) {
        if (!_scrollController
            .hasClients) {
          return;
        }

        _scrollController
            .animateTo(
          _scrollController
              .position
              .maxScrollExtent,
          duration:
          const Duration(
            milliseconds: 300,
          ),
          curve:
          Curves.easeOut,
        );
      },
    );
  }

  // =============================================================
  // Send
  // =============================================================

  Future<void>
  _sendMessage() async {
    final text =
    _controller.text.trim();

    if (text.isEmpty) {
      return;
    }

    final provider =
    context.read<
        ChatLogicProvider>();

    if (provider.isSending ||
        provider
            .isWaitingForAi) {
      return;
    }

    _controller.clear();

    FocusScope.of(context)
        .unfocus();

    await provider.sendMessage(
      text: text,
    );

    _scrollToBottom();
  }

  // =============================================================
  // Dispose
  // =============================================================

  @override
  void dispose() {
    context
        .read<
        ChatLogicProvider>()
        .stopPolling();

    _controller.dispose();

    _scrollController.dispose();

    super.dispose();
  }

  // =============================================================
  // Build
  // =============================================================

  @override
  Widget build(
      BuildContext context,
      ) {
    return Directionality(
      textDirection:
      TextDirection.rtl,
      child: Scaffold(
        backgroundColor:
        const Color(
          0xffF6F8F8,
        ),

        // =====================================================
        // AppBar
        // =====================================================

        appBar: AppBar(
          automaticallyImplyLeading:
          false,

          toolbarHeight: 78,

          elevation: 0,

          // مهم لمنع تغير اللون عند Scroll
          scrolledUnderElevation: 0,
          surfaceTintColor:
          Colors.transparent,
          shadowColor:
          Colors.transparent,

          centerTitle: true,

          backgroundColor:
          Colors.white,

          title:
          const Column(
            mainAxisSize:
            MainAxisSize.min,
            children: [
              Text(
                "المساعد الذكي",
                style:
                TextStyle(
                  fontFamily:
                  "Tajawal",
                  fontSize: 20,
                  fontWeight:
                  FontWeight.bold,
                  color: Color(
                    0xff181C1F,
                  ),
                ),
              ),

              SizedBox(
                height: 4,
              ),

              Text(
                "جاهز لمساعدتك",
                style:
                TextStyle(
                  fontFamily:
                  "Tajawal",
                  fontSize: 12,
                  color: Color(
                    0xff777777,
                  ),
                ),
              ),
            ],
          ),

          leading: Padding(
            padding:
            const EdgeInsets
                .all(
              12,
            ),
            child: Container(
              decoration:
              const BoxDecoration(
                color: Color(
                  0xff2A9D8F,
                ),
                shape:
                BoxShape.circle,
              ),
              child: const Icon(
                Icons
                    .smart_toy_rounded,
                color:
                Colors.white,
              ),
            ),
          ),

          actions: [
            IconButton(
              onPressed: () {
                context
                    .read<
                    ChatLogicProvider>()
                    .stopPolling();

                Navigator
                    .pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        VideoDetailsPage(
                          videoId:
                          widget.id,
                          videoName:
                          widget.name,
                          playlistId:
                          widget
                              .playlistId,
                        ),
                  ),
                );
              },
              icon:
              const Icon(
                Icons
                    .arrow_forward_ios_rounded,
                color: Color(
                  0xff2A9D8F,
                ),
              ),
            ),
          ],

          bottom:
          const PreferredSize(
            preferredSize:
            Size.fromHeight(
              1,
            ),
            child: Divider(
              height: 1,
              color: Color(
                0xffEEEEEE,
              ),
            ),
          ),
        ),

        // =====================================================
        // Body
        // =====================================================

        body: Consumer<
            ChatLogicProvider>(
          builder: (
              context,
              provider,
              child,
              ) {
            if (provider.chatId ==
                null) {
              return _buildError(
                provider
                    .errorMessage ??
                    "تعذر تحميل المحادثة",
                provider,
              );
            }

            WidgetsBinding.instance
                .addPostFrameCallback(
                  (_) {
                if (mounted) {
                  _scrollToBottom();
                }
              },
            );

            return Column(
              children: [
                // =================================================
                // Messages
                // =================================================

                Expanded(
                  child: provider
                      .messages
                      .isEmpty
                      ? _emptyChat()
                      : ListView
                      .builder(
                    controller:
                    _scrollController,
                    padding:
                    const EdgeInsets
                        .fromLTRB(
                      14,
                      18,
                      14,
                      18,
                    ),
                    itemCount:
                    provider
                        .messages
                        .length +
                        (provider
                            .isWaitingForAi
                            ? 1
                            : 0),
                    itemBuilder:
                        (
                        context,
                        index,
                        ) {
                      if (index ==
                          provider
                              .messages
                              .length) {
                        return _buildAiTyping();
                      }

                      final message =
                      provider
                          .messages[
                      index];

                      if (message
                          .isUser) {
                        return _buildUserMessage(
                          message
                              .text,
                        );
                      }

                      return _buildBotMessage(
                        message
                            .text,
                      );
                    },
                  ),
                ),

                // =================================================
                // Error
                // =================================================

                if (provider
                    .errorMessage !=
                    null)
                  _buildInlineError(
                    provider
                        .errorMessage!,
                  ),

                // =================================================
                // Input
                // =================================================

                _buildMessageInput(
                  provider,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // =============================================================
  // Empty Chat
  // =============================================================

  Widget _emptyChat() {
    return Center(
      child: Padding(
        padding:
        const EdgeInsets.all(
          30,
        ),
        child: Column(
          mainAxisSize:
          MainAxisSize.min,
          children: [
            Container(
              height: 70,
              width: 70,
              decoration:
              BoxDecoration(
                color:
                const Color(
                  0xff2A9D8F,
                ).withOpacity(
                  0.1,
                ),
                shape:
                BoxShape.circle,
              ),
              child: const Icon(
                Icons
                    .smart_toy_rounded,
                size: 34,
                color: Color(
                  0xff2A9D8F,
                ),
              ),
            ),

            const SizedBox(
              height: 16,
            ),

            const Text(
              "كيف يمكنني مساعدتك؟",
              style: TextStyle(
                fontFamily:
                "Tajawal",
                fontWeight:
                FontWeight.bold,
                fontSize: 18,
              ),
            ),

            const SizedBox(
              height: 6,
            ),

            const Text(
              "اسألني عن محتوى المحاضرة",
              style: TextStyle(
                fontFamily:
                "Tajawal",
                color: Color(
                  0xff777777,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =============================================================
  // Input
  // =============================================================

  Widget _buildMessageInput(
      ChatLogicProvider provider,
      ) {
    final bool disabled =
        provider.isSending ||
            provider
                .isWaitingForAi;

    return Container(
      padding:
      const EdgeInsets
          .fromLTRB(
        12,
        10,
        12,
        14,
      ),
      decoration:
      const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color:
            Color(
              0xffEEEEEE,
            ),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment:
          CrossAxisAlignment
              .end,
          children: [
            Expanded(
              child: Container(
                decoration:
                BoxDecoration(
                  color:
                  const Color(
                    0xffF6F8F8,
                  ),
                  borderRadius:
                  BorderRadius
                      .circular(
                    24,
                  ),
                  border:
                  Border.all(
                    color:
                    const Color(
                      0xffE5E5E5,
                    ),
                  ),
                ),
                child: Row(
                  crossAxisAlignment:
                  CrossAxisAlignment
                      .end,
                  children: [
                    IconButton(
                      onPressed:
                      disabled
                          ? null
                          : provider
                          .toggleWebSearch,
                      tooltip: provider
                          .webSearch
                          ? "إيقاف بحث الويب"
                          : "تفعيل بحث الويب",
                      icon: Icon(
                        provider
                            .webSearch
                            ? Icons
                            .language_rounded
                            : Icons
                            .language_outlined,
                        color: provider
                            .webSearch
                            ? const Color(
                          0xff2A9D8F,
                        )
                            : const Color(
                          0xff777777,
                        ),
                      ),
                    ),

                    Expanded(
                      child:
                      TextField(
                        controller:
                        _controller,
                        enabled:
                        !disabled,
                        minLines: 1,
                        maxLines: 5,
                        textInputAction:
                        TextInputAction
                            .newline,
                        style:
                        const TextStyle(
                          fontFamily:
                          "Tajawal",
                          fontSize: 15,
                        ),
                        decoration:
                        const InputDecoration(
                          hintText:
                          "اكتب سؤالك...",
                          hintStyle:
                          TextStyle(
                            fontFamily:
                            "Tajawal",
                            color:
                            Color(
                              0xff999999,
                            ),
                          ),
                          border:
                          InputBorder
                              .none,
                          contentPadding:
                          EdgeInsets
                              .symmetric(
                            horizontal:
                            8,
                            vertical:
                            13,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(
              width: 8,
            ),

            GestureDetector(
              onTap:
              disabled
                  ? null
                  : _sendMessage,
              child:
              AnimatedContainer(
                duration:
                const Duration(
                  milliseconds:
                  200,
                ),
                width: 48,
                height: 48,
                decoration:
                BoxDecoration(
                  color: disabled
                      ? Colors.grey
                      : const Color(
                    0xff2A9D8F,
                  ),
                  shape:
                  BoxShape.circle,
                ),
                child:
                provider.isSending
                    ? const Padding(
                  padding:
                  EdgeInsets
                      .all(
                    14,
                  ),
                  child:
                  CircularProgressIndicator(
                    strokeWidth:
                    2,
                    color:
                    Colors.white,
                  ),
                )
                    : const Icon(
                  Icons
                      .send_rounded,
                  color:
                  Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =============================================================
  // User Message
  // =============================================================

  Widget _buildUserMessage(
      String text,
      ) {
    return Align(
      alignment:
      Alignment.centerRight,
      child: Container(
        constraints:
        BoxConstraints(
          maxWidth:
          MediaQuery.of(
            context,
          ).size.width *
              0.78,
        ),
        margin:
        const EdgeInsets.only(
          bottom: 12,
        ),
        padding:
        const EdgeInsets
            .symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        decoration:
        const BoxDecoration(
          color:
          Color(
            0xff2A9D8F,
          ),
          borderRadius:
          BorderRadius.only(
            topLeft:
            Radius.circular(
              18,
            ),
            topRight:
            Radius.circular(
              18,
            ),
            bottomLeft:
            Radius.circular(
              18,
            ),
            bottomRight:
            Radius.circular(
              4,
            ),
          ),
        ),
        child: Text(
          text,
          style:
          const TextStyle(
            fontFamily:
            "Tajawal",
            color:
            Colors.white,
            fontSize: 15,
            height: 1.5,
          ),
        ),
      ),
    );
  }

  // =============================================================
  // Bot Message
  // =============================================================

  Widget _buildBotMessage(
      String text,
      ) {
    return Align(
      alignment:
      Alignment.centerLeft,
      child: Container(
        constraints:
        BoxConstraints(
          maxWidth:
          MediaQuery.of(
            context,
          ).size.width *
              0.82,
        ),
        margin:
        const EdgeInsets.only(
          bottom: 12,
        ),
        padding:
        const EdgeInsets
            .symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        decoration:
        BoxDecoration(
          color:
          Colors.white,
          borderRadius:
          const BorderRadius
              .only(
            topLeft:
            Radius.circular(
              18,
            ),
            topRight:
            Radius.circular(
              18,
            ),
            bottomRight:
            Radius.circular(
              18,
            ),
            bottomLeft:
            Radius.circular(
              4,
            ),
          ),
          border:
          Border.all(
            color:
            const Color(
              0xffE9E9E9,
            ),
          ),
        ),
        child: Text(
          text,
          style:
          const TextStyle(
            fontFamily:
            "Tajawal",
            color:
            Color(
              0xff181C1F,
            ),
            fontSize: 15,
            height: 1.6,
          ),
        ),
      ),
    );
  }

  // =============================================================
  // AI typing
  // =============================================================

  Widget _buildAiTyping() {
    return Align(
      alignment:
      Alignment.centerLeft,
      child: Container(
        margin:
        const EdgeInsets.only(
          bottom: 12,
        ),
        padding:
        const EdgeInsets
            .symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        decoration:
        BoxDecoration(
          color:
          Colors.white,
          borderRadius:
          BorderRadius
              .circular(
            18,
          ),
          border:
          Border.all(
            color:
            const Color(
              0xffE9E9E9,
            ),
          ),
        ),
        child:
        const Row(
          mainAxisSize:
          MainAxisSize.min,
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child:
              CircularProgressIndicator(
                strokeWidth: 2,
                color:
                Color(
                  0xff2A9D8F,
                ),
              ),
            ),

            SizedBox(
              width: 10,
            ),

            Text(
              "جاري تجهيز الإجابة...",
              style:
              TextStyle(
                fontFamily:
                "Tajawal",
                fontSize: 13,
                color:
                Color(
                  0xff777777,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =============================================================
  // Inline Error
  // =============================================================

  Widget _buildInlineError(
      String error,
      ) {
    return Container(
      width:
      double.infinity,
      margin:
      const EdgeInsets
          .symmetric(
        horizontal: 14,
      ),
      padding:
      const EdgeInsets.all(
        10,
      ),
      decoration:
      BoxDecoration(
        color:
        Colors.red.shade50,
        borderRadius:
        BorderRadius
            .circular(
          10,
        ),
      ),
      child: Text(
        error,
        textAlign:
        TextAlign.center,
        style:
        TextStyle(
          fontFamily:
          "Tajawal",
          color:
          Colors.red.shade700,
          fontSize: 12,
        ),
      ),
    );
  }

  // =============================================================
  // Error
  // =============================================================

  Widget _buildError(
      String error,
      ChatLogicProvider provider,
      ) {
    return Center(
      child: Padding(
        padding:
        const EdgeInsets.all(
          24,
        ),
        child: Column(
          mainAxisSize:
          MainAxisSize.min,
          children: [
            const Icon(
              Icons
                  .error_outline_rounded,
              color:
              Colors.red,
              size: 44,
            ),

            const SizedBox(
              height: 12,
            ),

            Text(
              error,
              textAlign:
              TextAlign.center,
              style:
              const TextStyle(
                fontFamily:
                "Tajawal",
              ),
            ),

            const SizedBox(
              height: 16,
            ),

            ElevatedButton(
              onPressed: () {
                provider
                    .initialize(
                  videoId:
                  widget.id,
                  chatId:
                  widget.chatId,
                  initialChat:
                  widget.initialChat,
                );
              },
              style:
              ElevatedButton
                  .styleFrom(
                backgroundColor:
                const Color(
                  0xff2A9D8F,
                ),
                foregroundColor:
                Colors.white,
              ),
              child:
              const Text(
                "إعادة المحاولة",
                style:
                TextStyle(
                  fontFamily:
                  "Tajawal",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}