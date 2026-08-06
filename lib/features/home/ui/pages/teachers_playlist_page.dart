import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:graduationprojct/features/home/providers/display_playlist_by_subject_provider.dart';
import 'package:graduationprojct/features/home/providers/display_playlists_provider.dart';
import 'package:graduationprojct/features/home/providers/playlist_by_teachers_provider.dart';
import 'package:graduationprojct/features/home/providers/teachers_provider.dart';
import 'package:graduationprojct/features/home/ui/pages/main_navigation_page.dart';
import 'package:graduationprojct/features/home/ui/pages/subject_search_page.dart';
import 'package:provider/provider.dart';

import '../widgets/course_card_template.dart';
import '../widgets/teacher_card_template.dart';
import 'display_playlist_by_subject_page.dart';

class TeachersPlaylistPage extends StatefulWidget {
  final int id;
  final int subjectId;
  const TeachersPlaylistPage({super.key, required this.id, required this.subjectId});

  @override
  State<TeachersPlaylistPage> createState() =>
      _TeachersPlaylistPageState();
}

class _TeachersPlaylistPageState
    extends State<TeachersPlaylistPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PlaylistByTeachersProvider>().playlistByTeacher(
        id: widget.id,
      );
    });
  }

  Widget build(BuildContext context) {
    final provider = context.watch<DisplayPlaylistBySubjectProvider>();
    final playlists = provider.playlists;
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
                      return DisplayPlaylistBySubjectPage(id: widget.subjectId,);
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
            Positioned.fill(
              top: 130,
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
          ],
        ),
      ),
    );
  }
}
