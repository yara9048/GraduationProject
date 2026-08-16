import 'dart:async';

import 'package:flutter/material.dart';
import 'package:graduationprojct/features/home/ui/pages/chat_page.dart';
import 'package:graduationprojct/features/home/ui/pages/display_videos_page.dart';
import 'package:graduationprojct/features/home/ui/pages/pdf_viewer_page.dart';
import 'package:graduationprojct/features/home/ui/pages/summary_page.dart';
import 'package:graduationprojct/features/home/ui/pages/video_info_page.dart';
import 'package:provider/provider.dart';

import '../../providers/add_video_to_fav_provider.dart';
import '../../providers/get_video_progress_provider.dart';
import '../../providers/video_details_function_provider.dart';
import '../../providers/video_details_provider.dart';
import '../../providers/video_progress_provider.dart';
import '../../providers/view_chat_provider.dart';
import '../widgets/lock_dialog_template.dart';
import '../widgets/option_cart_template.dart';
import '../widgets/video_player_section.dart';
import 'mcq_page.dart';

class VideoDetailsPage
    extends StatefulWidget {
  final int playlistId;
  final int videoId;
  final String videoName;

  const VideoDetailsPage({
    super.key,
    required this.videoId,
    required this.playlistId,
    required this.videoName,
  });

  @override
  State<VideoDetailsPage>
  createState() =>
      _VideoDetailsPageState();
}

