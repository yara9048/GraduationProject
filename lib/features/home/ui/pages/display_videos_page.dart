import 'package:flutter/material.dart';
import 'package:graduationprojct/features/home/providers/display_videos_provider.dart';
import 'package:graduationprojct/features/home/providers/playlist_details_provider.dart';
import 'package:graduationprojct/features/home/ui/pages/display_playlists_page.dart';
import 'package:graduationprojct/features/home/ui/pages/main_navigation_page.dart';
import 'package:graduationprojct/features/home/ui/pages/playlist_details_page.dart';
import 'package:graduationprojct/features/home/ui/pages/video_details_page.dart';
import 'package:provider/provider.dart';

import '../widgets/video_card_template.dart';

class DisplayVideosPage extends StatefulWidget {
  final int id;

  const DisplayVideosPage({
    super.key,
    required this.id,
  });

  @override
  State<DisplayVideosPage> createState() =>
      _DisplayVideosPageState();
}

class _DisplayVideosPageState extends State<DisplayVideosPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _loadPageData();
    });
  }

  @override
  void didUpdateWidget(covariant DisplayVideosPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    /*
     * في حال تم إعادة استخدام الصفحة مع id مختلف،
     * نعيد تحميل البيانات الخاصة بالـ Playlist الجديدة.
     */
    if (oldWidget.id != widget.id) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        _loadPageData();
      });
    }
  }

  Future<void> _loadPageData() async {
    await Future.wait([
      context.read<DisplayVideosProvider>().getVideos(
        id: widget.id,
      ),
      context.read<PlaylistDetailsProvider>().getDetails(
        id: widget.id,
        forceRefresh: true,
      ),
    ]);
  }

  Future<void> _openPlaylistDetails() async {
    final detailsProvider =
    context.read<PlaylistDetailsProvider>();

    final bool hasCorrectDetails =
        detailsProvider.loadedPlaylistId == widget.id &&
            detailsProvider.playListDetails != null;

    if (!hasCorrectDetails) {
      await detailsProvider.getDetails(
        id: widget.id,
        forceRefresh: true,
      );
    }

    if (!mounted) return;

    final course = detailsProvider.playListDetails;

    if (course == null ||
        detailsProvider.loadedPlaylistId != widget.id) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            detailsProvider.errorMessage ??
                'تعذر تحميل معلومات قائمة التشغيل',
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              fontFamily: 'Tajawal',
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );

      return;
    }

    final subscribed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
          builder: (_) => PlaylistDetailsPage(
          course: course,
          id: widget.id,
        ),
      ),
    );

    if (!mounted) return;

    if (subscribed == true) {
      await context
          .read<DisplayVideosProvider>()
          .getVideos(
        id: widget.id,
      );

      if (!mounted) return;

      await context
          .read<PlaylistDetailsProvider>()
          .getDetails(
        id: widget.id,
        forceRefresh: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final videosProvider =
    context.watch<DisplayVideosProvider>();

    final detailsProvider =
    context.watch<PlaylistDetailsProvider>();

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
            _buildHeader(),
            _buildInfoButton(detailsProvider),
            Positioned(
              top: 130,
              left: 16,
              right: 16,
              bottom: 16,
              child: _buildContent(videosProvider),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Positioned(
      top: 55,
      right: 16,
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context){return MainNavigationPage(initialIndex: 1,);}));
        },
        borderRadius: BorderRadius.circular(12),
        child: const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 8,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.arrow_back_ios_new_rounded,
                textDirection: TextDirection.rtl,
                color: Color(0xff2A9D8F),
                size: 20,
              ),
              SizedBox(width: 10),
              Text(
                'فيديوهات قائمة التشغيل',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xff2A9D8F),
                  fontFamily: 'Tajawal',
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoButton(
      PlaylistDetailsProvider detailsProvider,
      ) {
    /*
     * نعرض Loading فقط عندما يكون Provider
     * يحمل بيانات نفس الصفحة الحالية.
     */
    final bool loadingCurrentPlaylist =
        detailsProvider.isLoading;

    return Positioned(
      top: 48,
      left: 8,
      child: loadingCurrentPlaylist
          ? const Padding(
        padding: EdgeInsets.all(12),
        child: SizedBox(
          width: 27,
          height: 27,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            color: Color(0xff2A9D8F),
          ),
        ),
      )
          : IconButton(
        onPressed: _openPlaylistDetails,
        icon: Icon(
          Icons.info_outline,
          color:
          detailsProvider.loadedPlaylistId ==
              widget.id &&
              detailsProvider
                  .playListDetails !=
                  null
              ? const Color(0xff2A9D8F)
              : Colors.grey,
          size: 30,
        ),
      ),
    );
  }

  Widget _buildContent(
      DisplayVideosProvider provider,
      ) {
    if (provider.isLoading) {
      return const Center(
        child: SizedBox(
          width: 30,
          height: 30,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            color: Color(0xff2A9D8F),
          ),
        ),
      );
    }

    if (provider.errorMessage != null) {
      return _buildErrorState(provider);
    }

    if (provider.videos.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      color: const Color(0xff2A9D8F),
      onRefresh: () async {
        await Future.wait([
          context
              .read<DisplayVideosProvider>()
              .getVideos(
            id: widget.id,
          ),
          context
              .read<PlaylistDetailsProvider>()
              .getDetails(
            id: widget.id,
            forceRefresh: true,
          ),
        ]);
      },
      child: ListView.builder(
        physics:
        const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(
          top: 10,
          bottom: 30,
        ),
        itemCount: provider.videos.length,
        itemBuilder: (context, index) {
          final video = provider.videos[index];

          return Padding(
            padding:
            const EdgeInsets.only(bottom: 16),
            child: VideoCardTemplate(
              videoId: video.id,
              imagePath:
              'assets/Images/photo_2026-07-23_00-20-19.jpg',
              title: video.title,
              description: video.description,
              duration:
              video.duration?.toString() ?? '0',
              views: video.views,
              status: video.status,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        VideoDetailsPage(
                          videoId: video.id,
                          playlistId: video.playlist,
                          videoName: video.title,
                        ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorState(
      DisplayVideosProvider provider,
      ) {
    final errorMessage =
        provider.errorMessage ??
            'حدث خطأ غير معروف';

    final normalizedError =
    errorMessage.toLowerCase();

    final bool subscriptionRequired =
        provider.statusCode == 403 ||
            normalizedError.contains(
              'subscription',
            ) ||
            normalizedError.contains(
              'subscribe',
            ) ||
            normalizedError.contains(
              'active subscription',
            ) ||
            normalizedError.contains(
              'unlock this playlist',
            ) ||
            normalizedError.contains('اشتراك') ||
            normalizedError.contains('مشترك');

    return SingleChildScrollView(
      physics:
      const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(
        horizontal: 28,
        vertical: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 70),
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: subscriptionRequired
                  ? const Color(0xffE9C46A)
                  .withOpacity(0.15)
                  : Colors.red.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              subscriptionRequired
                  ? Icons.lock_outline_rounded
                  : Icons.error_outline_rounded,
              size: 52,
              color: subscriptionRequired
                  ? const Color(0xffE9C46A)
                  : Colors.red,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            subscriptionRequired
                ? 'المحتوى يحتاج إلى اشتراك'
                : 'تعذر تحميل الفيديوهات',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: Color(0xff264653),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            subscriptionRequired
                ? 'يجب أن يكون لديك اشتراك فعّال في قائمة التشغيل حتى تتمكن من مشاهدة الفيديوهات.'
                : _cleanErrorMessage(
              errorMessage,
            ),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 15,
              height: 1.6,
              color: Color(0xff6C7A7A),
            ),
          ),
          const SizedBox(height: 26),
          if (subscriptionRequired)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed:
                _openPlaylistDetails,
                icon: const Icon(
                  Icons.info_outline,
                  color: Colors.white,
                  size: 20,
                ),
                label: const Text(
                  'عرض معلومات القائمة والاشتراك',
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style:
                ElevatedButton.styleFrom(
                  backgroundColor:
                  const Color(0xff2A9D8F),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding:
                  const EdgeInsets.symmetric(
                    vertical: 14,
                  ),
                  shape:
                  RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          if (subscriptionRequired)
            const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                context
                    .read<
                    DisplayVideosProvider>()
                    .getVideos(
                  id: widget.id,
                );
              },
              icon: const Icon(
                Icons.refresh_rounded,
                color: Color(0xff2A9D8F),
              ),
              label: const Text(
                'إعادة المحاولة',
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff2A9D8F),
                ),
              ),
              style:
              OutlinedButton.styleFrom(
                padding:
                const EdgeInsets.symmetric(
                  vertical: 13,
                ),
                side: const BorderSide(
                  color: Color(0xff2A9D8F),
                ),
                shape:
                RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(14),
                ),
              ),
            ),
          ),
          if (!subscriptionRequired) ...[
            const SizedBox(height: 12),
            Text(
              _cleanErrorMessage(
                errorMessage,
              ),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return RefreshIndicator(
      color: const Color(0xff2A9D8F),
      onRefresh: () async {
        await context
            .read<DisplayVideosProvider>()
            .getVideos(
          id: widget.id,
        );
      },
      child: ListView(
        physics:
        const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height:
            MediaQuery.sizeOf(context).height *
                0.55,
            child: Center(
              child: Padding(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 30,
                ),
                child: Column(
                  mainAxisSize:
                  MainAxisSize.min,
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: const Color(
                          0xff2A9D8F,
                        ).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons
                            .video_library_outlined,
                        size: 50,
                        color:
                        Color(0xff2A9D8F),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'لا توجد فيديوهات حالياً',
                      textAlign:
                      TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 19,
                        fontWeight:
                        FontWeight.bold,
                        color:
                        Color(0xff264653),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'لم تتم إضافة فيديوهات إلى قائمة التشغيل حتى الآن.',
                      textAlign:
                      TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 14,
                        height: 1.5,
                        color:
                        Color(0xff6C7A7A),
                      ),
                    ),
                    const SizedBox(height: 20),
                    OutlinedButton.icon(
                      onPressed: () {
                        context
                            .read<
                            DisplayVideosProvider>()
                            .getVideos(
                          id: widget.id,
                        );
                      },
                      icon: const Icon(
                        Icons.refresh_rounded,
                        color:
                        Color(0xff2A9D8F),
                      ),
                      label: const Text(
                        'تحديث',
                        style: TextStyle(
                          fontFamily: 'Tajawal',
                          color:
                          Color(0xff2A9D8F),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _cleanErrorMessage(String error) {
    return error
        .replaceFirst('Exception:', '')
        .replaceFirst('DioException:', '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }
}