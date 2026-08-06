import 'package:flutter/material.dart';
import 'package:graduationprojct/features/home/providers/playlist_search_provider.dart';
import 'package:graduationprojct/features/home/ui/widgets/course_card_template.dart';
import 'package:provider/provider.dart';

import '../../../auth/ui/widgets/text_field_template.dart';
import 'main_navigation_page.dart';

class PlaylistSearchPage extends StatefulWidget {
  const PlaylistSearchPage({super.key});

  @override
  State<PlaylistSearchPage> createState() =>
      _PlaylistSearchPageState();
}

class _PlaylistSearchPageState
    extends State<PlaylistSearchPage> {
  final TextEditingController controller =
  TextEditingController();
  bool hasSearched = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance
        .addPostFrameCallback((_) {
      if (!mounted) return;

      controller.clear();

      context
          .read<PlaylistSearchProvider>()
          .resetSearch();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void search() {
    final String query =
    controller.text.trim();

    if (query.isEmpty) {
      context
          .read<PlaylistSearchProvider>()
          .resetSearch();

      setState(() {
        hasSearched = false;
      });

      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      hasSearched = true;
    });

    context
        .read<PlaylistSearchProvider>()
        .playlistSearch(
      query: query,
    );
  }

  void closeSearchPage() {
    controller.clear();

    context
        .read<PlaylistSearchProvider>()
        .resetSearch();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
        const MainNavigationPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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

            /*
             * زر الرجوع والعنوان.
             */
            Positioned(
              top: 70,
              right: 16,
              child: InkWell(
                borderRadius:
                BorderRadius.circular(20),
                onTap: closeSearchPage,
                child: const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons
                            .arrow_back_ios_new_rounded,
                        textDirection:
                        TextDirection.rtl,
                        color:
                        Color(0xff2A9D8F),
                        size: 20,
                      ),
                      SizedBox(width: 20),
                      Text(
                        "البحث",
                        style: TextStyle(
                          fontWeight:
                          FontWeight.bold,
                          color:
                          Color(0xff2A9D8F),
                          fontFamily: "Tajawal",
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            /*
             * حقل البحث.
             */
            Positioned(
              top: 140,
              left: 5,
              right: 5,
              child: TextFieldTemplate(
                controller: controller,
                hint: 'ابحث هنا',
                size: 20,
                size2: 21,
                icon: Icons.search,
                onSubmitted: (_) {
                  search();
                },
              ),
            ),

            /*
             * النتائج.
             *
             * bottom مهم حتى يصبح ارتفاع
             * ListView محدداً.
             */
            Positioned(
              top: 220,
              left: 10,
              right: 10,
              bottom: 20,
              child:
              Consumer<PlaylistSearchProvider>(
                builder:
                    (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(
                      child:
                      CircularProgressIndicator(
                        strokeWidth: 2,
                        color:
                        Color(0xff2A9D8F),
                      ),
                    );
                  }

                  if (provider.errorMessage !=
                      null) {
                    return Center(
                      child: Text(
                        provider.errorMessage!,
                        textAlign:
                        TextAlign.center,
                        style: const TextStyle(
                          fontFamily:
                          "Tajawal",
                        ),
                      ),
                    );
                  }

                  /*
                   * عند فتح الصفحة لا نظهر
                   * عبارة لا يوجد نتائج.
                   */
                  if (!hasSearched) {
                    return const SizedBox.shrink();
                  }

                  if (provider
                      .playlists.isEmpty) {
                    return const Center(
                      child: Text(
                        "لا يوجد نتائج",
                        style: TextStyle(
                          fontFamily:
                          "Tajawal",
                          fontSize: 16,
                        ),
                      ),
                    );
                  }

                  /*
                   * ListView واحدة فقط.
                   * الكود السابق كان يحتوي
                   * ListView داخل ListView.
                   */
                  return MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: ListView.builder(
                      keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior
                          .onDrag,
                      padding:
                      const EdgeInsets.only(
                        left: 15,
                        right: 15,
                        bottom: 20,
                      ),
                      itemCount:
                      provider.playlists.length,
                      itemBuilder:
                          (context, index) {
                        final playlist =
                        provider.playlists[
                        index];

                        return Padding(
                          padding:
                          const EdgeInsets
                              .only(
                            bottom: 16,
                          ),
                          child:
                          CourseCardTemplate(
                            playlistId:
                            playlist.id,
                            imagePath:
                            'assets/Images/Gemini_Generated_Image_hy81hehy81hehy81 1.png',
                            title:
                            playlist.name,
                            durationText:
                            "${playlist.totalDuration ?? 0} دقيقة",
                            progress:
                            (playlist
                                .completionRate /
                                100)
                                .clamp(
                              0.0,
                              1.0,
                            ),
                            description:
                            playlist
                                .description,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}