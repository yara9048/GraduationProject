import 'package:flutter/material.dart';
import 'package:graduationprojct/features/home/ui/pages/chat_page.dart';
import 'package:graduationprojct/features/home/ui/pages/summary_page.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'dart:async';
import '../../data/models/video_details_model.dart';
import '../../providers/add_video_to_fav_provider.dart';
import '../../providers/video_details_function_provider.dart';
import '../../providers/video_details_provider.dart';
import '../widgets/lock_dialog_widget.dart';
import '../widgets/option_cart.dart';
import 'mcq_page.dart';

class VideoDetailsPage extends StatefulWidget {
  final int videoId;
  const VideoDetailsPage({super.key, required this.videoId});

  @override
  State<VideoDetailsPage> createState() => _VideoDetailsPageState();
}

class _VideoDetailsPageState extends State<VideoDetailsPage> {
  late VideoPlayerController videoPlayerController;
  ChewieController? chewieController;

  late final provider =
  Provider.of<VideoDetailsFunctionProvider>(context);
  Timer? progressTimer;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VideoDetailsProvider>().getDetails(id: widget.videoId);
    });
    videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      ),
    );

    videoPlayerController.initialize().then((_) {
      chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        autoPlay: false,
        looping: false,
        materialProgressColors: ChewieProgressColors(
          playedColor: const Color(0xffE9C46A),
          handleColor: const Color(0xffE9C46A),
          bufferedColor: Colors.grey,
          backgroundColor: Colors.white24,
        ),
      );

      progressTimer = Timer.periodic(
        const Duration(milliseconds: 300),
            (timer) {
          if (!mounted) return;

          if (!videoPlayerController.value.isInitialized) return;

          final duration = videoPlayerController.value.duration.inMilliseconds;
          final position = videoPlayerController.value.position.inMilliseconds;
          if (duration <= 0) return;
          double progress = position / duration;
          progress = (progress * 10).floor() / 10;
          if (position >= duration) {
            progress = 1.0;
          }
          if (progress != provider.watchProgress) {
            setState(() {
              provider.updateProgress(progress);
            });
          }
        },
      );
      setState(() {});
    }).catchError((e) {
      debugPrint("VIDEO ERROR: $e");
    });
  }

  @override
  void dispose() {
    progressTimer?.cancel();
    chewieController?.dispose();
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final favProvider = context.watch<AddVideoToFavProvider>();
    final Myprovider = context.watch<VideoDetailsProvider>();
    final details = Myprovider.videoDetails;

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: favProvider.isLoading
            ? null
            : () async {
          await context.read<AddVideoToFavProvider>().addVidToFav(
            id: widget.videoId,
          );

          if (!mounted) return;

          if (favProvider.isSuccess) {
            setState(() {
              isFavorite = !isFavorite;
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  isFavorite
                      ? "تمت إضافة الفيديو إلى المفضلة"
                      : "تمت إزالة الفيديو من المفضلة",
                ),
                backgroundColor: const Color(0xff2A9D8F),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  favProvider.errorMessage ?? "حدث خطأ",
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        elevation: isFavorite ? 2 : 8,
        backgroundColor: isFavorite
            ? const Color(0xff1F7A6D)
            : const Color(0xff2A9D8F),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        icon: favProvider.isLoading
            ? const SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        )
            : AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: Icon(
            isFavorite
                ? Icons.favorite_rounded
                : Icons.favorite_border_rounded,
            key: ValueKey(isFavorite),
            color: Colors.white,
            size: 24,
          ),
        ),
        label: Text(
          isFavorite ? "تمت الإضافة" : "إضافة للمفضلة",
          style: const TextStyle(
            fontFamily: "Tajawal",
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: chewieController == null
                      ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xffE9C46A),
                    ),
                  )
                      : Chewie(
                    controller: chewieController!,
                  ),
                ),

                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${(provider.watchProgress * 100).toInt()}%",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xffE9C46A),
                            ),
                          ),
                          Text(
                            provider.watchProgress == 1
                                ? "تمت مشاهدة: كامل الفيديو"
                                : "تمت مشاهدة : %${(provider.watchProgress *
                                100).toInt()}",
                            style: const TextStyle(
                              fontSize: 15,
                              fontFamily: "Tajawal",
                              fontWeight: FontWeight.bold,
                              color: Color(0xff1A2429),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: provider.watchProgress,
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(20),
                        color: const Color(0xffE9C46A),
                        backgroundColor: Colors.grey.shade300,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                OptionCart(
                  title: "تلخيص الفيديو",
                  image: "assets/Images/SVGRepo_iconCarrier.png",
                  subtitle:
                  "احصل على ملخص مولد بالذكاء الاصطناعي لهذا الدرس",
                  buttonText: "عرض الملخص",
                  color: const Color(0xff2A9D8F),
                  onPressed: () {
                    if (provider.watchProgress < 1.0) {
                      LockedDialog.show(context);
                      return;
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SummaryPage(),
                      ),
                    );
                  },
                ),

                OptionCart(
                  title: "اختبار أسئلة متعددة",
                  image: "assets/Images/SVGRepo_iconCarrier (1).png",
                  subtitle:
                  "اختبر فهمك للدرس عن طريق أسئلة اختيار من متعدد.",
                  buttonText: "عرض الاختبار",
                  color: const Color(0xffE76F51),
                  onPressed: () {
                    if (provider.watchProgress < 1.0) {
                      LockedDialog.show(context);
                      return;
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => McqScreen(),
                      ),
                    );
                  },
                ),

                OptionCart(
                  title: "لديك أسئلة",
                  image: "assets/Images/SVGRepo_iconCarrier (2).png",
                  subtitle: "اسأل أي سؤال عن محتويات الفيديو",
                  buttonText: "اسأل الآن",
                  color: const Color(0xffE9C46A),
                  onPressed: () {
                    if (provider.watchProgress < 1.0) {
                      LockedDialog.show(context);
                      return;
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatPage(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),

          Align(
            alignment: Alignment.topRight,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 10, right: 12),
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.chevron_right,
                    color: Color(0xffE9C46A),
                    size: 40,
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 5,left: 10),
                child: IconButton(
                  onPressed: () {
                    showVideoInfoDialog(context, details!);
                      },
                  icon: const Icon(
                    Icons.info_outline,
                    color: Color(0xffE9C46A),
                    size: 30,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  void showVideoInfoDialog(
      BuildContext context,
      VideoDetailsModel video,
      ) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 130,
                    height: 65,
                    decoration: const BoxDecoration(
                      color: Color(0xff2A9D8F),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.info_outline_rounded,
                      color: Colors.white,
                      size: 34,
                    ),
                  ),

                  const SizedBox(height: 18),

                  Text(
                    video.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: "Tajawal",
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff264653),
                    ),
                  ),

                  const SizedBox(height: 18),

                  _descriptionCard(video.description),

                  const SizedBox(height: 14),
                  _infoRow(
                    Icons.access_time_rounded,
                    "المدة",
                    "${video.duration} دقيقة",
                  ),

                  _infoRow(
                    Icons.visibility_outlined,
                    "المشاهدات",
                    "${video.views}",
                  ),

                  _infoRow(
                    Icons.check_circle_outline,
                    "الحالة",
                    video.status,
                    valueColor: const Color(0xff2A9D8F),
                  ),

                  _infoRow(
                    Icons.quiz_outlined,
                    "عدد الأسئلة",
                    "${video.mcqCount}",
                  ),

                  const SizedBox(height: 12),

                  if (video.transcript.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xffF5F7F8),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        video.transcript,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontFamily: "Tajawal",
                          fontSize: 14,
                          height: 1.6,
                        ),
                      ),
                    ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff2A9D8F),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          "إغلاق",
                          style: TextStyle(
                            fontFamily: "Tajawal",
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        );
      },
    );
  }
  Widget _descriptionCard(String description) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xffF7F7F7),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xffE9C46A).withOpacity(.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(
                Icons.description_outlined,
                color: Color(0xffE9C46A),
                size: 22,
              ),
              SizedBox(width: 8),
              Text(
                "الوصف",
                style: TextStyle(
                  fontFamily: "Tajawal",
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Color(0xff264653),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Text(
            description,
            textAlign: TextAlign.right,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: "Tajawal",
              fontSize: 14,
              height: 1.6,
              color: Color(0xff264653),
            ),
          ),
        ],
      ),
    );
  }
  Widget _infoRow(
      IconData icon,
      String title,
      String value, {
        Color valueColor = const Color(0xff264653),
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xffE9C46A),
            size: 22,
          ),
          const SizedBox(width: 10),
          Text(
            "$title :",
            style: const TextStyle(
              fontFamily: "Tajawal",
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Color(0xff264653),
            ),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontFamily: "Tajawal",
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
