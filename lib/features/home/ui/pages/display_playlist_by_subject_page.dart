import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:graduationprojct/features/home/providers/display_playlist_by_subject_provider.dart';
import 'package:graduationprojct/features/home/providers/display_playlists_provider.dart';
import 'package:graduationprojct/features/home/providers/teachers_provider.dart';
import 'package:graduationprojct/features/home/ui/pages/main_navigation_page.dart';
import 'package:graduationprojct/features/home/ui/pages/subject_search_page.dart';
import 'package:provider/provider.dart';

import '../widgets/course_card_template.dart';
import '../widgets/teacher_card_template.dart';

class DisplayPlaylistBySubjectPage extends StatefulWidget {
  final int id;
  const DisplayPlaylistBySubjectPage({super.key, required this.id});

  @override
  State<DisplayPlaylistBySubjectPage> createState() =>
      _DisplayPlaylistBySubjectPageState();
}

class _DisplayPlaylistBySubjectPageState
    extends State<DisplayPlaylistBySubjectPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DisplayPlaylistBySubjectProvider>().getPlaylists(
        id: widget.id,
      );
      context.read<TeachersProvider>().getTeachers(
        subjectId: widget.id,
      );
    });
  }

  Widget build(BuildContext context) {
    final provider = context.watch<DisplayPlaylistBySubjectProvider>();
    final playlists = provider.playlists;
    final teachersProvider = context.watch<TeachersProvider>();
    final teachers = teachersProvider.teachers;
    if (provider.isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: Color(0xff2A9D8F),
            ),
          ),
        ),
      );
    }
    if (playlists.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: Image.asset('assets/Images/Ellipse 4.png'),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Image.asset('assets/Images/Ellipse 7.png'),
            ),
            Positioned(
              top: 55,
              right: 16,
              child: IconButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return MainNavigationPage();
                    },
                  ),
                ),
                icon: const Row(
                  children: [
                    Text(
                      "قوائم التشغيل",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xff2A9D8F),
                        fontFamily: "Tajawal",
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(width: 20),

                    Icon(
                      Icons.arrow_back_ios_new_rounded,
                      textDirection: TextDirection.rtl,
                      color: Color(0xff2A9D8F),
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),

            const Center(child: Text("لا توجد بيانات")),
          ],
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
              child: Image.asset('assets/Images/Ellipse 4.png'),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Image.asset('assets/Images/Ellipse 7.png'),
            ),
            Positioned(
              top: 55,
              right: 16,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return MainNavigationPage();
                        },
                      ),
                    ),
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      textDirection: TextDirection.rtl,
                      color: Color(0xff2A9D8F),
                      size: 20,
                    ),
                  ),
                  Text(
                    "قوائم التشغيل",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xff2A9D8F),
                      fontFamily: "Tajawal",
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 110,
              right: 16,
              left: 16,
              child: SizedBox(
                height: 110,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: teachers.length,
                  itemBuilder: (context, index) {
                    final teacher = teachers[index];
                    return TeacherCard(
                      subjectId: widget.id,
                      name: teacher.name,
                      image: teacher.image,
                      id: teacher.id,
                    );
                  },
                ),
              ),
            ),
            Positioned.fill(
              top: 230,
              left: 16,
              right: 16,
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 20),
                itemCount: playlists.length,
                itemBuilder: (context, index) {
                  final playlist = playlists[index];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: CourseCardTemplate(
                      playlistId: playlist.id,
                      imagePath: playlist.thumbnail ??
                          'assets/Images/Gemini_Generated_Image_hy81hehy81hehy81 1.png',
                      title: playlist.name,
                      durationText: "${playlist.totalDuration ?? 0} دقيقة",
                      progress: playlist.completionRate / 100,
                      description: playlist.subjectDetail.name,
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
