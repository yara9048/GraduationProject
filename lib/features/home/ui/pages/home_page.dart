import 'package:flutter/material.dart';
import 'package:graduationprojct/features/home/providers/display_subjects_provider.dart';
import 'package:graduationprojct/features/home/providers/playlist_by_class_provider.dart';
import 'package:graduationprojct/features/home/ui/pages/all_subjects_page.dart';
import 'package:graduationprojct/features/home/ui/pages/notification_page.dart';
import 'package:graduationprojct/features/home/ui/widgets/new_added_course_template.dart';
import 'package:graduationprojct/features/home/ui/widgets/subjects_card_template.dart';
import 'package:provider/provider.dart';

import '../../providers/now_showing_playlist_provider.dart';
import '../../providers/subscriptions_provider.dart';
import '../widgets/course_card_template.dart';
import '../widgets/section_title_template.dart';
import 'display_playlists_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final filterProvider =
    context.watch<PlaylistByClassProvider>();

    final filteredPlaylists =
        filterProvider.playlists;

    final subscriptionsProvider =
    context.watch<SubscriptionsProvider>();

    final subscriptionsPlaylists =
        subscriptionsProvider.subscriptions;

    final subjectsProvider =
    context.watch<DisplaySubjectsProvider>();

    final subjects =
        subjectsProvider.subjects;

    final List<String> subjectImages = [
      'assets/Images/Group 42.png',
      'assets/Images/Group 48.png',
      'assets/Images/Group 47.png',
    ];

    final List<Color> subjectColors = [
      const Color(0xffE76F51),
      const Color(0xff2A9D8F),
      const Color(0xffA67500),
    ];

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
              top: 56,
              left: 8,
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                      const NotificationPage(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.notifications_none_outlined,
                  color: Color(0xff2A9D8F),
                  size: 35,
                ),
              ),
            ),

            Column(
              crossAxisAlignment:
              CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Align(
                      alignment:
                      Alignment.centerRight,
                      child: Padding(
                        padding:
                        const EdgeInsets.only(
                          top: 60,
                          right: 30,
                          bottom: 30,
                        ),
                        child: Text(
                          "لمّاح ",
                          style: TextStyle(
                            fontSize: 38,
                            fontWeight:
                            FontWeight.bold,
                            color:
                            const Color(
                              0xff2A9D8F,
                            ),
                            fontFamily:
                            "Tajawal",
                            shadows: const [
                              Shadow(
                                offset:
                                Offset(-1, 4),
                                blurRadius: 16,
                                color:
                                Colors.black26,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                Expanded(
                  child:
                  MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: ListView(
                      children: [
                        if (subscriptionsProvider
                            .isLoading ||
                            subscriptionsProvider
                                .errorMessage !=
                                null ||
                            subscriptionsPlaylists
                                .isNotEmpty) ...[
                          Padding(
                            padding:
                            const EdgeInsets
                                .only(
                              right: 30,
                              left: 30,
                            ),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,
                              children: [
                                const SectionTitle(
                                  title:
                                  "تتابعه الان  :",
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            DisplayPlaylistsPage(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "عرض الكل",
                                    style:
                                    TextStyle(
                                      color: Color(
                                        0xffE9C46A,
                                      ),
                                      fontWeight:
                                      FontWeight
                                          .bold,
                                      fontFamily:
                                      "Tajawal",
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(
                            height: 5,
                          ),

                          Padding(
                            padding:
                            const EdgeInsets
                                .symmetric(
                              horizontal: 15,
                            ),
                            child: SizedBox(
                              height: 245,
                              child: Builder(
                                builder:
                                    (context) {
                                  if (subscriptionsProvider
                                      .isLoading) {
                                    return const Center(
                                      child:
                                      SizedBox(
                                        width: 28,
                                        height: 28,
                                        child:
                                        CircularProgressIndicator(
                                          strokeWidth:
                                          3,
                                          color:
                                          Color(
                                            0xff2A9D8F,
                                          ),
                                        ),
                                      ),
                                    );
                                  }

                                  if (subscriptionsProvider
                                      .errorMessage !=
                                      null) {
                                    return Center(
                                      child: Text(
                                        subscriptionsProvider
                                            .errorMessage ??
                                            "حدث خطأ غير معروف",
                                        textAlign:
                                        TextAlign
                                            .center,
                                        style:
                                        const TextStyle(
                                          fontFamily:
                                          "Tajawal",
                                          color:
                                          Colors
                                              .red,
                                        ),
                                      ),
                                    );
                                  }

                                  return ListView
                                      .builder(
                                    scrollDirection:
                                    Axis.horizontal,
                                    itemCount:
                                    subscriptionsPlaylists
                                        .length,
                                    itemBuilder:
                                        (
                                        context,
                                        index,
                                        ) {
                                      final playlist =
                                      subscriptionsPlaylists[
                                      index];

                                      final course =
                                          playlist
                                              .playlistDetail;

                                      return Padding(
                                        padding:
                                        const EdgeInsets
                                            .only(
                                          left: 16,
                                        ),
                                        child:
                                        CourseCardTemplate(
                                          playlistId:
                                          course!
                                              .id,
                                          imagePath:
                                          course.thumbnail ??
                                              'assets/Images/Gemini_Generated_Image_hy81hehy81hehy81 1.png',
                                          title:
                                          course.name,
                                          durationText:
                                          "${course.totalDuration ?? 0} دقيقة",
                                          progress:
                                          playlist.playlistDetail!.completionRate /
                                              100,
                                          description:
                                          course.subjectDetail?.name ??
                                              "",
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 10,
                          ),
                        ],

                        /// =========================
                        /// المقررات الأكاديمية
                        /// =========================

                        Padding(
                          padding:
                          const EdgeInsets.only(
                            right: 30,
                            left: 30,
                          ),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,
                            children: [
                              const SectionTitle(
                                title:
                                "المقررات الأكاديمية :",
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                      const AllSubjectsPage(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "عرض الكل",
                                  style:
                                  TextStyle(
                                    color: Color(
                                      0xffE9C46A,
                                    ),
                                    fontWeight:
                                    FontWeight
                                        .bold,
                                    fontFamily:
                                    "Tajawal",
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        SizedBox(
                          height: 90,
                          child: Padding(
                            padding:
                            const EdgeInsets
                                .only(
                              right: 10,
                            ),
                            child: ListView.builder(
                              scrollDirection:
                              Axis.horizontal,
                              itemCount:
                              subjects.length <
                                  3
                                  ? subjects
                                  .length
                                  : 3,
                              itemBuilder:
                                  (
                                  context,
                                  index,
                                  ) {
                                final sub =
                                subjects[index];

                                return Padding(
                                  padding:
                                  const EdgeInsets
                                      .only(
                                    right: 8,
                                    bottom: 10,
                                  ),
                                  child:
                                  SubjectsCard(
                                    id: sub.id,
                                    title:
                                    sub.name,
                                    imagePath:
                                    subjectImages[
                                    index %
                                        subjectImages
                                            .length],
                                    textColor:
                                    subjectColors[
                                    index %
                                        subjectColors
                                            .length],
                                    width: 150,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                        const Padding(
                          padding:
                          EdgeInsets.only(
                            right: 30,
                            top: 20,
                          ),
                          child: SectionTitle(
                            title:
                            "خصيصا لك :",
                          ),
                        ),

                        Padding(
                          padding:
                          const EdgeInsets.only(
                            right: 20,
                          ),
                          child: SizedBox(
                            height: 223,
                            child: Builder(
                              builder:
                                  (context) {
                                if (filterProvider
                                    .isLoading) {
                                  return const Center(
                                    child:
                                    CircularProgressIndicator(
                                      color:
                                      Color(
                                        0xff2A9D8F,
                                      ),
                                    ),
                                  );
                                }

                                if (filterProvider
                                    .errorMessage !=
                                    null) {
                                  return Center(
                                    child: Text(
                                      filterProvider
                                          .errorMessage!,
                                      textAlign:
                                      TextAlign
                                          .center,
                                      style:
                                      const TextStyle(
                                        color:
                                        Colors.red,
                                        fontFamily:
                                        "Tajawal",
                                      ),
                                    ),
                                  );
                                }

                                if (filteredPlaylists
                                    .isEmpty) {
                                  return const Center(
                                    child: Text(
                                      "لا توجد قوائم تشغيل",
                                      style:
                                      TextStyle(
                                        fontFamily:
                                        "Tajawal",
                                        fontSize:
                                        15,
                                        color:
                                        Colors.grey,
                                        fontWeight:
                                        FontWeight
                                            .w500,
                                      ),
                                    ),
                                  );
                                }

                                return ListView
                                    .builder(
                                  scrollDirection:
                                  Axis.horizontal,
                                  itemCount:
                                  filteredPlaylists
                                      .length,
                                  itemBuilder:
                                      (
                                      context,
                                      index,
                                      ) {
                                    final playlist =
                                    filteredPlaylists[
                                    index];

                                    return Padding(
                                      padding:
                                      const EdgeInsets
                                          .only(
                                        left: 16,
                                      ),
                                      child: Align(
                                        alignment:
                                        Alignment
                                            .topRight,
                                        child:
                                        NewAddedCourseTemplate(
                                          id: playlist
                                              .id,
                                          imagePath:
                                          Image.network(
                                            playlist.thumbnail ??
                                                '',
                                            height:
                                            100,
                                            width: double
                                                .infinity,
                                            fit: BoxFit
                                                .cover,
                                            alignment:
                                            const Alignment(
                                              0,
                                              0.3,
                                            ),
                                            errorBuilder:
                                                (
                                                context,
                                                error,
                                                stackTrace,
                                                ) {
                                              return Image
                                                  .asset(
                                                'assets/Images/Gemini_Generated_Image_hy81hehy81hehy81 1.png',
                                                height:
                                                100,
                                                width: double
                                                    .infinity,
                                                fit: BoxFit
                                                    .cover,
                                              );
                                            },
                                          ),
                                          title:
                                          playlist
                                              .name,
                                          duration:
                                          playlist.totalDuration ==
                                              null
                                              ? "0"
                                              : playlist
                                              .totalDuration!
                                              .toStringAsFixed(
                                            0,
                                          ),
                                          color:
                                          const Color(
                                            0xffE76F51,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}