class _VideoDetailsPageState
    extends State<VideoDetailsPage> {
  bool isFavorite = false;
  bool _videoInitialized = false;
  bool _isLeavingPage = false;

  VideoDetailsFunctionProvider?
  _videoFunctionProvider;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance
        .addPostFrameCallback(
          (_) async {
        await _loadVideo();
      },
    );
  }

  Future<void> _loadVideo() async {
    if (!mounted) return;

    final detailsProvider =
    context.read<
        VideoDetailsProvider>();

    final videoFunctionProvider =
    context.read<
        VideoDetailsFunctionProvider>();

    final getProgressProvider =
    context.read<
        GetVideoProgressProvider>();

    await detailsProvider.getDetails(
      id: widget.videoId,
    );

    if (!mounted) return;

    final details =
        detailsProvider.videoDetails;

    final String? videoUrl =
        details?.videoFile;

    final Object? durationMinutes =
        details?.duration;

    await getProgressProvider
        .getProgress(
      id: widget.videoId,
    );

    if (!mounted) return;

    final double initialProgress =
    getProgressProvider
        .initialProgressForVideo(
      widget.videoId,
    );

    videoFunctionProvider
        .setInitialWatchProgress(
      initialProgress,
    );

    await videoFunctionProvider
        .initializeVideo(
      videoUrl,
      durationMinutes:
      durationMinutes,
    );

    if (!mounted) return;

    setState(() {
      _videoInitialized = true;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _videoFunctionProvider ??=
        context.read<
            VideoDetailsFunctionProvider>();
  }

  @override
  void didUpdateWidget(
      covariant VideoDetailsPage
      oldWidget,
      ) {
    super.didUpdateWidget(
      oldWidget,
    );

    if (oldWidget.videoId !=
        widget.videoId) {
      _videoInitialized = false;
      _isLeavingPage = false;

      WidgetsBinding.instance
          .addPostFrameCallback(
            (_) async {
          final provider =
          context.read<
              VideoDetailsFunctionProvider>();

          await provider.releaseVideo(
            notify: false,
            resetProgress: true,
          );

          if (!mounted) return;

          await _loadVideo();
        },
      );
    }
  }

  // =====================================================
  // Attachments
  // =====================================================

  String _cleanAttachmentName(
      dynamic originalName,
      int index,
      ) {
    String name =
        originalName
            ?.toString()
            .trim() ??
            '';

    if (name.isEmpty) {
      return 'ملف المحاضرة ${index + 1}';
    }

    name = name.replaceAll(
      RegExp(
        r'\.pdf$',
        caseSensitive: false,
      ),
      '',
    );

    name =
        name.replaceAll(
          '_',
          ' ',
        );

    name = name.replaceAll(
      RegExp(r'\s+'),
      ' ',
    );

    return name.trim();
  }

  void _openAttachment(
      dynamic attachment,
      ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            PdfViewerPage(
              pdfUrl:
              attachment.file,
              fileName:
              attachment
                  .originalName,
              title:
              widget.videoName,
            ),
      ),
    );
  }

  void _showAttachmentsBottomSheet(
      List<dynamic> attachments,
      ) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor:
      Colors.transparent,
      isScrollControlled: true,
      builder:
          (bottomSheetContext) {
        return Directionality(
          textDirection:
          TextDirection.rtl,
          child: Container(
            constraints:
            BoxConstraints(
              maxHeight:
              MediaQuery.sizeOf(
                context,
              ).height *
                  0.65,
            ),
            padding:
            EdgeInsets.fromLTRB(
              18,
              14,
              18,
              MediaQuery.paddingOf(
                context,
              ).bottom +
                  18,
            ),
            decoration:
            const BoxDecoration(
              color: Colors.white,
              borderRadius:
              BorderRadius.vertical(
                top:
                Radius.circular(
                  28,
                ),
              ),
            ),
            child: Column(
              mainAxisSize:
              MainAxisSize.min,
              children: [
                Container(
                  width: 48,
                  height: 5,
                  decoration:
                  BoxDecoration(
                    color:
                    const Color(
                      0xffD9E7E5,
                    ),
                    borderRadius:
                    BorderRadius
                        .circular(
                      10,
                    ),
                  ),
                ),

                const SizedBox(
                  height: 18,
                ),

                Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration:
                      BoxDecoration(
                        color:
                        const Color(
                          0xff264653,
                        ).withValues(
                          alpha:
                          0.10,
                        ),
                        borderRadius:
                        BorderRadius
                            .circular(
                          14,
                        ),
                      ),
                      child:
                      const Icon(
                        Icons
                            .folder_copy_outlined,
                        color:
                        Color(
                          0xff264653,
                        ),
                        size: 25,
                      ),
                    ),

                    const SizedBox(
                      width: 12,
                    ),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                        children: [
                          const Text(
                            'اختر ملف المحاضرة',
                            style:
                            TextStyle(
                              fontFamily:
                              'Tajawal',
                              fontSize:
                              18,
                              fontWeight:
                              FontWeight
                                  .bold,
                              color:
                              Color(
                                0xff264653,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          Text(
                            'يوجد ${attachments.length} ملفات مرفقة',
                            style:
                            const TextStyle(
                              fontFamily:
                              'Tajawal',
                              fontSize:
                              12,
                              color:
                              Color(
                                0xff7B8B8A,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 18,
                ),

                Flexible(
                  child:
                  ListView.separated(
                    shrinkWrap: true,
                    physics:
                    const BouncingScrollPhysics(),
                    itemCount:
                    attachments.length,
                    separatorBuilder:
                        (_, __) =>
                    const SizedBox(
                      height: 10,
                    ),
                    itemBuilder:
                        (context, index) {
                      final attachment =
                      attachments[
                      index];

                      final String
                      fileName =
                      _cleanAttachmentName(
                        attachment
                            .originalName,
                        index,
                      );

                      return Material(
                        color:
                        const Color(
                          0xffF4FAF9,
                        ),
                        borderRadius:
                        BorderRadius
                            .circular(
                          16,
                        ),
                        child: InkWell(
                          borderRadius:
                          BorderRadius
                              .circular(
                            16,
                          ),
                          onTap: () {
                            Navigator.pop(
                              bottomSheetContext,
                            );

                            _openAttachment(
                              attachment,
                            );
                          },
                          child:
                          Container(
                            padding:
                            const EdgeInsets
                                .all(
                              13,
                            ),
                            decoration:
                            BoxDecoration(
                              borderRadius:
                              BorderRadius
                                  .circular(
                                16,
                              ),
                              border:
                              Border.all(
                                color:
                                const Color(
                                  0xffDDEDEA,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration:
                                  BoxDecoration(
                                    color:
                                    const Color(
                                      0xffE76F51,
                                    ).withValues(
                                      alpha:
                                      0.10,
                                    ),
                                    borderRadius:
                                    BorderRadius
                                        .circular(
                                      13,
                                    ),
                                  ),
                                  child:
                                  const Icon(
                                    Icons
                                        .picture_as_pdf_rounded,
                                    color:
                                    Color(
                                      0xffE76F51,
                                    ),
                                    size:
                                    27,
                                  ),
                                ),

                                const SizedBox(
                                  width: 12,
                                ),

                                Expanded(
                                  child:
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text(
                                        fileName,
                                        maxLines:
                                        1,
                                        overflow:
                                        TextOverflow
                                            .ellipsis,
                                        style:
                                        const TextStyle(
                                          fontFamily:
                                          'Tajawal',
                                          fontSize:
                                          14,
                                          fontWeight:
                                          FontWeight
                                              .bold,
                                          color:
                                          Color(
                                            0xff264653,
                                          ),
                                        ),
                                      ),

                                      const SizedBox(
                                        height:
                                        5,
                                      ),

                                      Text(
                                        'PDF • ملف ${index + 1}',
                                        style:
                                        const TextStyle(
                                          fontFamily:
                                          'Tajawal',
                                          fontSize:
                                          11,
                                          color:
                                          Color(
                                            0xff7B8B8A,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(
                                  width: 8,
                                ),

                                Container(
                                  width: 38,
                                  height: 38,
                                  decoration:
                                  BoxDecoration(
                                    color:
                                    const Color(
                                      0xff2A9D8F,
                                    ).withValues(
                                      alpha:
                                      0.10,
                                    ),
                                    borderRadius:
                                    BorderRadius
                                        .circular(
                                      11,
                                    ),
                                  ),
                                  child:
                                  const Icon(
                                    Icons
                                        .visibility_outlined,
                                    color:
                                    Color(
                                      0xff2A9D8F,
                                    ),
                                    size:
                                    20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // =====================================================
  // Exit
  // =====================================================

  void _exitVideoPage() {
    if (_isLeavingPage) {
      return;
    }

    _isLeavingPage = true;

    final videoFunctionProvider =
    context.read<
        VideoDetailsFunctionProvider>();

    final progressProvider =
    context.read<
        VideoProgressProvider>();

    final VideoProgressSnapshot
    snapshot =
        videoFunctionProvider
            .progressSnapshot;

    final int currentVideoId =
        widget.videoId;

    final int currentPlaylistId =
        widget.playlistId;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
            DisplayVideosPage(
              id: currentPlaylistId,
            ),
      ),
    );

    unawaited(
      progressProvider
          .saveProgressSnapshot(
        videoId:
        currentVideoId,
        snapshot: snapshot,
      )
          .then((saved) {
        if (!saved) {
          debugPrint(
            'Progress was not saved: '
                '${progressProvider.errorMessage}',
          );
        }
      }),
    );
  }

  // =====================================================
  // Dispose
  // =====================================================

  @override
  void dispose() {
    _videoFunctionProvider
        ?.releaseVideo(
      notify: false,
      resetProgress: true,
    );

    super.dispose();
  }

  // =====================================================
  // Build
  // =====================================================

  @override
  Widget build(
      BuildContext context,
      ) {
    final AddVideoToFavProvider
    favProvider =
    context.watch<
        AddVideoToFavProvider>();

    final VideoDetailsProvider
    detailsProvider =
    context.watch<
        VideoDetailsProvider>();

    final VideoDetailsFunctionProvider
    functionProvider =
    context.watch<
        VideoDetailsFunctionProvider>();

    final details =
        detailsProvider.videoDetails;

    final String? videoUrl =
        details?.videoFile;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult:
          (didPop, result) {
        if (didPop) {
          return;
        }

        _exitVideoPage();
      },
      child: Scaffold(
        backgroundColor:
        Colors.white,

        floatingActionButton:
        FloatingActionButton
            .extended(
          onPressed:
          favProvider.isLoading
              ? null
              : () async {
            await context
                .read<
                AddVideoToFavProvider>()
                .addVidToFav(
              id: widget
                  .videoId,
            );

            if (!mounted) {
              return;
            }

            if (favProvider
                .isSuccess) {
              setState(() {
                isFavorite =
                !isFavorite;
              });

              ScaffoldMessenger
                  .of(
                context,
              ).showSnackBar(
                SnackBar(
                  content: Text(
                    isFavorite
                        ? 'تمت إضافة الفيديو إلى المفضلة'
                        : 'تمت إزالة الفيديو من المفضلة',
                    style:
                    const TextStyle(
                      fontFamily:
                      'Tajawal',
                    ),
                  ),
                  backgroundColor:
                  const Color(
                    0xff2A9D8F,
                  ),
                ),
              );
            } else {
              ScaffoldMessenger
                  .of(
                context,
              ).showSnackBar(
                SnackBar(
                  content: Text(
                    favProvider
                        .errorMessage ??
                        'حدث خطأ',
                    style:
                    const TextStyle(
                      fontFamily:
                      'Tajawal',
                    ),
                  ),
                  backgroundColor:
                  Colors.red,
                ),
              );
            }
          },

          elevation:
          isFavorite ? 2 : 8,

          backgroundColor:
          isFavorite
              ? const Color(
            0xff1F7A6D,
          )
              : const Color(
            0xff2A9D8F,
          ),

          shape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(
              18,
            ),
          ),

          icon:
          favProvider.isLoading
              ? const SizedBox(
            width: 22,
            height: 22,
            child:
            CircularProgressIndicator(
              strokeWidth:
              2,
              color:
              Colors.white,
            ),
          )
              : AnimatedSwitcher(
            duration:
            const Duration(
              milliseconds:
              250,
            ),
            child: Icon(
              isFavorite
                  ? Icons
                  .favorite_rounded
                  : Icons
                  .favorite_border_rounded,
              key: ValueKey(
                isFavorite,
              ),
              color:
              Colors.white,
              size: 24,
            ),
          ),

          label: Text(
            isFavorite
                ? 'تمت الإضافة'
                : 'إضافة للمفضلة',
            style:
            const TextStyle(
              fontFamily: 'Tajawal',
              fontWeight:
              FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),

        floatingActionButtonLocation:
        FloatingActionButtonLocation
            .centerFloat,

        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  if (detailsProvider
                      .isLoading &&
                      !_videoInitialized)
                    const AspectRatio(
                      aspectRatio:
                      16 / 9,
                      child:
                      ColoredBox(
                        color:
                        Colors.black,
                        child: Center(
                          child:
                          CircularProgressIndicator(
                            color:
                            Color(
                              0xffE9C46A,
                            ),
                          ),
                        ),
                      ),
                    )
                  else
                    VideoPlayerSection(
                      apiVideoUrl:
                      videoUrl,
                    ),

                  const SizedBox(
                    height: 10,
                  ),

                  const VideoWatchProgress(),

                  // =============================
                  // Attachments
                  // =============================

                  if (details != null &&
                      details.attachments
                          .isNotEmpty)
                    OptionCart(
                      title: details
                          .attachments
                          .length ==
                          1
                          ? 'ملف المحاضرة'
                          : 'ملفات المحاضرة',

                      subtitle: details
                          .attachments
                          .length ==
                          1
                          ? 'تصفح الملف المرفق مع هذا الدرس'
                          : 'يوجد ${details.attachments.length} ملفات مرفقة، اختر الملف الذي تريد عرضه',

                      buttonText: details
                          .attachments
                          .length ==
                          1
                          ? 'عرض الملف'
                          : 'اختيار ملف',

                      color:
                      const Color(
                        0xff264653,
                      ),

                      onPressed: () {
                        if (details
                            .attachments
                            .length ==
                            1) {
                          _openAttachment(
                            details
                                .attachments
                                .first,
                          );
                        } else {
                          _showAttachmentsBottomSheet(
                            details
                                .attachments,
                          );
                        }
                      },

                      child:
                      const Icon(
                        Icons
                            .file_copy_outlined,
                        size: 25,
                        color:
                        Color(
                          0xff264653,
                        ),
                      ),
                    ),

                  // =============================
                  // Summary
                  // =============================

                  OptionCart(
                    title:
                    'تلخيص الفيديو',
                    subtitle:
                    'احصل على ملخص مولد بالذكاء الاصطناعي لهذا الدرس',
                    buttonText:
                    'عرض الملخص',
                    color:
                    const Color(
                      0xff2A9D8F,
                    ),
                    onPressed: () {
                      //if (!functionProvider
                      //   .canAccessFeatures()) {
                      //LockedDialog.show(
                      // context,
                      //);

                      //  return;
                      //}

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              SummaryPage(
                                playlistId:
                                widget
                                    .playlistId,
                                id: widget
                                    .videoId,
                                name: widget
                                    .videoName,
                              ),
                        ),
                      );
                    },
                    child: Image.asset(
                      'assets/Images/SVGRepo_iconCarrier.png',
                      width: 20,
                      height: 20,
                    ),
                  ),

                  // =============================
                  // MCQ
                  // =============================

                  OptionCart(
                    title:
                    'اختبار أسئلة متعددة',
                    subtitle:
                    'اختبر فهمك للدرس عن طريق أسئلة اختيار من متعدد.',
                    buttonText:
                    'عرض الاختبار',
                    color:
                    const Color(
                      0xffE76F51,
                    ),
                    onPressed: () {
                      //if (!functionProvider
                       //   .canAccessFeatures()) {
                        //LockedDialog.show(
                         // context,
                        //);

                      //  return;
                      //}
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              McqScreen(
                                playlistId:
                                widget
                                    .playlistId,
                                videoId:
                                widget
                                    .videoId,
                                videoName:
                                widget
                                    .videoName,
                              ),
                        ),
                      );
                    },
                    child: Image.asset(
                      'assets/Images/SVGRepo_iconCarrier (1).png',
                      width: 20,
                      height: 20,
                    ),
                  ),

                  // =============================
                  // Chat
                  // =============================

                  OptionCart(
                    title:
                    'لديك أسئلة',
                    subtitle:
                    'اسأل أي سؤال عن محتويات الفيديو',
                    buttonText:
                    'اسأل الآن',
                    color:
                    const Color(
                      0xffE9C46A,
                    ),
                    onPressed: () async {
                      debugPrint(
                        '========== ASK NOW ==========',
                      );

                      debugPrint(
                        'videoId = ${widget.videoId}',
                      );

                      final viewProvider =
                      context.read<ViewChatProvider>();

                      await viewProvider.getChat(
                        videoId: widget.videoId,
                      );

                      if (!context.mounted) return;

                      if (viewProvider.errorMessage != null) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          SnackBar(
                            content: Text(
                              viewProvider.errorMessage!,
                            ),
                          ),
                        );

                        return;
                      }

                      final chat =
                          viewProvider.chat;

                      if (chat == null) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          const SnackBar(
                            content: Text(
                              'تعذر إنشاء أو تحميل المحادثة',
                            ),
                          ),
                        );

                        return;
                      }

                      final int chatId =
                          chat.id;

                      debugPrint(
                        'CHAT ID = $chatId',
                      );

                      debugPrint(
                        'MESSAGES COUNT = ${chat.messages.length}',
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return ChatPage(
                              id: widget.videoId,
                              chatId: chatId,

                              // مهم
                              initialChat: chat,

                              name: widget.videoName,
                              playlistId:
                              widget.playlistId,
                            );
                          },
                        ),
                      );
                    },
                    child: Image.asset(
                      'assets/Images/SVGRepo_iconCarrier (2).png',
                      width: 20,
                      height: 20,
                    ),
                  ),

                  const SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ),

            // =============================
            // Back
            // =============================

            Align(
              alignment:
              Alignment.topRight,
              child: SafeArea(
                child: Padding(
                  padding:
                  const EdgeInsets
                      .only(
                    top: 10,
                    right: 12,
                  ),
                  child: IconButton(
                    onPressed:
                    _isLeavingPage
                        ? null
                        : _exitVideoPage,
                    icon:
                    const Icon(
                      Icons
                          .chevron_right,
                      color:
                      Color(
                        0xffE9C46A,
                      ),
                      size: 30,
                    ),
                  ),
                ),
              ),
            ),

            Align(
              alignment:
              Alignment.topLeft,
              child: SafeArea(
                child: Padding(
                  padding:
                  const EdgeInsets
                      .only(
                    top: 5,
                    left: 10,
                  ),
                  child: IconButton(
                    onPressed:
                    details == null
                        ? null
                        : () {
                     Navigator.push(context, MaterialPageRoute(builder: (context){return VideoInfoPage(video: details,);}));
                    },
                    icon: Icon(
                      Icons
                          .info_outline,
                      color:
                      details == null
                          ? Colors
                          .grey
                          : const Color(
                        0xffE9C46A,
                      ),
                      size: 20,
                    ),
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