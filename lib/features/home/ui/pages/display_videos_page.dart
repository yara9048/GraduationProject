import 'package:flutter/material.dart';
import 'package:graduationprojct/features/home/providers/display_videos_provider.dart';
import 'package:graduationprojct/features/home/providers/playlist_details_provider.dart';
import 'package:graduationprojct/features/home/ui/pages/video_details_page.dart';
import 'package:graduationprojct/features/home/ui/widgets/course_info_dialog_template.dart';
import 'package:provider/provider.dart';

import '../widgets/video_card_template.dart';

class DisplayVideosPage extends StatefulWidget {
  final int id;
  const DisplayVideosPage({super.key , required this.id});

  @override
  State<DisplayVideosPage> createState() => _DisplayVideosPageState();
}

class _DisplayVideosPageState extends State<DisplayVideosPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DisplayVideosProvider>().getVideos(id: widget.id);
      context.read<PlaylistDetailsProvider>().getDetails(id: widget.id);
    });
  }
  Widget build(BuildContext context) {

    final provider = context.watch<DisplayVideosProvider>();
    final videos = provider.videos;

    final provider2 = context.watch<PlaylistDetailsProvider>();
    final course = provider2.playListDetails;

    if (provider.isLoading) {
      return Scaffold(
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
    if (videos.isEmpty) {
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
                  onPressed: () => Navigator.pop(context),
                  icon: const Row(
                    children: [
                      Icon(
                        Icons.arrow_back_ios_new_rounded,
                        textDirection: TextDirection.rtl,
                        color: Color(0xff2A9D8F),
                        size: 30,
                      ),
                      SizedBox(width: 20,),

                      Text("فيديوهات قائمة التشفيل",style: TextStyle(fontWeight: FontWeight.bold,
                          color: Color(0xff2A9D8F),
                          fontFamily: "Tajawal",fontSize: 22),),

                    ],
                  ),
                ),),
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
                top: 55,
                right: 16,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Row(
                    children: [
                      Icon(
                        Icons.arrow_back_ios_new_rounded,
                        textDirection: TextDirection.rtl,
                        color: Color(0xff2A9D8F),
                        size: 30,
                      ),
                      SizedBox(width: 20,),

                      Text("فيديوهات قائمة التشفيل",style: TextStyle(fontWeight: FontWeight.bold,
                          color: Color(0xff2A9D8F),
                          fontFamily: "Tajawal",fontSize: 22),),

                    ],
                  ),
                ),),
                Positioned(
                  top: 48,
                  left: 10,
                  child: IconButton(
                    onPressed: () {
                        if (course == null) return;

                        showDialog(
                          context: context,
                          builder: (_) => CourseInfoDialogTemplate(
                            course: course,
                          ),
                        );

                    },
                    icon: Icon(
                      Icons.info_outline,
                      textDirection: TextDirection.rtl,
                      color: Color(0xff2A9D8F),
                      size: 40,
                    ),
              ),),
              Positioned(
                top: 150,
                left: 16,
                right: 16,
                bottom: 16,
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 20),
                  itemCount: videos.length,
                  itemBuilder: (context, index) {
                    final video = videos[index];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: VideoCardTemplate(
                        imagePath: "assets/Images/photo_2026-07-23_00-20-19.jpg",
                        title: video.title,
                        description: video.description,
                        duration: video.duration.toString(),
                        views: video.views,
                        status: video.status,
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (Context){return VideoDetailsPage(videoId: video.id,videoName: video.title,);}));
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          )),
    );
  }
}
