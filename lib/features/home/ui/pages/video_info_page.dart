import 'package:flutter/material.dart';

import '../../data/models/video_details_model.dart';
import '../widgets/statistics_card_template.dart';

class VideoInfoPage extends StatelessWidget {
  final VideoDetailsModel video;

  const VideoInfoPage({
    super.key,
    required this.video,
  });

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
              ),
            ),

            SafeArea(
              child: Column(
                children: [
                  SizedBox(
                    height: 70,
                    child: Padding(
                      padding:
                      const EdgeInsets.symmetric(
                        horizontal: 8,
                      ),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            borderRadius:
                            BorderRadius.circular(
                              12,
                            ),
                            child: const Padding(
                              padding:
                              EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 6,
                              ),
                              child: Text(
                                'تفاصيل الفيديو',
                                style: TextStyle(
                                  fontFamily:
                                  'Tajawal',
                                  fontSize: 18,
                                  fontWeight:
                                  FontWeight.bold,
                                  color: Color(
                                    0xff2A9D8F,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Expanded(
                    child:
                    SingleChildScrollView(
                      physics:
                      const BouncingScrollPhysics(),
                      padding:
                      const EdgeInsets.fromLTRB(
                        18,
                        16,
                        18,
                        30,
                      ),
                      child: Column(
                        children: [

                          Container(
                            width:
                            double.infinity,
                            padding:
                            const EdgeInsets.all(
                              20,
                            ),
                            decoration:
                            BoxDecoration(
                              gradient:
                              const LinearGradient(
                                colors: [
                                  Color(
                                    0xff2A9D8F,
                                  ),
                                  Color(
                                    0xff21867A,
                                  ),
                                ],
                                begin:
                                Alignment.topRight,
                                end:
                                Alignment.bottomLeft,
                              ),
                              borderRadius:
                              BorderRadius.circular(
                                24,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                  const Color(
                                    0xff2A9D8F,
                                  ).withValues(
                                    alpha: 0.22,
                                  ),
                                  blurRadius: 18,
                                  offset:
                                  const Offset(
                                    0,
                                    8,
                                  ),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration:
                                  BoxDecoration(
                                    color:
                                    Colors.white
                                        .withValues(
                                      alpha: 0.18,
                                    ),
                                    shape:
                                    BoxShape.circle,
                                  ),
                                  child:
                                  const Icon(
                                    Icons
                                        .play_lesson_outlined,
                                    size: 34,
                                    color:
                                    Colors.white,
                                  ),
                                ),

                                const SizedBox(
                                  height: 14,
                                ),

                                Text(
                                  video.title,
                                  textAlign:
                                  TextAlign.center,
                                  style:
                                  const TextStyle(
                                    fontFamily:
                                    'Tajawal',
                                    fontSize: 20,
                                    height: 1.4,
                                    fontWeight:
                                    FontWeight.bold,
                                    color:
                                    Colors.white,
                                  ),
                                ),

                                const SizedBox(
                                  height: 12,
                                ),

                                Container(
                                  padding:
                                  const EdgeInsets
                                      .symmetric(
                                    horizontal: 14,
                                    vertical: 8,
                                  ),
                                  decoration:
                                  BoxDecoration(
                                    color:
                                    Colors.white
                                        .withValues(
                                      alpha: 0.18,
                                    ),
                                    borderRadius:
                                    BorderRadius
                                        .circular(
                                      20,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize:
                                    MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons
                                            .check_circle_outline_rounded,
                                        size: 18,
                                        color:
                                        Colors.white,
                                      ),
                                      const SizedBox(
                                        width: 7,
                                      ),
                                      Text(
                                        video.status,
                                        style:
                                        const TextStyle(
                                          fontFamily:
                                          'Tajawal',
                                          fontSize: 15,
                                          fontWeight:
                                          FontWeight.bold,
                                          color:
                                          Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(
                            height: 18,
                          ),

                          Container(
                            width:
                            double.infinity,
                            padding:
                            const EdgeInsets.all(
                              18,
                            ),
                            decoration:
                            BoxDecoration(
                              color:
                              const Color(
                                0xffF4FAF9,
                              ),
                              borderRadius:
                              BorderRadius.circular(
                                20,
                              ),
                              border:
                              Border.all(
                                color:
                                const Color(
                                  0xffDDEDEA,
                                ),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                              children: [
                                const Row(
                                  children: [
                                    Icon(
                                      Icons
                                          .description_outlined,
                                      color:
                                      Color(
                                        0xff2A9D8F,
                                      ),
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      'وصف الفيديو',
                                      style:
                                      TextStyle(
                                        fontFamily:
                                        'Tajawal',
                                        fontSize: 16,
                                        fontWeight:
                                        FontWeight.bold,
                                        color:
                                        Color(
                                          0xff264653,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(
                                  height: 12,
                                ),

                                Text(
                                  video.description
                                      .trim()
                                      .isEmpty
                                      ? 'لا يوجد وصف'
                                      : video.description,
                                  textAlign:
                                  TextAlign.justify,
                                  style:
                                  const TextStyle(
                                    fontFamily:
                                    'Tajawal',
                                    fontSize: 14,
                                    height: 1.8,
                                    color:
                                    Color(
                                      0xff1A2429,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(
                            height: 18,
                          ),

                          GridView.count(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio:
                            1.35,
                            shrinkWrap: true,
                            physics:
                            const NeverScrollableScrollPhysics(),
                            children: [
                              StatisticCard(
                                icon: Icons
                                    .schedule_rounded,
                                title:
                                'مدة الفيديو',
                                value:
                                '${video.duration} دقيقة',
                              ),

                              StatisticCard(
                                icon: Icons
                                    .visibility_outlined,
                                title:
                                'المشاهدات',
                                value:
                                '${video.views}',
                              ),

                              StatisticCard(
                                icon: Icons
                                    .quiz_outlined,
                                title:
                                'عدد الأسئلة',
                                value:
                                '${video.mcqCount}',
                                iconColor:
                                const Color(
                                  0xffE76F51,
                                ),
                              ),

                              StatisticCard(
                                icon: Icons
                                    .check_circle_outline_rounded,
                                title:
                                'الحالة',
                                value:
                                video.status,
                                iconColor:
                                const Color(
                                  0xff2A9D8F,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 22,
                          ),

                          Container(
                            width:
                            double.infinity,
                            padding:
                            const EdgeInsets.all(
                              16,
                            ),
                            decoration:
                            BoxDecoration(
                              color:
                              const Color(
                                0xff2A9D8F,
                              ).withValues(
                                alpha: 0.08,
                              ),
                              borderRadius:
                              BorderRadius.circular(
                                18,
                              ),
                              border:
                              Border.all(
                                color:
                                const Color(
                                  0xff2A9D8F,
                                ).withValues(
                                  alpha: 0.18,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 46,
                                  height: 46,
                                  decoration:
                                  BoxDecoration(
                                    color:
                                    const Color(
                                      0xff2A9D8F,
                                    ).withValues(
                                      alpha: 0.12,
                                    ),
                                    borderRadius:
                                    BorderRadius
                                        .circular(
                                      14,
                                    ),
                                  ),
                                  child:
                                  const Icon(
                                    Icons
                                        .verified_rounded,
                                    color:
                                    Color(
                                      0xff2A9D8F,
                                    ),
                                    size: 24,
                                  ),
                                ),

                                const SizedBox(
                                  width: 12,
                                ),

                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text(
                                        'حالة الفيديو',
                                        style:
                                        TextStyle(
                                          fontFamily:
                                          'Tajawal',
                                          fontSize: 12,
                                          color:
                                          Color(
                                            0xff6C7A7A,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        'حالة توفر المحتوى',
                                        style:
                                        TextStyle(
                                          fontFamily:
                                          'Tajawal',
                                          fontSize: 14,
                                          fontWeight:
                                          FontWeight.bold,
                                          color:
                                          Color(
                                            0xff264653,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Container(
                                  padding:
                                  const EdgeInsets
                                      .symmetric(
                                    horizontal: 13,
                                    vertical: 7,
                                  ),
                                  decoration:
                                  BoxDecoration(
                                    color:
                                    const Color(
                                      0xff2A9D8F,
                                    ),
                                    borderRadius:
                                    BorderRadius
                                        .circular(
                                      20,
                                    ),
                                  ),
                                  child: Text(
                                    video.status,
                                    style:
                                    const TextStyle(
                                      fontFamily:
                                      'Tajawal',
                                      fontSize: 12,
                                      fontWeight:
                                      FontWeight.bold,
                                      color:
                                      Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          SizedBox(
                            width:
                            double.infinity,
                            height: 52,
                            child:
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pop(
                                  context,
                                );
                              },
                              icon:
                              const Icon(
                                Icons
                                    .arrow_forward_rounded,
                              ),
                              label:
                              const Text(
                                'العودة للفيديو',
                              ),
                              style:
                              ElevatedButton
                                  .styleFrom(
                                backgroundColor:
                                const Color(
                                  0xff264653,
                                ),
                                foregroundColor:
                                Colors.white,
                                shape:
                                RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius
                                      .circular(
                                    15,
                                  ),
                                ),
                                textStyle:
                                const TextStyle(
                                  fontFamily:
                                  'Tajawal',
                                  fontSize: 15,
                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
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
}