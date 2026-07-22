import 'package:flutter/material.dart';
import 'package:graduationprojct/features/auth/ui/widgets/progress_line.dart';
import 'package:provider/provider.dart';

import '../../../auth/ui/widgets/snack_bar.dart';
import '../../providers/add_playlist_to_fav_provider.dart';
import '../pages/display_videos_page.dart';

class CourseCardTemplate extends StatefulWidget {
  final String imagePath;
  final int playlistId;
  final String description;
  final String title;
  final String durationText;
  final double progress;
  final double width;
  final double height;

  const CourseCardTemplate({
    super.key,
    required this.playlistId,
    required this.imagePath,
    required this.description,
    required this.title,
    required this.durationText,
    required this.progress,
    this.width = 375,
    this.height = 280,
  });

  @override
  State<CourseCardTemplate> createState() => _CourseCardTemplateState();
}

class _CourseCardTemplateState extends State<CourseCardTemplate> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final favProvider = Provider.of<AddPlaylistToFavProvider>(context);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DisplayVideosPage(id: widget.playlistId,),
          ),
        );
      },
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 20,
              offset: Offset(-3, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // الصورة مع زر المفضلة
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: SizedBox(
                    height: 160,
                    width: double.infinity,
                    child: Image.asset(
                      widget.imagePath,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                Positioned(
                  top: 12,
                  left: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () async {
                        setState(() {
                          isFavorite = !isFavorite;
                        });

                        await favProvider.addPlaylistToFav(
                          id: widget.playlistId,
                        );

                        if (favProvider.isSuccess) {
                          MySnackBar.show(
                            context,
                            message: favProvider.response!.status.toString(),
                          );}
                         else if (favProvider.errorMessage != null) {
                          setState(() {
                            print(widget.playlistId);
                            isFavorite = !isFavorite;
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(favProvider.errorMessage!),
                            ),
                          );
                        }
                      },
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.only(
                left: 12,
                right: 12,
                top: 12,
              ),
              child: Align(
                alignment: Alignment.topRight,
                child: Text(
                  widget.title,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 19,
                    color: Color(0xff264653),
                    fontFamily: "Tajawal",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(
                widget.description,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 15,
                  fontFamily: "Tajawal",
                  color: Color(0xff92A1A1),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.access_time,
                      color: Color(0xff92A1A1),
                      size: 17,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      widget.durationText,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontSize: 15,
                        fontFamily: "Tajawal",
                        color: Color(0xff92A1A1),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
                bottom: 20,
                top: 7,
              ),
              child: CustomProgressLine(
                progress: widget.progress,
              ),
            ),
          ],
        ),
      ),
    );
  }
}