import 'package:flutter/material.dart';
import 'package:graduationprojct/features/home/ui/pages/chat_page.dart';
import 'package:graduationprojct/features/home/ui/pages/summary_page.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'dart:async';
import '../../providers/video_details_provider.dart';
import '../widgets/lock_dialog_widget.dart';
import '../widgets/option_cart.dart';
import 'mcq_page.dart';

class VideoDetailsPage extends StatefulWidget {
  const VideoDetailsPage({super.key});

  @override
  State<VideoDetailsPage> createState() => _VideoDetailsPageState();
}

class _VideoDetailsPageState extends State<VideoDetailsPage> {
  late VideoPlayerController videoPlayerController;
  ChewieController? chewieController;

  late final provider =
  Provider.of<VideoDetailsProvider>(context);
  Timer? progressTimer;

  @override
  void initState() {
    super.initState();

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
    return Scaffold(
      backgroundColor: Colors.white,
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
        ],
      ),
    );
  }
}
