import 'package:flutter/material.dart';
import 'package:graduationprojct/features/home/providers/display_subjects_provider.dart';
import 'package:graduationprojct/features/home/providers/filtered_playlist_provider.dart';
import 'package:graduationprojct/features/auth/ui/pages/profile/profile_page.dart';
import 'package:graduationprojct/features/home/ui/pages/all_subjects_page.dart';
import 'package:graduationprojct/features/home/ui/pages/notification_page.dart';
import 'package:graduationprojct/features/home/ui/widgets/new_added_course_template.dart';
import 'package:graduationprojct/features/home/ui/widgets/subjects_card_template.dart';
import 'package:provider/provider.dart';

import '../../../auth/providers/profile_provider.dart';
import '../../providers/display_playlists_provider.dart';
import '../../providers/now_showing_playlist_provider.dart';
import '../widgets/course_card_template.dart';
import '../../../auth/ui/widgets/text_field_template.dart';
import '../widgets/section_title_template.dart';
import 'display_playlists_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NowShowingPlaylistProvider>().getPlaylists();
      context.read<FilteredPlaylistProvider>().getFilteredPlaylists();
      context.read<DisplaySubjectsProvider>().getSubjects();

    });
  }
  Widget build(BuildContext context) {
    final filterProvider = context.watch<FilteredPlaylistProvider>();
    final filteredPlaylists = filterProvider.filtered_playlists;
    final nowShowingProvider = context.watch<NowShowingPlaylistProvider>();
    final nowShowingPlaylists = nowShowingProvider.playlists;
    final subjectsProvider = context.watch<DisplaySubjectsProvider>();
    final subjects = subjectsProvider.subjects;
    final List<String> subjectImages = [
      'assets/Images/Group 47.png',
      'assets/Images/Group 48.png',
      'assets/Images/Group 49.png',
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
              child: Image.asset('assets/Images/Ellipse 4.png'),
            ),
            Positioned(
              top: 47.5,
              left: 8,
              child: IconButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context){return NotificationPage();}));
                },
                icon: Icon(
                  Icons.notifications_none_outlined,
                  color: const Color(0xff2A9D8F),
                  size: 40,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 60,
                          right: 30,
                          bottom: 30,
                        ),
                        child: Text(
                          "لمّاح ",
                          style: TextStyle(
                            fontSize: 38,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff2A9D8F),
                            fontFamily: "Tajawal",
                            shadows: [
                              Shadow(
                                offset: Offset(-1, 4),
                                blurRadius: 16,
                                color: Colors.black26,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                                 ],
                ),
                Expanded(
                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 30,left: 30),
                          child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const SectionTitle(
                                    title: "تتابعه الان  :",
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => DisplayPlaylistsPage(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "عرض الكل",
                                      style: TextStyle(
                                        color: Color(0xffE9C46A),
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Tajawal",
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ],
                          ),
                        ),

                        const SizedBox(height: 5),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal:15),
                          child: SizedBox(
                            height: 245,
                            child: Builder(
                              builder: (context) {
                                if (nowShowingProvider.isLoading) {
                                  return const Center(
                                    child: SizedBox(
                                      width: 28,
                                      height: 28,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 3,
                                        color: Color(0xff2A9D8F),
                                      ),
                                    ),
                                  );
                                }
                                if (nowShowingProvider.errorMessage != null) {
                                  return Center(
                                    child: Text(
                                      nowShowingProvider.errorMessage ?? "حدث خطأ غير معروف",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontFamily: "Tajawal",
                                        color: Colors.red,
                                      ),
                                    ),
                                  );
                                }

                                if (nowShowingPlaylists.isEmpty) {
                                  return const Center(
                                    child: Text(
                                      "لا توجد بيانات",
                                      style: TextStyle(
                                        fontFamily: "Tajawal",
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  );
                                }
                                return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: nowShowingPlaylists.length,
                                  itemBuilder: (context, index) {
                                    final playlist = nowShowingPlaylists[index];

                                    return Padding(
                                      padding: const EdgeInsets.only(left: 16),
                                      child: CourseCardTemplate(
                                        playlistId: playlist.courseDetail!.id,
                                        imagePath:
                                        'assets/Images/Gemini_Generated_Image_hy81hehy81hehy81 1.png',
                                        title: playlist.courseDetail!.name,
                                        durationText:
                                        "${playlist.courseDetail?.totalDuration ?? 0} دقيقة",
                                        progress: playlist.progressPercentage/100,
                                        description: playlist.courseDetail!.description,
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 30,
                            left: 30,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SectionTitle(
                                title: "المقررات الأكاديمية :",
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => AllSubjectsPage(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "عرض الكل",
                                  style: TextStyle(
                                    color: Color(0xffE9C46A),
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Tajawal",
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 10),

                        SizedBox(
                          height: 90,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: subjects.length,
                              itemBuilder: (context, index) {
                                final sub = subjects[index];
                                return Padding(
                                  padding: const EdgeInsets.only(
                                    right: 8,
                                    bottom: 10,
                                  ),
                                  child: SubjectsCard(
                                    id: sub.id,
                                    title: sub.name,
                                    imagePath: subjectImages[
                                    index % subjectImages.length],
                                    textColor: const Color(0xffA67500),
                                    width: 150,
                                  ),
                                );
                              },
                            ),
                          )),
                        Padding(
                          padding: const EdgeInsets.only(right: 30, top: 20),
                          child: const SectionTitle(title: "خصيصا لك :"),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: SizedBox(
                            height: 223,
                            child: Builder(
                              builder: (context) {
                                if (filterProvider.isLoading) {
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      color: Color(0xff2A9D8F),
                                    ),
                                  );
                                }

                                if (filterProvider.errorMessage != null) {
                                  return Center(
                                    child: Text(
                                      filterProvider.errorMessage!,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontFamily: "Tajawal",
                                      ),
                                    ),
                                  );
                                }

                                if (filteredPlaylists.isEmpty) {
                                  return const Center(
                                    child: Text(
                                      "لا توجد بيانات",
                                      style: TextStyle(
                                        fontFamily: "Tajawal",
                                      ),
                                    ),
                                  );
                                }

                                return ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: filteredPlaylists.length,
                                    itemBuilder: (context, index) {
                                      final playlist = filteredPlaylists[index];

                                      return Padding(
                                        padding: const EdgeInsets.only(left: 16),
                                        child: Align(
                                          alignment: Alignment.topRight,
                                          child: NewAddedCourseTemplate(
                                            id: playlist.id,
                                            imagePath:
                                            'assets/Images/700ccaab9d6c5bae720cc6ee03954b805e4c490e.jpg',
                                            title: playlist.name,
                                            duration: playlist.totalDuration == null
                                                ? "0"
                                                : playlist.totalDuration!.toStringAsFixed(0),
                                            color: const Color(0xffE76F51),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                              },
                            ),
                          ),
                        )
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
