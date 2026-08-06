import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:graduationprojct/features/home/data/services/playlist_search_service.dart';
import 'package:graduationprojct/features/home/providers/display_playlists_provider.dart';
import 'package:graduationprojct/features/home/ui/pages/playlist_search_page.dart';
import 'package:graduationprojct/features/home/ui/pages/subject_search_page.dart';
import 'package:provider/provider.dart';

import '../widgets/course_card_template.dart';

class DisplayPlaylistsPage extends StatefulWidget {
  const DisplayPlaylistsPage({super.key});

  @override
  State<DisplayPlaylistsPage> createState() => _DisplayPlaylistsPageState();
}

class _DisplayPlaylistsPageState extends State<DisplayPlaylistsPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DisplayPlaylistsProvider>().getPlayLists();
    });
  }
  Widget build(BuildContext context) {
    final provider = context.watch<DisplayPlaylistsProvider>();
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
        )
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
              top: 70,
              right: 16,
              child: Text("قائمة التشغيل",style: TextStyle(fontWeight: FontWeight.bold,
                        color: Color(0xff2A9D8F),
                        fontFamily: "Tajawal",fontSize: 20),),
            ),
            const Center(
              child: Text("لا توجد بيانات"),
            ),
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
              top: 70,
              right: 16,
              child: Text("قوائم التشغيل",style: TextStyle(fontWeight: FontWeight.bold,
                      color: Color(0xff2A9D8F),
                      fontFamily: "Tajawal",fontSize:20),),

            ),
            Positioned(
              top: 50,
              left: 8,
              child: IconButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context){return PlaylistSearchPage();}));},
                icon: Icon(
                  Icons.search,
                  color: const Color(0xff2A9D8F),
                  size: 30,
                ),
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

                  return  Padding(
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
            )
          ],
        )),
    );
  }
}
