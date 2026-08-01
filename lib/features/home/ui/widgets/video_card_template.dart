import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../auth/ui/widgets/snack_bar.dart';
import '../../providers/add_video_to_fav_provider.dart';
import 'safe_network_image.dart';

class VideoCardTemplate extends StatefulWidget {
  final int videoId;
  final String? imagePath;
  final String description;
  final String title;
  final String duration;
  final int views;
  final String status;
  final VoidCallback? onTap;
  final VoidCallback? onRemovedFromFavourite;

  const VideoCardTemplate({
    super.key,
    required this.videoId,
    required this.imagePath,
    required this.description,
    required this.title,
    required this.duration,
    required this.views,
    required this.status,
    this.onTap,
    this.onRemovedFromFavourite,
  });

  @override
  State<VideoCardTemplate> createState() =>
      _VideoCardTemplateState();
}

class _VideoCardTemplateState
    extends State<VideoCardTemplate> {
  bool isFavorite = false;
  bool isFavoriteLoading = false;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  Future<int?> _getUserPk(
      SharedPreferences prefs,
      ) async {
    return prefs.getInt('user_pk') ??
        int.tryParse(
          prefs.getString('user_pk') ?? '',
        );
  }

  Future<void> _loadFavoriteStatus() async {
    final SharedPreferences prefs =
    await SharedPreferences.getInstance();

    final int? userPk =
    await _getUserPk(prefs);

    if (userPk == null) {
      return;
    }

    final String key =
        'fav_video_${userPk}_${widget.videoId}';

    final bool savedStatus =
        prefs.getBool(key) ?? false;

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

    final AddVideoToFavProvider favProvider =
    context.read<AddVideoToFavProvider>();

    await favProvider.addVidToFav(
      id: widget.videoId,
    );

    if (!mounted) {
      return;
    }

    if (favProvider.isSuccess) {
      final SharedPreferences prefs =
      await SharedPreferences.getInstance();

      final int? userPk =
      await _getUserPk(prefs);

      bool savedStatus = isFavorite;

      if (userPk != null) {
        final String key =
            'fav_video_${userPk}_${widget.videoId}';

        savedStatus =
            prefs.getBool(key) ?? isFavorite;
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
        message:
        favProvider.response?.status.toString() ??
            'تم تحديث المفضلة',
      );

      if (!savedStatus) {
        widget.onRemovedFromFavourite?.call();
      }
    } else {
      setState(() {
        isFavorite = previousStatus;
        isFavoriteLoading = false;
      });

      MySnackBar.show(
        context,
        message:
        favProvider.errorMessage ??
            'حدث خطأ أثناء تحديث المفضلة',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 6,
      ),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 100,
                    width: double.infinity,
                    child: SafeNetworkImage(
                      imageUrl: widget.imagePath,
                      placeholderPath:
                      'assets/Images/photo_2026-07-23_00-20-19.jpg',
                      width: double.infinity,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: Color(0xff264653),
                      size: 24,
                    ),
                  ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      padding:
                      const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color:
                        const Color(0xff2A9D8F),
                        borderRadius:
                        BorderRadius.circular(8),
                      ),
                      child: Text(
                        widget.status,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 6,
                    left: 6,
                    child: Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        color:
                        Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: isFavoriteLoading
                            ? null
                            : _toggleFavorite,
                        icon: isFavoriteLoading
                            ? const SizedBox(
                          width: 16,
                          height: 16,
                          child:
                          CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.red,
                          ),
                        )
                            : Icon(
                          isFavorite
                              ? Icons.favorite
                              : Icons
                              .favorite_border,
                          color: Colors.red,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 6,
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.title,
                      textAlign: TextAlign.right,
                      maxLines: 1,
                      overflow:
                      TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Tajawal',
                        color: Color(0xff264653),
                      ),
                    ),
                    if (widget
                        .description.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        widget.description,
                        textAlign: TextAlign.right,
                        maxLines: 1,
                        overflow:
                        TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ],
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.visibility_rounded,
                          size: 16,
                          color: Color(0xffA67500),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '${widget.views}',
                          style: const TextStyle(
                            color:
                            Color(0xffA67500),
                            fontWeight:
                            FontWeight.w600,
                            fontFamily: 'Tajawal',
                            fontSize: 12,
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.access_time_rounded,
                          size: 16,
                          color:
                          Color(0xff92A1A1),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          widget.duration,
                          style: const TextStyle(
                            color:
                            Color(0xff92A1A1),
                            fontWeight:
                            FontWeight.w600,
                            fontFamily: 'Tajawal',
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}