import 'package:flutter/material.dart';
import 'package:graduationprojct/features/home/ui/pages/subject_search_page.dart';
import 'package:graduationprojct/features/home/ui/pages/video_details_page.dart';
import 'package:provider/provider.dart';

import '../../providers/display_facourite_provider.dart';
import '../widgets/course_card_template.dart';
import '../widgets/video_card_template.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({super.key});

  @override
  State<FavouritePage> createState() =>
      _FavouritePageState();
}

class _FavouritePageState
    extends State<FavouritePage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context
          .read<DisplayFavouriteProvider>()
          .getFavourites();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider =
    context.watch<DisplayFavouriteProvider>();

    final favouriteVideos = provider.favourites
        .where((item) => item.videoDetail != null)
        .toList();

    final favouritePlaylists = provider.favourites
        .where((item) => item.playlistDetail != null)
        .toList();

    if (provider.isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
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
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  provider.errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.red,
                    fontFamily: 'Tajawal',
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    provider.getFavourites();
                  },
                  child: const Text(
                    'إعادة المحاولة',
                  ),
                ),
              ],
            ),
          ),
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

            const Positioned(
              top: 55,
              right: 16,
              left: 16,
              child: Text(
                'المفضلة',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xff2A9D8F),
                  fontFamily: 'Tajawal',
                  fontSize: 20,
                ),
              ),
            ),

            Positioned.fill(
              top: 110,
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                children: [
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'الفيديوهات المفضلة',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Tajawal',
                        color: Color(0xff264653),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  if (favouriteVideos.isEmpty)
                    const SizedBox(
                      height: 160,
                      child: Center(
                        child: Text(
                          'لا توجد فيديوهات مفضلة',
                          style: TextStyle(
                            color: Colors.grey,
                            fontFamily: 'Tajawal',
                            fontSize: 15,
                          ),
                        ),
                      ),
                    )
                  else
                    SizedBox(
                      height: 190,
                      child: ListView.separated(
                        scrollDirection:
                        Axis.horizontal,
                        itemCount:
                        favouriteVideos.length,
                        separatorBuilder:
                            (_, __) =>
                        const SizedBox(
                          width: 16,
                        ),
                        itemBuilder:
                            (context, index) {
                          final favouriteItem =
                          favouriteVideos[index];

                          final video =
                          favouriteItem
                              .videoDetail!;

                          return SizedBox(
                            width: 200,
                            child: Align(
                              alignment: Alignment.topRight,
                              child: VideoCardTemplate(
                                key: ValueKey(video.id),
                                videoId: video.id,
                                onTap: () {
                                  final playlistId =
                                      favouriteItem
                                          .playlistDetail
                                          ?.id;

                                  if (playlistId ==
                                      null) {
                                    ScaffoldMessenger
                                        .of(context)
                                        .showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'لا يوجد رقم قائمة تشغيل لهذا الفيديو',
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) {
                                        return VideoDetailsPage(
                                          videoId:
                                          video.id,
                                          playlistId:
                                          playlistId,
                                          videoName:
                                          video.title,
                                        );
                                      },
                                    ),
                                  );
                                },
                                imagePath:
                                'assets/Images/photo_2026-07-23_00-20-19.jpg',
                                title: video.title,
                                description:
                                video.description,
                                duration:
                                '${video.duration} دقيقة',
                                views: video.views,
                                status: video.status,
                                onRemovedFromFavourite:
                                    () async {
                                  await context
                                      .read<
                                      DisplayFavouriteProvider>()
                                      .getFavourites();
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                  const SizedBox(height: 30),

                  const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'قوائم التشغيل المفضلة',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Tajawal',
                        color: Color(0xff264653),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  if (favouritePlaylists.isEmpty)
                    const SizedBox(
                      height: 160,
                      child: Center(
                        child: Text(
                          'لا توجد قوائم تشغيل مفضلة',
                          style: TextStyle(
                            color: Colors.grey,
                            fontFamily: 'Tajawal',
                            fontSize: 15,
                          ),
                        ),
                      ),
                    )
                  else
                    SizedBox(
                      // ضروري لأن القائمة أفقية
                      height: 260,
                      child: ListView.separated(
                        scrollDirection:
                        Axis.horizontal,
                        itemCount:
                        favouritePlaylists
                            .length,
                        separatorBuilder:
                            (_, __) =>
                        const SizedBox(
                          width: 16,
                        ),
                        itemBuilder:
                            (context, index) {
                          final favouriteItem =
                          favouritePlaylists[
                          index];

                          final playlist =
                          favouriteItem
                              .playlistDetail!;

                          final completionRate =
                              playlist
                                  .completionRate;

                          final progress =
                          (completionRate /
                              100)
                              .clamp(
                            0.0,
                            1.0,
                          );

                          return SizedBox(
                            width: 300,
                            child:
                            CourseCardTemplate(
                              key: ValueKey(
                                playlist.id,
                              ),
                              playlistId:
                              playlist.id,
                              imagePath:
                              'assets/Images/Gemini_Generated_Image_hy81hehy81hehy81 1.png',
                              title:
                              playlist.name,
                              description:
                              playlist
                                  .description,
                              durationText:
                              '${playlist.totalDuration ?? 0} دقيقة',
                              progress: progress,
                              onRemovedFromFavourite:
                                  () async {
                                await context
                                    .read<
                                    DisplayFavouriteProvider>()
                                    .getFavourites();
                              },
                            ),
                          );
                        },
                      ),
                    ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}