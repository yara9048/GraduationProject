import 'package:flutter/material.dart';
import 'package:graduationprojct/features/home/ui/pages/chat_page.dart';
import 'package:graduationprojct/features/home/ui/pages/display_videos_page.dart';
import 'package:graduationprojct/features/home/ui/pages/summary_page.dart';
import 'package:provider/provider.dart';

import '../../providers/add_video_to_fav_provider.dart';
import '../../providers/video_details_function_provider.dart';
import '../../providers/video_details_provider.dart';
import '../widgets/lock_dialog_template.dart';
import '../widgets/option_cart_template.dart';
import '../widgets/video_info_dialog_template.dart';
import '../widgets/video_player_section.dart' hide VideoDetailsFunctionProvider;
import 'mcq_page.dart';

class VideoDetailsPage extends StatefulWidget {
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
  State<VideoDetailsPage> createState() =>
      _VideoDetailsPageState();
}

class _VideoDetailsPageState
    extends State<VideoDetailsPage> {
  bool isFavorite = false;
  bool _videoInitialized = false;

  VideoDetailsFunctionProvider?
  _videoFunctionProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _videoFunctionProvider ??=
        context.read<
            VideoDetailsFunctionProvider>();
  }

  @override
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
          (_) async {
        if (!mounted) return;

        final detailsProvider =
        context.read<
            VideoDetailsProvider>();

        final videoFunctionProvider =
        context.read<
            VideoDetailsFunctionProvider>();

        await detailsProvider.getDetails(
          id: widget.videoId,
        );

        if (!mounted) return;

        final details =
            detailsProvider.videoDetails;

        final String? videoUrl =
            details?.videoFile;

        final Object? durationSeconds =
            details?.duration;

        await videoFunctionProvider
            .initializeVideo(
          videoUrl,
          durationSeconds:
          durationSeconds,
        );

        if (!mounted) return;

        setState(() {
          _videoInitialized = true;
        });
      },
    );
  }

  @override
  void didUpdateWidget(
      covariant VideoDetailsPage oldWidget,
      ) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.videoId !=
        widget.videoId) {
      _videoInitialized = false;

      WidgetsBinding.instance
          .addPostFrameCallback(
            (_) async {
          if (!mounted) return;

          final videoFunctionProvider =
          context.read<
              VideoDetailsFunctionProvider>();

          final detailsProvider =
          context.read<
              VideoDetailsProvider>();

          await videoFunctionProvider
              .releaseVideo(
            notify: false,
            resetProgress: true,
          );

          if (!mounted) return;

          await detailsProvider.getDetails(
            id: widget.videoId,
          );

          if (!mounted) return;

          final details =
              detailsProvider.videoDetails;

          final String? videoUrl =
              details?.videoFile;

          final Object? durationSeconds =
              details?.duration;

          await videoFunctionProvider
              .initializeVideo(
            videoUrl,
            durationSeconds:
            durationSeconds,
          );

          if (!mounted) return;

          setState(() {
            _videoInitialized = true;
          });
        },
      );
    }
  }

  @override
  void dispose() {
    _videoFunctionProvider?.releaseVideo(
      notify: false,
      resetProgress: true,
    );

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AddVideoToFavProvider favProvider =
    context.watch<AddVideoToFavProvider>();

    final VideoDetailsProvider
    detailsProvider =
    context.watch<VideoDetailsProvider>();

    final VideoDetailsFunctionProvider
    functionProvider =
    context.watch<
        VideoDetailsFunctionProvider>();

    final details =
        detailsProvider.videoDetails;

    final String? videoUrl =
        details?.videoFile;

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton:
      FloatingActionButton.extended(
        onPressed: favProvider.isLoading
            ? null
            : () async {
          await context
              .read<
              AddVideoToFavProvider>()
              .addVidToFav(
            id: widget.videoId,
          );

          if (!mounted) return;

          if (favProvider.isSuccess) {
            setState(() {
              isFavorite = !isFavorite;
            });

            ScaffoldMessenger.of(context)
                .showSnackBar(
              SnackBar(
                content: Text(
                  isFavorite
                      ? 'تمت إضافة الفيديو إلى المفضلة'
                      : 'تمت إزالة الفيديو من المفضلة',
                  style: const TextStyle(
                    fontFamily: 'Tajawal',
                  ),
                ),
                backgroundColor:
                const Color(
                  0xff2A9D8F,
                ),
              ),
            );
          } else {
            ScaffoldMessenger.of(context)
                .showSnackBar(
              SnackBar(
                content: Text(
                  favProvider.errorMessage ??
                      'حدث خطأ',
                  style: const TextStyle(
                    fontFamily: 'Tajawal',
                  ),
                ),
                backgroundColor:
                Colors.red,
              ),
            );
          }
        },
        elevation: isFavorite ? 2 : 8,
        backgroundColor: isFavorite
            ? const Color(0xff1F7A6D)
            : const Color(0xff2A9D8F),
        shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(18),
        ),
        icon: favProvider.isLoading
            ? const SizedBox(
          width: 22,
          height: 22,
          child:
          CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        )
            : AnimatedSwitcher(
          duration:
          const Duration(
            milliseconds: 250,
          ),
          child: Icon(
            isFavorite
                ? Icons.favorite_rounded
                : Icons
                .favorite_border_rounded,
            key: ValueKey(isFavorite),
            color: Colors.white,
            size: 24,
          ),
        ),
        label: Text(
          isFavorite
              ? 'تمت الإضافة'
              : 'إضافة للمفضلة',
          style: const TextStyle(
            fontFamily: 'Tajawal',
            fontWeight: FontWeight.bold,
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
                if (detailsProvider.isLoading &&
                    !_videoInitialized)
                  const AspectRatio(
                    aspectRatio: 16 / 9,
                    child: ColoredBox(
                      color: Colors.black,
                      child: Center(
                        child:
                        CircularProgressIndicator(
                          color: Color(
                            0xffE9C46A,
                          ),
                        ),
                      ),
                    ),
                  )
                else
                  VideoPlayerSection(
                    apiVideoUrl: videoUrl,
                  ),
                const SizedBox(height: 10),
                const VideoWatchProgress(),
                if (functionProvider
                    .isUsingFallbackVideo) ...[
                  const SizedBox(height: 8),
                  const Padding(
                    padding:
                    EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    child: Text(
                      'تعذر تشغيل فيديو السيرفر، لذلك يتم عرض الفيديو الاحتياطي.',
                      textAlign:
                      TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                OptionCart(
                  title: 'تلخيص الفيديو',
                  image:
                  'assets/Images/SVGRepo_iconCarrier.png',
                  subtitle:
                  'احصل على ملخص مولد بالذكاء الاصطناعي لهذا الدرس',
                  buttonText: 'عرض الملخص',
                  color:
                  const Color(0xff2A9D8F),
                  onPressed: () {
                    if (!functionProvider
                        .canAccessFeatures()) {
                      LockedDialog.show(
                        context,
                      );
                      return;
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            SummaryPage(
                              playlistId:
                              widget.playlistId,
                              id: widget.videoId,
                              name:
                              widget.videoName,
                            ),
                      ),
                    );
                  },
                ),
                OptionCart(
                  title:
                  'اختبار أسئلة متعددة',
                  image:
                  'assets/Images/SVGRepo_iconCarrier (1).png',
                  subtitle:
                  'اختبر فهمك للدرس عن طريق أسئلة اختيار من متعدد.',
                  buttonText: 'عرض الاختبار',
                  color:
                  const Color(0xffE76F51),
                  onPressed: () {
                    if (!functionProvider
                        .canAccessFeatures()) {
                      LockedDialog.show(
                        context,
                      );
                      return;
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            McqScreen(
                              playlistId:
                              widget.playlistId,
                              videoId:
                              widget.videoId,
                              videoName:
                              widget.videoName,
                            ),
                      ),
                    );
                  },
                ),
                OptionCart(
                  title: 'لديك أسئلة',
                  image:
                  'assets/Images/SVGRepo_iconCarrier (2).png',
                  subtitle:
                  'اسأل أي سؤال عن محتويات الفيديو',
                  buttonText: 'اسأل الآن',
                  color:
                  const Color(0xffE9C46A),
                  onPressed: () {
                    if (!functionProvider
                        .canAccessFeatures()) {
                      LockedDialog.show(
                        context,
                      );
                      return;
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ChatPage(
                              id: widget.videoId,
                              name:
                              widget.videoName,
                              playlistId:
                              widget.playlistId,
                            ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: SafeArea(
              child: Padding(
                padding:
                const EdgeInsets.only(
                  top: 10,
                  right: 12,
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            DisplayVideosPage(
                              id: widget.playlistId,
                            ),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.chevron_right,
                    color: Color(0xffE9C46A),
                    size: 30,
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: SafeArea(
              child: Padding(
                padding:
                const EdgeInsets.only(
                  top: 5,
                  left: 10,
                ),
                child: IconButton(
                  onPressed: details == null
                      ? null
                      : () {
                    showDialog<void>(
                      context: context,
                      builder: (_) =>
                          VideoInfoDialog(
                            video: details,
                          ),
                    );
                  },
                  icon: Icon(
                    Icons.info_outline,
                    color: details == null
                        ? Colors.grey
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
    );
  }
}