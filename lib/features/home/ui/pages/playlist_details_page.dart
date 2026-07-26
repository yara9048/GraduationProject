import 'package:flutter/material.dart';
import 'package:graduationprojct/features/home/data/models/playlist_details_model.dart';
import 'package:graduationprojct/features/home/ui/pages/display_videos_page.dart';

class PlaylistDetailsPage extends StatefulWidget {
  final PlayListDetailsModel course;

  const PlaylistDetailsPage({
    super.key,
    required this.course,
  });

  @override
  State<PlaylistDetailsPage> createState() =>
      _PlaylistDetailsPageState();
}

class _PlaylistDetailsPageState
    extends State<PlaylistDetailsPage> {
  bool join = false;
  bool isJoining = false;

  double? selectedRating;

  PlayListDetailsModel get course => widget.course;

  Future<void> _joinCourse() async {
    if (join || isJoining) return;

    setState(() {
      isJoining = true;
    });

    try {
      await Future.delayed(
        const Duration(milliseconds: 500),
      );

      if (!mounted) return;

      setState(() {
        join = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'تم الاشتراك في القائمة بنجاح',
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Color(0xff2A9D8F),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'تعذر الاشتراك: $e',
            textDirection: TextDirection.rtl,
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isJoining = false;
        });
      }
    }
  }

  void _openRatingBottomSheet() {
    if (!join) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'يجب الاشتراك أولاً حتى تتمكن من التقييم',
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.orange,
        ),
      );

      return;
    }

    int tempRating =
        selectedRating?.round() ?? 0;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (bottomSheetContext) {
        return StatefulBuilder(
          builder: (context, setBottomSheetState) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: Container(
                padding: EdgeInsets.fromLTRB(
                  22,
                  22,
                  22,
                  MediaQuery.paddingOf(context).bottom + 22,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: const Color(0xffD9E7E5),
                        borderRadius:
                        BorderRadius.circular(10),
                      ),
                    ),

                    const SizedBox(height: 22),

                    const Text(
                      'قيّم قائمة التشغيل',
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff264653),
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'اختر التقييم الذي يناسب تجربتك',
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 15,
                        color: Color(0xff6C7A7A),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: List.generate(
                        5,
                            (index) {
                          final starValue = index + 1;

                          return IconButton(
                            onPressed: () {
                              setBottomSheetState(() {
                                tempRating = starValue;
                              });
                            },
                            icon: Icon(
                              starValue <= tempRating
                                  ? Icons.star_rounded
                                  : Icons.star_border_rounded,
                              size: 42,
                              color: Colors.amber,
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: tempRating == 0
                            ? null
                            : () {
                          /*
                                 * هون لاحقًا API التقييم:
                                 *
                                 * await provider.ratePlaylist(
                                 *   id: course.id,
                                 *   rating: tempRating,
                                 * );
                                 */

                          setState(() {
                            selectedRating =
                                tempRating.toDouble();
                          });

                          Navigator.pop(
                            bottomSheetContext,
                          );

                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'تم إرسال تقييمك بنجاح',
                                textDirection:
                                TextDirection.rtl,
                              ),
                              backgroundColor:
                              Color(0xff2A9D8F),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          const Color(0xff2A9D8F),
                          disabledBackgroundColor:
                          Colors.grey.shade300,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'إرسال التقييم',
                          style: TextStyle(
                            fontFamily: 'Tajawal',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _openVideos() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DisplayVideosPage(
          id: course.id,
        ),
      ),
    );
  }

  String _formatNumber(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    return value.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: Image.asset(
                'assets/Images/Ellipse 4.png',
              ),
            ),

            Positioned(
              bottom: 0,
              right: 0,
              child: Image.asset(
                'assets/Images/Ellipse 7.png',
              ),),

            Positioned(
                top: 55,
                right: 16,
                child: IconButton(
                  onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (context){return DisplayVideosPage(id: course.id);}));},
                  icon: Text("تفاصيل قائمة التشفيل",style: TextStyle(fontWeight: FontWeight.bold,
                      color: Color(0xff2A9D8F),
                      fontFamily: "Tajawal",fontSize: 22),),
                ),),

            SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(
                        left: 18,
                        top: 100,
                        right: 18,
                       bottom:  30,
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xff2A9D8F),
                                  Color(0xff21867A),
                                ],
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                              ),
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                  const Color(0xff2A9D8F).withValues(
                                    alpha: 0.22,
                                  ),
                                  blurRadius: 18,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width: 82,
                                  height: 82,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(
                                      alpha: 0.18,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.school_outlined,
                                    size: 42,
                                    color: Colors.white,
                                  ),
                                ),

                                const SizedBox(height: 14),

                                Text(
                                  course.name,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontFamily: 'Tajawal',
                                    fontSize: 24,
                                    height: 1.4,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),

                                const SizedBox(height: 10),

                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 7,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(
                                      alpha: 0.18,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    course.category,
                                    style: const TextStyle(
                                      fontFamily: 'Tajawal',
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 14),

                                AnimatedContainer(
                                  duration:
                                  const Duration(milliseconds: 250),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: join
                                        ? Colors.white
                                        : Colors.white.withValues(
                                      alpha: 0.16,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        join
                                            ? Icons.check_circle_rounded
                                            : Icons.lock_open_rounded,
                                        size: 19,
                                        color: join
                                            ? const Color(0xff2A9D8F)
                                            : Colors.white,
                                      ),
                                      const SizedBox(width: 7),
                                      Text(
                                        join ? 'مشترك' : 'غير مشترك',
                                        style: TextStyle(
                                          fontFamily: 'Tajawal',
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: join
                                              ? const Color(0xff2A9D8F)
                                              : Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 18),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xffF4FAF9),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xffDDEDEA),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.description_outlined,
                            color: Color(0xff2A9D8F),
                          ),
                          SizedBox(width: 8),
                          Text(
                            'وصف قائمة التشغيل',
                            style: TextStyle(
                              fontFamily: 'Tajawal',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff264653),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      Text(
                        course.description,
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          fontFamily: 'Tajawal',
                          fontSize: 18,
                          height: 1.8,
                          color: Color(0xff1A2429),
                        ),
                      ),
                    ],
                  ),
                ),

                          const SizedBox(height: 18),

                GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.35,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildStatisticCard(
                      icon: Icons.play_circle_outline,
                      title: 'الفيديوهات',
                      value: '${course.totalVideoCount}',
                    ),
                    _buildStatisticCard(
                      icon: Icons.schedule_rounded,
                      title: 'إجمالي المدة',
                      value:
                      '${_formatNumber(course.totalDuration)} دقيقة',
                    ),
                    _buildStatisticCard(
                      icon: Icons.people_outline_rounded,
                      title: 'عدد الطلاب',
                      value: '${course.studentsCount}',
                    ),
                    _buildStatisticCard(
                      icon: Icons.star_rounded,
                      title: 'التقييم',
                      value:
                      '${_formatNumber(course.rating)}/5',
                      iconColor: Colors.amber,
                    ),
                    _buildStatisticCard(
                      icon: Icons.trending_up_rounded,
                      title: 'معدل الإنجاز',
                      value:
                      '${_formatNumber(course.completionRate)}%',
                    ),
                    _buildStatisticCard(
                      icon: selectedRating == null
                          ? Icons.rate_review_outlined
                          : Icons.star_rounded,
                      title: 'تقييمك',
                      value: selectedRating == null
                          ? 'لم تقيّم'
                          : '${selectedRating!.toInt()}/5',
                      iconColor: selectedRating == null
                          ? const Color(0xff2A9D8F)
                          : Colors.amber,
                    ),
                  ],
                ),

                          const SizedBox(height: 22),

              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      onPressed:
                      join || isJoining ? null : _joinCourse,
                      icon: isJoining
                          ? const SizedBox(
                        width: 21,
                        height: 21,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                          : Icon(
                        join
                            ? Icons.check_circle_rounded
                            : Icons.person_add_alt_1_rounded,
                      ),
                      label: Text(
                        isJoining
                            ? 'جارٍ الاشتراك...'
                            : join
                            ? 'تم الاشتراك'
                            : 'اشتراك',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        const Color(0xff2A9D8F),
                        disabledBackgroundColor: join
                            ? const Color(0xffB7DED8)
                            : const Color(0xff2A9D8F),
                        foregroundColor: Colors.white,
                        disabledForegroundColor:
                        Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(15),
                        ),
                        textStyle: const TextStyle(
                          fontFamily: 'Tajawal',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 52,
                          child: OutlinedButton.icon(
                            onPressed:
                            join ? _openRatingBottomSheet : null,
                            icon: const Icon(
                              Icons.star_outline_rounded,
                            ),
                            label: const Text('تقييم'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                              const Color(0xff264653),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(15),
                              ),
                              textStyle: const TextStyle(
                                fontFamily: 'Tajawal',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: SizedBox(
                          height: 52,
                          child: ElevatedButton.icon(
                            onPressed: _openVideos,
                            icon: const Icon(
                              Icons.play_circle_outline_rounded,
                            ),
                            label: const Text(
                              'عرض الفيديوهات',
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                              const Color(0xff264653),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(15),
                              ),
                              textStyle: const TextStyle(
                                fontFamily: 'Tajawal',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  if (!join) ...[
                    const SizedBox(height: 10),
                    const Row(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.lock_outline_rounded,
                          size: 18,
                          color: Color(0xff264653),
                        ),
                        SizedBox(width: 5),
                        Text(
                          'يجب الاشتراك حتى تتمكن من تقييم القائمة',
                          style: TextStyle(
                            fontFamily: 'Tajawal',
                            fontSize: 16,
                            color: Color(0xff264653),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }



  Widget _buildStatisticCard({
    required IconData icon,
    required String title,
    required String value,
    Color iconColor = const Color(0xff2A9D8F),
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xffE0ECEA),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.04,
            ),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment:
        MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 38,
          ),

          const SizedBox(height: 8),

          Text(
            value,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xff264653),
            ),
          ),

          const SizedBox(height: 4),

          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 16,
              color: Color(0xff264653),
            ),
          ),
        ],
      ),
    );
  }

}