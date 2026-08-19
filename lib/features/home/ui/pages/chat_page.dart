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
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller =
  TextEditingController();

  final ScrollController _scrollController =
  ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
          (_) {
        if (!mounted) {
          return;
        }

        context.read<ChatLogicProvider>().initialize(
          videoId: widget.id,
          chatId: widget.chatId,
          initialChat: widget.initialChat,
        );

        _scrollToBottom();
      },
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback(
          (_) {
        if (!_scrollController.hasClients) {
          return;
        }

        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(
            milliseconds: 300,
          ),
          curve: Curves.easeOut,
        );
      },
    );
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();

    if (text.isEmpty) {
      return;
    }

    final provider =
    context.read<ChatLogicProvider>();

    if (!provider.canSend) {
      return;
    }

    _controller.clear();

    FocusScope.of(context).unfocus();

    await provider.sendMessage(
      text: text,
    );

    if (!mounted) {
      return;
    }

    _scrollToBottom();
  }

  void _openVideoSegment({
    required double startSeconds,
    required double endSeconds,
  }) {
    context
        .read<ChatLogicProvider>()
        .stopPolling();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VideoDetailsPage(
          videoId: widget.id,
          videoName: widget.name,
          playlistId: widget.playlistId,
          startAtSeconds: startSeconds,
          endAtSeconds: endSeconds,
        ),
      ),
    );
  }

  @override
  void dispose() {
    context
        .read<ChatLogicProvider>()
        .stopPolling();

    _controller.dispose();
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(
          0xffF6F8F8,
        ),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 78,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          shadowColor: Colors.transparent,
          centerTitle: true,
          backgroundColor: Colors.white,
          title: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'المساعد الذكي',
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(
                    0xff181C1F,
                  ),
                ),
              ),
              SizedBox(height: 4),
              Text(
                'جاهز لمساعدتك',
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 12,
                  color: Color(
                    0xff777777,
                  ),
                ),
              ),
            ],
          ),
          leading: Padding(
            padding: const EdgeInsets.all(
              12,
            ),
            child: Container(
              decoration: const BoxDecoration(
                color: Color(
                  0xff2A9D8F,
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.smart_toy_rounded,
                color: Colors.white,
              ),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                context
                    .read<ChatLogicProvider>()
                    .stopPolling();

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        VideoDetailsPage(
                          videoId: widget.id,
                          videoName: widget.name,
                          playlistId:
                          widget.playlistId,
                        ),
                  ),
                );
              },
              icon: const Icon(
                Icons
                    .arrow_forward_ios_rounded,
                color: Color(
                  0xff2A9D8F,
                ),
              ),
            ),
          ],
          bottom: const PreferredSize(
            preferredSize:
            Size.fromHeight(1),
            child: Divider(
              height: 1,
              color: Color(
                0xffEEEEEE,
              ),
            ),
          ),
        ),
        body: Consumer<ChatLogicProvider>(
          builder: (
              context,
              provider,
              child,
              ) {
            if (provider.chatId == null) {
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
                        color: Colors.red,
                        size: 44,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        provider.errorMessage ??
                            'تعذر تحميل المحادثة',
                        textAlign:
                        TextAlign.center,
                        style:
                        const TextStyle(
                          fontFamily:
                          'Tajawal',
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          provider.initialize(
                            videoId:
                            widget.id,
                            chatId:
                            widget.chatId,
                            initialChat:
                            widget
                                .initialChat,
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
                        child: const Text(
                          'إعادة المحاولة',
                          style: TextStyle(
                            fontFamily:
                            'Tajawal',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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
                Expanded(
                  child:
                  provider.messages.isEmpty
                      ? Center(
                    child:
                    Padding(
                      padding:
                      const EdgeInsets
                          .all(
                        30,
                      ),
                      child:
                      Column(
                        mainAxisSize:
                        MainAxisSize
                            .min,
                        children: [
                          Container(
                            height:
                            70,
                            width:
                            70,
                            decoration:
                            BoxDecoration(
                              color: const Color(
                                0xff2A9D8F,
                              ).withOpacity(
                                0.1,
                              ),
                              shape:
                              BoxShape.circle,
                            ),
                            child:
                            const Icon(
                              Icons
                                  .smart_toy_rounded,
                              size:
                              34,
                              color:
                              Color(
                                0xff2A9D8F,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height:
                            16,
                          ),
                          const Text(
                            'كيف يمكنني مساعدتك؟',
                            style:
                            TextStyle(
                              fontFamily:
                              'Tajawal',
                              fontWeight:
                              FontWeight.bold,
                              fontSize:
                              18,
                            ),
                          ),
                          const SizedBox(
                            height:
                            6,
                          ),
                          const Text(
                            'اسألني عن محتوى المحاضرة',
                            style:
                            TextStyle(
                              fontFamily:
                              'Tajawal',
                              color:
                              Color(
                                0xff777777,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                      : ListView.builder(
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
                        return Align(
                          alignment:
                          Alignment
                              .centerLeft,
                          child:
                          Container(
                            margin:
                            const EdgeInsets
                                .only(
                              bottom:
                              12,
                            ),
                            padding:
                            const EdgeInsets
                                .symmetric(
                              horizontal:
                              16,
                              vertical:
                              12,
                            ),
                            decoration:
                            BoxDecoration(
                              color:
                              Colors.white,
                              borderRadius:
                              BorderRadius.circular(
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
                                  width:
                                  16,
                                  height:
                                  16,
                                  child:
                                  CircularProgressIndicator(
                                    strokeWidth:
                                    2,
                                    color:
                                    Color(
                                      0xff2A9D8F,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                  10,
                                ),
                                Text(
                                  'جاري تجهيز الإجابة...',
                                  style:
                                  TextStyle(
                                    fontFamily:
                                    'Tajawal',
                                    fontSize:
                                    13,
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

                      final message =
                      provider
                          .messages[
                      index
                      ];

                      if (message
                          .isUser) {
                        return Align(
                          alignment:
                          Alignment
                              .centerRight,
                          child:
                          Container(
                            constraints:
                            BoxConstraints(
                              maxWidth:
                              MediaQuery.of(
                                context,
                              ).size.width *
                                  0.78,
                            ),
                            margin:
                            const EdgeInsets
                                .only(
                              bottom:
                              12,
                            ),
                            padding:
                            const EdgeInsets
                                .symmetric(
                              horizontal:
                              16,
                              vertical:
                              12,
                            ),
                            decoration:
                            const BoxDecoration(
                              color:
                              Color(
                                0xff2A9D8F,
                              ),
                              borderRadius:
                              BorderRadius
                                  .only(
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
                            child:
                            Text(
                              message
                                  .text,
                              style:
                              const TextStyle(
                                fontFamily:
                                'Tajawal',
                                color:
                                Colors.white,
                                fontSize:
                                15,
                                height:
                                1.5,
                              ),
                            ),
                          ),
                        );
                      }

                      final parsed =
                      provider
                          .parseAiMessage(
                        message
                            .text,
                      );

                      return Align(
                        alignment:
                        Alignment
                            .centerLeft,
                        child:
                        Container(
                          constraints:
                          BoxConstraints(
                            maxWidth:
                            MediaQuery.of(
                              context,
                            ).size.width *
                                0.82,
                          ),
                          margin:
                          const EdgeInsets
                              .only(
                            bottom:
                            12,
                          ),
                          padding:
                          const EdgeInsets
                              .symmetric(
                            horizontal:
                            16,
                            vertical:
                            12,
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
                          child:
                          Column(
                            crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                            children: [
                              Text(
                                parsed
                                    .answer,
                                style:
                                const TextStyle(
                                  fontFamily:
                                  'Tajawal',
                                  color:
                                  Color(
                                    0xff181C1F,
                                  ),
                                  fontSize:
                                  15,
                                  height:
                                  1.6,
                                ),
                              ),
                              if (parsed
                                  .segments
                                  .isNotEmpty) ...[
                                const SizedBox(
                                  height:
                                  14,
                                ),
                                const Divider(
                                  height:
                                  1,
                                  color:
                                  Color(
                                    0xffEEEEEE,
                                  ),
                                ),
                                const SizedBox(
                                  height:
                                  10,
                                ),
                                const Row(
                                  children: [
                                    Icon(
                                      Icons.play_circle_outline_rounded,
                                      size:
                                      19,
                                      color:
                                      Color(
                                        0xff2A9D8F,
                                      ),
                                    ),
                                    SizedBox(
                                      width:
                                      6,
                                    ),
                                    Text(
                                      'من الفيديو',
                                      style:
                                      TextStyle(
                                        fontFamily:
                                        'Tajawal',
                                        fontWeight:
                                        FontWeight.bold,
                                        fontSize:
                                        13,
                                        color:
                                        Color(
                                          0xff2A9D8F,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height:
                                  8,
                                ),
                                ...parsed
                                    .segments
                                    .map(
                                      (
                                      segment,
                                      ) {
                                    return Container(
                                      width:
                                      double.infinity,
                                      margin:
                                      const EdgeInsets.only(
                                        bottom:
                                        7,
                                      ),
                                      child:
                                      OutlinedButton.icon(
                                        onPressed:
                                            () {
                                          _openVideoSegment(
                                            startSeconds:
                                            segment.startSeconds,
                                            endSeconds:
                                            segment.endSeconds,
                                          );
                                        },
                                        style:
                                        OutlinedButton.styleFrom(
                                          foregroundColor:
                                          const Color(
                                            0xff2A9D8F,
                                          ),
                                          side:
                                          const BorderSide(
                                            color:
                                            Color(
                                              0xff2A9D8F,
                                            ),
                                          ),
                                          padding:
                                          const EdgeInsets.symmetric(
                                            horizontal:
                                            12,
                                            vertical:
                                            9,
                                          ),
                                          shape:
                                          RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                        icon:
                                        const Icon(
                                          Icons.play_arrow_rounded,
                                          size:
                                          20,
                                        ),
                                        label:
                                        Text(
                                          'مشاهدة الجزء '
                                              '${segment.startLabel} - '
                                              '${segment.endLabel}',
                                          style:
                                          const TextStyle(
                                            fontFamily:
                                            'Tajawal',
                                            fontSize:
                                            13,
                                            fontWeight:
                                            FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                if (provider.errorMessage !=
                    null)
                  Container(
                    width:
                    double.infinity,
                    margin:
                    const EdgeInsets.symmetric(
                      horizontal:
                      14,
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
                      BorderRadius.circular(
                        10,
                      ),
                    ),
                    child: Text(
                      provider.errorMessage!,
                      textAlign:
                      TextAlign.center,
                      style:
                      TextStyle(
                        fontFamily:
                        'Tajawal',
                        color:
                        Colors.red.shade700,
                        fontSize:
                        12,
                      ),
                    ),
                  ),

                Container(
                  padding:
                  const EdgeInsets.fromLTRB(
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
                    child: Column(
                      mainAxisSize:
                      MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap:
                              provider.canSend
                                  ? provider
                                  .toggleWebSearch
                                  : null,
                              borderRadius:
                              BorderRadius.circular(
                                20,
                              ),
                              child:
                              AnimatedContainer(
                                duration:
                                const Duration(
                                  milliseconds:
                                  200,
                                ),
                                padding:
                                const EdgeInsets.symmetric(
                                  horizontal:
                                  12,
                                  vertical:
                                  8,
                                ),
                                decoration:
                                BoxDecoration(
                                  color:
                                  provider.webSearch
                                      ? const Color(
                                    0xff2A9D8F,
                                  )
                                      : const Color(
                                    0xffF4FAF9,
                                  ),
                                  borderRadius:
                                  BorderRadius.circular(
                                    20,
                                  ),
                                  border:
                                  Border.all(
                                    color:
                                    provider.webSearch
                                        ? const Color(
                                      0xff2A9D8F,
                                    )
                                        : const Color(
                                      0xffCFE4E1,
                                    ),
                                  ),
                                  boxShadow:
                                  provider.webSearch
                                      ? [
                                    BoxShadow(
                                      color: const Color(
                                        0xff2A9D8F,
                                      ).withValues(
                                        alpha: 0.18,
                                      ),
                                      blurRadius:
                                      7,
                                      offset:
                                      const Offset(
                                        0,
                                        2,
                                      ),
                                    ),
                                  ]
                                      : null,
                                ),
                                child:
                                Row(
                                  mainAxisSize:
                                  MainAxisSize.min,
                                  children: [
                                    Icon(
                                      provider.webSearch
                                          ? Icons
                                          .language_rounded
                                          : Icons
                                          .language_outlined,
                                      size:
                                      18,
                                      color:
                                      provider.webSearch
                                          ? Colors.white
                                          : const Color(
                                        0xff2A9D8F,
                                      ),
                                    ),
                                    const SizedBox(
                                      width:
                                      6,
                                    ),
                                    Text(
                                      'بحث الويب',
                                      style:
                                      TextStyle(
                                        fontFamily:
                                        'Tajawal',
                                        fontSize:
                                        12,
                                        fontWeight:
                                        FontWeight.bold,
                                        color:
                                        provider.webSearch
                                            ? Colors.white
                                            : const Color(
                                          0xff264653,
                                        ),
                                      ),
                                    ),
                                    if (provider
                                        .webSearch) ...[
                                      const SizedBox(
                                        width:
                                        5,
                                      ),
                                      const Icon(
                                        Icons
                                            .check_circle_rounded,
                                        size:
                                        16,
                                        color:
                                        Colors.white,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            AnimatedSwitcher(
                              duration:
                              const Duration(
                                milliseconds:
                                200,
                              ),
                              child:
                              provider.webSearch
                                  ? const Text(
                                'مفعّل',
                                key: ValueKey(
                                  'web-search-on',
                                ),
                                style:
                                TextStyle(
                                  fontFamily:
                                  'Tajawal',
                                  fontSize:
                                  11,
                                  fontWeight:
                                  FontWeight.bold,
                                  color:
                                  Color(
                                    0xff2A9D8F,
                                  ),
                                ),
                              )
                                  : const Text(
                                'غير مفعّل',
                                key: ValueKey(
                                  'web-search-off',
                                ),
                                style:
                                TextStyle(
                                  fontFamily:
                                  'Tajawal',
                                  fontSize:
                                  11,
                                  color:
                                  Color(
                                    0xff888888,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 9,
                        ),

                        Row(
                          crossAxisAlignment:
                          CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child:
                              Container(
                                decoration:
                                BoxDecoration(
                                  color:
                                  const Color(
                                    0xffF6F8F8,
                                  ),
                                  borderRadius:
                                  BorderRadius.circular(
                                    24,
                                  ),
                                  border:
                                  Border.all(
                                    color:
                                    provider.webSearch
                                        ? const Color(
                                      0xff9FD3CC,
                                    )
                                        : const Color(
                                      0xffE5E5E5,
                                    ),
                                  ),
                                ),
                                child:
                                TextField(
                                  cursorColor:
                                  const Color(
                                    0xff2A9D8F,
                                  ),
                                  controller:
                                  _controller,
                                  enabled:
                                  provider.canSend,
                                  minLines:
                                  1,
                                  maxLines:
                                  5,
                                  textInputAction:
                                  TextInputAction
                                      .newline,
                                  style:
                                  const TextStyle(
                                    fontFamily:
                                    'Tajawal',
                                    fontSize:
                                    15,
                                  ),
                                  decoration:
                                  InputDecoration(
                                    hintText:
                                    provider.webSearch
                                        ? 'اسألني وسأبحث لك على الويب...'
                                        : 'اسألني عن محتوى المحاضرة...',
                                    hintStyle:
                                    const TextStyle(
                                      fontFamily:
                                      'Tajawal',
                                      color:
                                      Color(
                                        0xff999999,
                                      ),
                                    ),
                                    prefixIcon:
                                    provider.webSearch
                                        ? const Icon(
                                      Icons.language_rounded,
                                      size:
                                      20,
                                      color:
                                      Color(
                                        0xff2A9D8F,
                                      ),
                                    )
                                        : null,
                                    border:
                                    InputBorder.none,
                                    contentPadding:
                                    const EdgeInsets.symmetric(
                                      horizontal:
                                      14,
                                      vertical:
                                      13,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(
                              width: 8,
                            ),

                            GestureDetector(
                              onTap:
                              provider.canSend
                                  ? _sendMessage
                                  : null,
                              child:
                              AnimatedContainer(
                                duration:
                                const Duration(
                                  milliseconds:
                                  200,
                                ),
                                width:
                                48,
                                height:
                                48,
                                decoration:
                                BoxDecoration(
                                  color:
                                  provider.canSend
                                      ? const Color(
                                    0xff2A9D8F,
                                  )
                                      : Colors.grey,
                                  shape:
                                  BoxShape.circle,
                                ),
                                child:
                                provider.isSending
                                    ? const Padding(
                                  padding:
                                  EdgeInsets.all(
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
                                  Icons.send_rounded,
                                  color:
                                  Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}