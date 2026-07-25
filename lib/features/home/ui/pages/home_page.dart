import 'package:flutter/material.dart';
import 'package:graduationprojct/features/home/providers/filtered_playlist_provider.dart';
import 'package:graduationprojct/features/auth/ui/pages/profile/profile_page.dart';
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

    if (provider.isLoading) {
      return const Scaffold(
          body: Center(
            child: SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: Color(0xff2A9D8F),
              ),
            ),
          )
      );
    }
    if (playlists.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text("لا توجد بيانات"),
        ),
      );
    }

    if (filterProvider.isLoading) {
      return const Scaffold(
          body: Center(
            child: SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: Color(0xff2A9D8F),
              ),
            ),
          )
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
              child: Image.asset('assets/Images/Ellipse 4.png'),
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
                          "مسار",
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
                    Padding(
                      padding: const EdgeInsets.only(right: 220,top: 18),
                      child: Consumer<ProfileProvider>(
                        builder: (context, provider, child) {
                          return GestureDetector(
                            onTap: provider.isLoading
                                ? null
                                : () async {
                              await provider.getProfile();

                              if (provider.isSuccess) {
                                Navigator.of(context, rootNavigator: true).push(
                                  MaterialPageRoute(
                                    builder: (_) => const ProfilePage(),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(provider.errorMessage ?? "حدث خطأ"),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              width: 48,
                              height: 48,
                              decoration: const BoxDecoration(
                                color: Color(0xff2A9D8F),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: provider.isLoading
                                    ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                                    : const Icon(
                                  Icons.person_outline_outlined,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    )                 ],
                ),

                TextFieldTemplate(
                  hint: 'ابحث هنا',
                  size: 20,
                  size2: 21,
                  icon: Icons.search,
                ),

                const SizedBox(height: 30),

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
                          padding: const EdgeInsets.only(right: 20, left: 20),
                          child: Container(
                            height: 320,
                            width: 10000,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.only(bottom: 20),
                              itemCount: 2,
                              itemBuilder: (context, index) {
                                final playlist = playlists[index];
                                return  Padding(
                                  padding: const EdgeInsets.only(left: 16, ),
                                  child: CourseCardTemplate(
                                    playlistId: playlist.id,
                                    imagePath:
                                    'assets/Images/Gemini_Generated_Image_hy81hehy81hehy81 1.png',
                                    title: playlist.name,
                                    durationText: "${playlist.totalDuration ?? 0} دقيقة",
                                    progress: playlist.completionRate / 100,
                                    description: playlist.description,
                                  ),
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
