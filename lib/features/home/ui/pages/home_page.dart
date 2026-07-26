import 'package:flutter/material.dart';
import 'package:graduationprojct/features/home/providers/filtered_playlist_provider.dart';
import 'package:graduationprojct/features/auth/ui/pages/profile/profile_page.dart';
import 'package:graduationprojct/features/home/ui/pages/notification_page.dart';
import 'package:graduationprojct/features/home/ui/widgets/new_added_course_template.dart';
import 'package:graduationprojct/features/home/ui/widgets/subjects_card_template.dart';
import 'package:provider/provider.dart';

import '../../../auth/providers/profile_provider.dart';
import '../../providers/display_playlists_provider.dart';
import '../widgets/course_card_template.dart';
import '../../../auth/ui/widgets/text_field_template.dart';
import '../widgets/section_title_template.dart';
import 'course_view.dart';
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
      context.read<DisplayPlaylistsProvider>().getPlayLists();
      context.read<FilteredPlaylistProvider>().getFilteredPlaylists();

    });
  }
  Widget build(BuildContext context) {
    final provider = context.watch<DisplayPlaylistsProvider>();
    final playlists = provider.playlists;
    final filterProvider = context.watch<FilteredPlaylistProvider>();
    final filteredPlaylists = filterProvider.filtered_playlists;

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
              top: 45,
              left: 8,
              child: IconButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context){return NotificationPage();}));
                },
                icon: Icon(
                  Icons.notifications_none_outlined,
                  color: const Color(0xff2A9D8F),
                  size: 46,
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
                          top: 50,
                          right: 30,
                          bottom: 30,
                        ),
                        child: Text(
                          "لمّاح ",
                          style: TextStyle(
                            fontSize: 43,
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
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                          ),
                        ),

                        const SizedBox(height: 10),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: SizedBox(
                            height: 320,
                            child: Builder(
                              builder: (context) {
                                if (provider.isLoading) {
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

                                if (provider.errorMessage != null) {
                                  return Center(
                                    child: Text(
                                      provider.errorMessage!,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontFamily: "Tajawal",
                                        color: Colors.red,
                                      ),
                                    ),
                                  );
                                }

                                if (playlists.isEmpty) {
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
                                  padding: const EdgeInsets.only(bottom: 20),
                                  itemCount: playlists.length > 2
                                      ? 2
                                      : playlists.length,
                                  itemBuilder: (context, index) {
                                    final playlist = playlists[index];

                                    return Padding(
                                      padding: const EdgeInsets.only(left: 16),
                                      child: CourseCardTemplate(
                                        playlistId: playlist.id,
                                        imagePath:
                                        'assets/Images/Gemini_Generated_Image_hy81hehy81hehy81 1.png',
                                        title: playlist.name,
                                        durationText:
                                        "${playlist.totalDuration ?? 0} دقيقة",
                                        progress:
                                        playlist.completionRate / 100,
                                        description: playlist.description,
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(
                            right: 30,
                            left: 30,
                            top: 10,
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
                                      builder: (_) => CourseView(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "عرض الكل",
                                  style: TextStyle(
                                    color: Color(0xffE9C46A),
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Tajawal",
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 10),

                        SizedBox(
                          height: 110,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              SubjectsCard(
                                title: "القانون المدني",
                                imagePath: 'assets/Images/Group 47.png',
                                textColor: Color(0xffA67500),
                                width: 220,
                              ),
                              SubjectsCard(
                                title: "قانون أصول المحاكمات الجزئية",
                                imagePath: 'assets/Images/Group 43.png',
                                textColor: Color(0xff009A87),
                                width: 220,
                                width2: 160,
                                top: 5,
                                size: 24,
                              ),
                              SubjectsCard(
                                title: "قانون العقوبات العام 3",
                                imagePath: 'assets/Images/Group 42.png',
                                textColor: Color(0xffE76F51),
                                width: 220,
                                width2: 150,
                              ),
                            ],
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(right: 30, top: 35),
                          child: const SectionTitle(title: "خصيصا لك :"),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: SizedBox(
                            height: filteredPlaylists.isEmpty ? 60 : 330,
                            child: filteredPlaylists.isEmpty
                                ? const Center(
                              child: Text("لا توجد بيانات"),
                            )
                                : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: filteredPlaylists.length,
                              itemBuilder: (context, index) {
                                final playlist = filteredPlaylists[index];
                                return Padding(
                                  padding: const EdgeInsets.only(left: 16),
                                  child: NewAddedCourseTemplate(
                                    id: playlist.id,
                                    imagePath: 'assets/Images/700ccaab9d6c5bae720cc6ee03954b805e4c490e.jpg',
                                    title: playlist.name,
                                    duration: playlist.totalDuration.toString(),
                                    color: const Color(0xffE76F51),
                                  ),
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
