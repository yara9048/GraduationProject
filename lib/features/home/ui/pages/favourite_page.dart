import 'package:flutter/material.dart';
import 'package:graduationprojct/features/home/providers/display_videos_provider.dart';
import 'package:graduationprojct/features/home/ui/pages/video_details_page.dart';
import 'package:provider/provider.dart';

import '../../providers/display_facourite_provider.dart';
import '../widgets/course_card_template.dart';
import '../widgets/video_card_template.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({super.key});

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DisplayFavouriteProvider>().getFavourites();
    });
  }
  Widget build(BuildContext context) {
    final provider = context.watch<DisplayFavouriteProvider>();

      final favouriteVideos = provider.favourites
          .where((e) => e.videoDetail != null)
          .toList();

      final favouritePlaylists = provider.favourites
          .where((e) => e.playlistDetail != null)
          .toList();


    if (provider.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            strokeWidth: 3,
            color: Color(0xff2A9D8F),
          ),
        ),
      );
    }

    if (provider.errorMessage != null) {
      return Scaffold(
        body: Center(
          child: Text(provider.errorMessage!),
        ),
      );
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
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

            Positioned(
              top: 55,
              right: 16,
              left: 16,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      textDirection: TextDirection.rtl,
                      color: Color(0xff2A9D8F),
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "المفضلة",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xff2A9D8F),
                      fontFamily: "Tajawal",
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),

            Positioned.fill(
              top: 120,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "الفيديوهات المفضلة",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Tajawal",
                        color: Color(0xff264653),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  SizedBox(
                    height: 280,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      reverse: true,
                      itemCount: favouriteVideos.length,
                      separatorBuilder: (_, __) =>
                      const SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        final video = favouriteVideos[index];

                        return SizedBox(
                          width: 300,
                          child: VideoCardTemplate(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (Context){return VideoDetailsPage(videoId: video.id,);}));
                            },                            imagePath: "assets/Images/photo_2026-07-23_00-20-19.jpg",
                            title: video.videoDetail!.title,
                            description: video.videoDetail!.description,
                            duration:
                            "${video.videoDetail!.duration} دقيقة",
                            views: video.videoDetail!.views,
                            status: video.videoDetail!.status,
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// كورسات
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "قوائم التشغيل المفضلة",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Tajawal",
                        color: Color(0xff264653),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  ListView.separated(
                    itemCount: favouritePlaylists.length,
                    shrinkWrap: true,
                    physics:
                    const NeverScrollableScrollPhysics(),
                    separatorBuilder: (_, __) =>
                    const SizedBox(height: 18),
                    itemBuilder: (context, index) {
                      final playlist = favouritePlaylists[index];

                      return CourseCardTemplate(
                        playlistId: playlist.playlistDetail!.id,
                        imagePath: 'assets/Images/Gemini_Generated_Image_hy81hehy81hehy81 1.png',
                        title: playlist.playlistDetail!.name,
                        description:
                        playlist.playlistDetail!.description,
                        durationText:
                        "${playlist.playlistDetail!.totalDuration} دقيقة",
                        progress:
                        playlist.playlistDetail!.completionRate /
                            100,
                      );
                    },
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}
