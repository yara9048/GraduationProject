import 'package:flutter/material.dart';
import 'package:graduationprojct/features/home/providers/watching_history_provider.dart';
import 'package:graduationprojct/features/home/ui/pages/main_navigation_page.dart';
import 'package:graduationprojct/features/home/ui/pages/video_details_page.dart';
import 'package:provider/provider.dart';

import '../widgets/watching_history_card.dart';

class WatchingHistoryPage extends StatefulWidget {
  const WatchingHistoryPage({super.key});

  @override
  State<WatchingHistoryPage> createState() => _WatchingHistoryPageState();
}

class _WatchingHistoryPageState extends State<WatchingHistoryPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WatchingHistoryProvider>().getPlaylists();
    });
  }
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WatchingHistoryProvider>();
    final playlists = provider.playlists;

    return Directionality(
      textDirection: TextDirection.rtl,
      child:  Scaffold(
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
              top: 120,
              right: 16,
              left: 16,
              bottom: 0,
              child: SizedBox(
                height: 200,
                child: ListView.builder(
                  padding: const EdgeInsets.only(
                    top: 10,
                    bottom: 25,
                  ),
                  itemCount: playlists.length,
                  itemBuilder: (context, index) {
                    final history = playlists[index];
                    return WatchingHistoryCard(
                      history: history,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                VideoDetailsPage(
                                  videoId: history.videoDetail.id,
                                  playlistId:
                                  history.courseDetail.id,
                                  videoName:
                                  history.videoDetail.title,
                                ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            Positioned(
              top: 55,
              right: 16,
              child: IconButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context){return MainNavigationPage(initialIndex: 4,);})),
                  icon: const Row(
                  children: [
                    Icon(
                      Icons.arrow_back_ios_new_rounded,
                      textDirection: TextDirection.rtl,
                      color: Color(0xff2A9D8F),
                      size: 20,
                    ),
                    SizedBox(width: 20,),

                    Text("سجل المشاهدات",style: TextStyle(fontWeight: FontWeight.bold,
                        color: Color(0xff2A9D8F),
                        fontFamily: "Tajawal",fontSize: 20),),

                  ],
                ),
              ),),

          ],
        ),
      ),
    );
  }
}
