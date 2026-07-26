import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../auth/ui/widgets/progress_line.dart';
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

  /// يتم استدعاؤها عندما تُحذف القائمة من المفضلة.
  final VoidCallback? onRemovedFromFavourite;

  const CourseCardTemplate({
    super.key,
    required this.playlistId,
    required this.imagePath,
    required this.description,
    required this.title,
    required this.durationText,
    required this.progress,
    this.onRemovedFromFavourite,
    this.width = 375,
    this.height = 280,
  });

  @override
  State<CourseCardTemplate> createState() => _CourseCardTemplateState();
}

class _CourseCardTemplateState extends State<CourseCardTemplate> {
  bool isFavorite = false;
  bool isFavoriteLoading = false;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final int? userPk = prefs.getInt("user_pk");

    if (userPk == null) {
      return;
    }

    final String key = "fav_playlist_${userPk}_${widget.playlistId}";

    final bool savedStatus = prefs.getBool(key) ?? false;

    if (!mounted) {
      return;
    }

    setState(() {
      isFavorite = savedStatus;
    });
  }

  Future<void> _toggleFavorite() async {
    if (isFavoriteLoading) {
      return;
    }

    final bool previousStatus = isFavorite;

    setState(() {
      isFavorite = !isFavorite;
      isFavoriteLoading = true;
    });

    final favProvider = context.read<AddPlaylistToFavProvider>();

    await favProvider.addPlaylistToFav(id: widget.playlistId);

    if (!mounted) {
      return;
    }

    if (favProvider.isSuccess) {
      final prefs = await SharedPreferences.getInstance();

      final int? userPk = prefs.getInt("user_pk");

      bool savedStatus = isFavorite;

      if (userPk != null) {
        final String key = "fav_playlist_${userPk}_${widget.playlistId}";

        savedStatus = prefs.getBool(key) ?? isFavorite;
      }

      if (!mounted) {
        return;
      }

      setState(() {
        isFavorite = savedStatus;
        isFavoriteLoading = false;
      });

      MySnackBar.show(
        context,
        message: favProvider.response?.status.toString() ?? "تم تحديث المفضلة",
      );

      /*
       * إذا أصبحت القيمة false فهذا يعني أن القائمة
       * أُزيلت من المفضلة، فنخبر الصفحة الأب.
       */
      if (!savedStatus) {
        widget.onRemovedFromFavourite?.call();
      }
    } else {
      setState(() {
        isFavorite = previousStatus;
        isFavoriteLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            favProvider.errorMessage ?? "حدث خطأ أثناء تحديث المفضلة",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DisplayVideosPage(id: widget.playlistId),
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
                    child: Image.asset(widget.imagePath, fit: BoxFit.cover),
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
                      onPressed: isFavoriteLoading ? null : _toggleFavorite,
                      icon: isFavoriteLoading
                          ? const SizedBox(
                              width: 21,
                              height: 21,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.red,
                              ),
                            )
                          : Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: Colors.red,
                            ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
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
              padding: const EdgeInsets.only(right: 8),
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
                  children: [
                    const Icon(
                      Icons.access_time,
                      color: Color(0xff92A1A1),
                      size: 17,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      widget.durationText,
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
              child: CustomProgressLine(progress: widget.progress),
            ),
          ],
        ),
      ),
    );
  }
}
