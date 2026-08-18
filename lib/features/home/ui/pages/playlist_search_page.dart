import 'package:flutter/material.dart';
import 'package:graduationprojct/features/home/providers/playlist_search_provider.dart';
import 'package:graduationprojct/features/home/ui/widgets/course_card_template.dart';
import 'package:provider/provider.dart';

import '../../../auth/ui/widgets/text_field_template.dart';
import 'main_navigation_page.dart';

class PlaylistSearchPage extends StatefulWidget {
  const PlaylistSearchPage({
    super.key,
  });

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      controller.clear();

      context
          .read<PlaylistSearchProvider>()
          .resetSearch();

      setState(() {
        hasSearched = false;
      });
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

            SafeArea(
              child: Column(
                children: [
                  SizedBox(
                    height: 70,
                    child: Padding(
                      padding:
                      const EdgeInsets.symmetric(
                        horizontal: 8,
                      ),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: closeSearchPage,
                            borderRadius:
                            BorderRadius.circular(
                              12,
                            ),
                            child: const Padding(
                              padding:
                              EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 6,
                              ),
                              child: Row(
                                mainAxisSize:
                                MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons
                                        .arrow_back_ios_new_rounded,
                                    textDirection:
                                    TextDirection.rtl,
                                    color: Color(
                                      0xff2A9D8F,
                                    ),
                                    size: 20,
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    'البحث عن قائمة تشغيل',
                                    style:
                                    TextStyle(
                                      fontWeight:
                                      FontWeight.bold,
                                      color: Color(
                                        0xff2A9D8F,
                                      ),
                                      fontFamily:
                                      'Tajawal',
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ============================
                  // Search Field
                  // ============================

                  Padding(
                    padding:
                    const EdgeInsets.only(
                      top: 8,
                      bottom: 10
                    ),
                    child: TextFieldTemplate(
                      controller: controller,
                      hint:
                      'ابحث عن قائمة تشغيل',
                      size: 20,
                      size2: 21,
                      icon: Icons.search,
                      onSubmitted: (_) {
                        search();
                      },
                    ),
                  ),

                  // ============================
                  // Results
                  // ============================

                  Expanded(
                    child:
                    Consumer<PlaylistSearchProvider>(
                      builder: (
                          context,
                          provider,
                          child,
                          ) {
                        if (provider.isLoading) {
                          return const Center(
                            child: SizedBox(
                              width: 32,
                              height: 32,
                              child:
                              CircularProgressIndicator(
                                strokeWidth: 3,
                                color: Color(
                                  0xff2A9D8F,
                                ),
                              ),
                            ),
                          );
                        }

                        if (provider.errorMessage !=
                            null) {
                          return _buildErrorState(
                            provider.errorMessage!,
                          );
                        }

                        if (!hasSearched) {
                          return _buildInitialState();
                        }

                        if (provider.playlists.isEmpty) {
                          return _buildEmptyState(
                            title:
                            'لا توجد نتائج',
                            subtitle:
                            'لم نعثر على قائمة تشغيل مطابقة لبحثك.',
                            icon:
                            Icons.search_off_rounded,
                          );
                        }

                        return RefreshIndicator(
                          color: const Color(
                            0xff2A9D8F,
                          ),
                          onRefresh: () async {
                            search();
                          },
                          child: MediaQuery.removePadding(
                            context: context,
                            removeTop: true,
                            child: ListView.builder(
                              keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior
                                  .onDrag,
                              physics:
                              const AlwaysScrollableScrollPhysics(),
                              padding:
                              const EdgeInsets.fromLTRB(
                                18,
                                10,
                                18,
                                30,
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
                                  const EdgeInsets.only(
                                    bottom: 18,
                                  ),
                                  child: Center(
                                    child:
                                    CourseCardTemplate(
                                      playlistId:
                                      playlist.id,
                                      imagePath:playlist.thumbnail ??
                                      'assets/Images/Gemini_Generated_Image_hy81hehy81hehy81 1.png',
                                      title:
                                      playlist.name,
                                      durationText:
                                      '${playlist.totalDuration ?? 0}',
                                      progress:
                                      (playlist.completionRate /
                                          100)
                                          .clamp(
                                        0.0,
                                        1.0,
                                      ),
                                      description:
                                      playlist
                                          .subjectDetail!.name,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInitialState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 150.0),
        child: Column(
          mainAxisSize:
          MainAxisSize.min,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration:
              BoxDecoration(
                color:
                const Color(
                  0xff2A9D8F,
                ).withValues(
                  alpha: 0.10,
                ),
                shape:
                BoxShape.circle,
              ),
              child: const Icon(
                Icons
                    .search_rounded,
                size: 48,
                color:
                Color(
                  0xff2A9D8F,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            const Text(
              'ابحث عن قائمة التشغيل',
              textAlign:
              TextAlign.center,
              style:
              TextStyle(
                fontFamily:
                'Tajawal',
                fontSize: 19,
                fontWeight:
                FontWeight.bold,
                color:
                Color(
                  0xff264653,
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            const Text(
              'اكتب اسم قائمة التشغيل التي تريد الوصول إليها.',
              textAlign:
              TextAlign.center,
              style:
              TextStyle(
                fontFamily:
                'Tajawal',
                fontSize: 14,
                height: 1.6,
                color:
                Color(
                  0xff6C7A7A,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Center(
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
              decoration:
              BoxDecoration(
                color:
                const Color(
                  0xffE9C46A,
                ).withValues(
                  alpha: 0.16,
                ),
                shape:
                BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 48,
                color:
                const Color(
                  0xffA67500,
                ),
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            Text(
              title,
              textAlign:
              TextAlign.center,
              style:
              const TextStyle(
                fontFamily:
                'Tajawal',
                fontSize: 19,
                fontWeight:
                FontWeight.bold,
                color:
                Color(
                  0xff264653,
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              subtitle,
              textAlign:
              TextAlign.center,
              style:
              const TextStyle(
                fontFamily:
                'Tajawal',
                fontSize: 14,
                height: 1.6,
                color:
                Color(
                  0xff6C7A7A,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(
      String error,
      ) {
    return Center(
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
              decoration:
              BoxDecoration(
                color:
                Colors.red
                    .withValues(
                  alpha: 0.10,
                ),
                shape:
                BoxShape.circle,
              ),
              child:
              const Icon(
                Icons
                    .error_outline_rounded,
                size: 48,
                color:
                Colors.red,
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            const Text(
              'تعذر تنفيذ البحث',
              textAlign:
              TextAlign.center,
              style:
              TextStyle(
                fontFamily:
                'Tajawal',
                fontSize: 19,
                fontWeight:
                FontWeight.bold,
                color:
                Color(
                  0xff264653,
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              error,
              textAlign:
              TextAlign.center,
              style:
              const TextStyle(
                fontFamily:
                'Tajawal',
                fontSize: 13,
                height: 1.5,
                color:
                Color(
                  0xff6C7A7A,
                ),
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            OutlinedButton.icon(
              onPressed: search,
              icon:
              const Icon(
                Icons
                    .refresh_rounded,
                color:
                Color(
                  0xff2A9D8F,
                ),
              ),
              label:
              const Text(
                'إعادة المحاولة',
                style:
                TextStyle(
                  fontFamily:
                  'Tajawal',
                  fontWeight:
                  FontWeight.bold,
                  color:
                  Color(
                    0xff2A9D8F,
                  ),
                ),
              ),
              style:
              OutlinedButton
                  .styleFrom(
                side:
                const BorderSide(
                  color:
                  Color(
                    0xff2A9D8F,
                  ),
                ),
                shape:
                RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(
                    14,
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