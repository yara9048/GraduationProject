import 'package:flutter/material.dart';
import 'package:graduationprojct/features/home/ui/pages/display_videos_page.dart';
import 'package:graduationprojct/features/home/ui/pages/main_navigation_page.dart';
import 'package:provider/provider.dart';

import '../../providers/functions_for_playlist_details_provider.dart';
import '../../providers/playlist_details_provider.dart';
import '../../providers/rating_playlist_provider.dart';
import '../../providers/subscribe_provider.dart';
import '../widgets/statistics_card_template.dart';

class PlaylistDetailsPage extends StatefulWidget {
  final int id;

  const PlaylistDetailsPage({
    super.key,
    required this.id,
  });

  @override
  State<PlaylistDetailsPage> createState() =>
      _PlaylistDetailsPageState();
}

class _PlaylistDetailsPageState
    extends State<PlaylistDetailsPage> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final functionsProvider =
      context.read<FunctionsForPlaylistDetailsProvider>();

      functionsProvider.reset();

      functionsProvider.loadDetails(
        id: widget.id,
        detailsProvider: context.read<PlaylistDetailsProvider>(),
      );
    });
  }

  @override
  void didUpdateWidget(
      covariant PlaylistDetailsPage oldWidget,
      ) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.id != widget.id) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        final functionsProvider =
        context.read<FunctionsForPlaylistDetailsProvider>();

        functionsProvider.reset();

        functionsProvider.loadDetails(
          id: widget.id,
          detailsProvider: context.read<PlaylistDetailsProvider>(),
        );
      });
    }
  }

  void _goBack() {
    Navigator.pop(
      context,
      context
          .read<FunctionsForPlaylistDetailsProvider>()
          .subscriptionChanged,
    );
  }

  void _openHomePage() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const MainNavigationPage(),
      ),
          (route) => false,
    );
  }

  void _openVideos() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DisplayVideosPage(
          id: widget.id,
        ),
      ),
    );
  }

  Future<void> _subscribe() async {
    final subscribeProvider = context.read<SubscribeProvider>();
    final detailsProvider = context.read<PlaylistDetailsProvider>();
    final functionsProvider =
    context.read<FunctionsForPlaylistDetailsProvider>();

    final bool success = await functionsProvider.subscribe(
      id: widget.id,
      subscribeProvider: subscribeProvider,
      detailsProvider: detailsProvider,
    );

    if (!mounted) return;

    if (success) {
      _showMessage(
        message: 'تم الاشتراك في القائمة بنجاح',
        color: const Color(0xff2A9D8F),
      );
      return;
    }

    if (subscribeProvider.errorMessage != null) {
      _showMessage(
        message: subscribeProvider.errorMessage!,
        color: Colors.red,
      );
    }
  }

  Future<void> _submitRating({
    required BuildContext bottomSheetContext,
    required int rating,
  }) async {
    final ratingProvider = context.read<RatingPlaylistProvider>();
    final detailsProvider = context.read<PlaylistDetailsProvider>();
    final functionsProvider =
    context.read<FunctionsForPlaylistDetailsProvider>();

    final bool success = await functionsProvider.submitRating(
      id: widget.id,
      rating: rating,
      ratingProvider: ratingProvider,
      detailsProvider: detailsProvider,
    );

    if (!mounted) return;

    if (success) {
      if (Navigator.canPop(bottomSheetContext)) {
        Navigator.pop(bottomSheetContext);
      }

      _showMessage(
        message: 'تم إرسال تقييمك بنجاح',
        color: const Color(0xff2A9D8F),
      );
      return;
    }

    if (ratingProvider.errorMessage != null) {
      _showMessage(
        message: ratingProvider.errorMessage!,
        color: Colors.red,
      );
    }
  }

  void _openRatingBottomSheet() {
    final detailsProvider =
    context.read<PlaylistDetailsProvider>();

    final validationMessage = context
        .read<FunctionsForPlaylistDetailsProvider>()
        .ratingValidationMessage(detailsProvider);

    if (validationMessage != null) {
      _showMessage(
        message: validationMessage,
        color: Colors.orange,
      );
      return;
    }

    int tempRating = 0;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (bottomSheetContext) {
        return StatefulBuilder(
          builder: (
              context,
              setBottomSheetState,
              ) {
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
                        borderRadius: BorderRadius.circular(10),
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
                          final starValue =
                              index + 1;

                          return IconButton(
                            onPressed: () {
                              setBottomSheetState(() {
                                tempRating =
                                    starValue;
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

                    Consumer<RatingPlaylistProvider>(
                      builder: (
                          context,
                          ratingProvider,
                          child,
                          ) {
                        return SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed:
                            tempRating == 0 ||
                                ratingProvider.isLoading
                                ? null
                                : () {
                              _submitRating(
                                bottomSheetContext:
                                bottomSheetContext,
                                rating:
                                tempRating,
                              );
                            },
                            style:
                            ElevatedButton.styleFrom(
                              backgroundColor:
                              const Color(0xff2A9D8F),
                              disabledBackgroundColor:
                              Colors.grey.shade300,
                              shape:
                              RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(14),
                              ),
                            ),
                            child:
                            ratingProvider.isLoading
                                ? const SizedBox(
                              width: 22,
                              height: 22,
                              child:
                              CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                                : const Text(
                              'إرسال التقييم',
                              style: TextStyle(
                                fontFamily:
                                'Tajawal',
                                fontSize: 16,
                                fontWeight:
                                FontWeight.bold,
                                color:
                                Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
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

  void _showMessage({
    required String message,
    required Color color,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              fontFamily: 'Tajawal',
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: color,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (
          didPop,
          result,
          ) {
        if (!didPop) {
          _goBack();
        }
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Consumer<PlaylistDetailsProvider>(
            builder: (
                context,
                detailsProvider,
                child,
                ) {
              if (detailsProvider.isLoading &&
                  detailsProvider.playListDetails == null) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xff2A9D8F),
                  ),
                );
              }

              if (detailsProvider.errorMessage != null &&
                  detailsProvider.playListDetails == null) {
                return SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding:
                        const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: _goBack,
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons
                                        .arrow_back_ios_new_rounded,
                                    color:
                                    Color(0xff2A9D8F),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    'تفاصيل قائمة التشغيل',
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
                                ],
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: _openHomePage,
                              icon: const Icon(
                                Icons.home_outlined,
                                color:
                                Color(0xff2A9D8F),
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Expanded(
                        child: Center(
                          child: Padding(
                            padding:
                            const EdgeInsets.all(24),
                            child: Column(
                              mainAxisSize:
                              MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  size: 65,
                                  color: Colors.red,
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Text(
                                  detailsProvider.errorMessage!,
                                  textAlign:
                                  TextAlign.center,
                                  style:
                                  const TextStyle(
                                    fontFamily:
                                    'Tajawal',
                                    fontSize: 16,
                                    color: Color(
                                      0xff264653,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    detailsProvider
                                        .refreshDetails(
                                      id: widget.id,
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.refresh,
                                  ),
                                  label: const Text(
                                    'إعادة المحاولة',
                                  ),
                                  style:
                                  ElevatedButton.styleFrom(
                                    backgroundColor:
                                    const Color(
                                      0xff2A9D8F,
                                    ),
                                    foregroundColor:
                                    Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              final course =
                  detailsProvider.playListDetails;

              if (course == null) {
                return const Center(
                  child: Text(
                    'لا توجد تفاصيل متاحة',
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff264653),
                    ),
                  ),
                );
              }

              final bool alreadyRated =
                  detailsProvider.alreadyRated;

              return Stack(
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
                                  onTap: _goBack,
                                  borderRadius:
                                  BorderRadius.circular(12),
                                  child: const Padding(
                                    padding:
                                    EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 6,
                                    ),
                                    child: Row(
                                      mainAxisSize:
                                      MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons
                                              .arrow_back_ios_new_rounded,
                                          textDirection:
                                          TextDirection.rtl,
                                          color: Color(
                                            0xff2A9D8F,
                                          ),
                                          size: 20,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          'تفاصيل قائمة التشغيل',
                                          style: TextStyle(
                                            fontWeight:
                                            FontWeight.bold,
                                            color: Color(
                                              0xff2A9D8F,
                                            ),
                                            fontFamily:
                                            'Tajawal',
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                const Spacer(),

                                IconButton(
                                  onPressed: _openHomePage,
                                  icon: const Icon(
                                    Icons.home_outlined,
                                    color: Color(
                                      0xff2A9D8F,
                                    ),
                                    size: 30,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Expanded(
                          child: RefreshIndicator(
                            color: const Color(
                              0xff2A9D8F,
                            ),
                            onRefresh: () {
                              return detailsProvider
                                  .refreshDetails(
                                id: widget.id,
                              );
                            },
                            child:
                            SingleChildScrollView(
                              physics:
                              const AlwaysScrollableScrollPhysics(),
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
                                    const EdgeInsets.all(20),
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
                                            color: Colors.white
                                                .withValues(
                                              alpha: 0.18,
                                            ),
                                            shape:
                                            BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons
                                                .school_outlined,
                                            size: 35,
                                            color: Colors.white,
                                          ),
                                        ),

                                        const SizedBox(
                                          height: 14,
                                        ),

                                        Text(
                                          course.name,
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
                                            color: Colors.white,
                                          ),
                                        ),

                                        const SizedBox(
                                          height: 10,
                                        ),

                                        Container(
                                          padding:
                                          const EdgeInsets
                                              .symmetric(
                                            horizontal: 14,
                                            vertical: 7,
                                          ),
                                          decoration:
                                          BoxDecoration(
                                            color: Colors.white
                                                .withValues(
                                              alpha: 0.18,
                                            ),
                                            borderRadius:
                                            BorderRadius
                                                .circular(
                                              20,
                                            ),
                                          ),
                                          child: Text(
                                            course.category,
                                            style:
                                            const TextStyle(
                                              fontFamily:
                                              'Tajawal',
                                              fontSize: 16,
                                              fontWeight:
                                              FontWeight.bold,
                                              color:
                                              Colors.white,
                                            ),
                                          ),
                                        ),

                                        const SizedBox(
                                          height: 14,
                                        ),

                                        Wrap(
                                          alignment:
                                          WrapAlignment.center,
                                          spacing: 14,
                                          runSpacing: 10,
                                          children: [
                                            Container(
                                              padding:
                                              const EdgeInsets
                                                  .symmetric(
                                                horizontal: 14,
                                                vertical: 8,
                                              ),
                                              decoration:
                                              BoxDecoration(
                                                color: detailsProvider
                                                    .isSubscribed
                                                    ? Colors.white
                                                    : Colors.white
                                                    .withValues(
                                                  alpha: 0.16,
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
                                                  Icon(
                                                    detailsProvider
                                                        .isSubscribed
                                                        ? Icons
                                                        .check_circle_rounded
                                                        : Icons
                                                        .lock_open_rounded,
                                                    size: 19,
                                                    color: detailsProvider
                                                        .isSubscribed
                                                        ? const Color(
                                                      0xff2A9D8F,
                                                    )
                                                        : Colors.white,
                                                  ),
                                                  const SizedBox(
                                                    width: 7,
                                                  ),
                                                  Text(
                                                    detailsProvider
                                                        .isSubscribed
                                                        ? 'مشترك'
                                                        : 'غير مشترك',
                                                    style:
                                                    TextStyle(
                                                      fontFamily:
                                                      'Tajawal',
                                                      fontSize: 16,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: detailsProvider
                                                          .isSubscribed
                                                          ? const Color(
                                                        0xff2A9D8F,
                                                      )
                                                          : Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
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
                                                const Color(
                                                  0xff264653,
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
                                                        .payments_outlined,
                                                    color:
                                                    Colors.white,
                                                    size: 18,
                                                  ),
                                                  const SizedBox(
                                                    width: 8,
                                                  ),
                                                  Text(
                                                    '${detailsProvider.formatPrice(course.price)} ل.س',
                                                    style:
                                                    const TextStyle(
                                                      fontFamily:
                                                      'Tajawal',
                                                      fontSize: 16,
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
                                    const EdgeInsets.all(18),
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
                                      border: Border.all(
                                        color:
                                        const Color(
                                          0xffDDEDEA,
                                        ),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
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
                                            SizedBox(width: 8),
                                            Text(
                                              'وصف قائمة التشغيل',
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
                                          course.description
                                              .trim()
                                              .isEmpty
                                              ? 'لا يوجد وصف'
                                              : course.description,
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
                                    childAspectRatio: 1.35,
                                    shrinkWrap: true,
                                    physics:
                                    const NeverScrollableScrollPhysics(),
                                    children: [
                                      StatisticCard(
                                        icon: Icons
                                            .play_circle_outline,
                                        title: 'الفيديوهات',
                                        value:
                                        '${course.totalVideoCount}',
                                      ),

                                      StatisticCard(
                                        icon: Icons
                                            .schedule_rounded,
                                        title:
                                        'إجمالي المدة',
                                        value: detailsProvider
                                            .formatDuration(
                                          course.totalDuration,
                                        ),
                                      ),

                                      StatisticCard(
                                        icon: Icons
                                            .people_outline_rounded,
                                        title:
                                        'عدد الطلاب',
                                        value:
                                        '${course.studentsCount}',
                                      ),

                                      StatisticCard(
                                        icon: Icons
                                            .trending_up_rounded,
                                        title:
                                        'معدل الإنجاز',
                                        value:
                                        '${detailsProvider.formatNumber(course.completionRate)}%',
                                      ),

                                      StatisticCard(
                                        icon:
                                        Icons.star_rounded,
                                        title: 'التقييم',
                                        value: detailsProvider.playListDetails!.userRating == null
                                            ? 'لم تقيّم بعد'
                                            : detailsProvider.playListDetails!.userRating.toString(),                                        iconColor:
                                      Colors.amber,
                                      ),

                                      StatisticCard(
                                        icon: detailsProvider
                                            .isSubscribed
                                            ? Icons
                                            .check_circle_rounded
                                            : Icons
                                            .lock_outline_rounded,
                                        title:
                                        'حالة الاشتراك',
                                        value: detailsProvider
                                            .isSubscribed
                                            ? 'مشترك'
                                            : 'غير مشترك',
                                        iconColor:
                                        detailsProvider
                                            .isSubscribed
                                            ? const Color(
                                          0xff2A9D8F,
                                        )
                                            : Colors.orange,
                                      ),
                                    ],
                                  ),

                                  const SizedBox(
                                    height: 22,
                                  ),

                                  Consumer<SubscribeProvider>(
                                    builder: (
                                        context,
                                        subscribeProvider,
                                        child,
                                        ) {
                                      return SizedBox(
                                        width:
                                        double.infinity,
                                        height: 55,
                                        child:
                                        ElevatedButton.icon(
                                          onPressed:
                                          detailsProvider
                                              .isSubscribed ||
                                              subscribeProvider
                                                  .isLoading
                                              ? null
                                              : _subscribe,
                                          icon: subscribeProvider
                                              .isLoading
                                              ? const SizedBox(
                                            width: 21,
                                            height: 21,
                                            child:
                                            CircularProgressIndicator(
                                              strokeWidth: 2.5,
                                              color:
                                              Colors.white,
                                            ),
                                          )
                                              : Icon(
                                            detailsProvider
                                                .isSubscribed
                                                ? Icons
                                                .check_circle_rounded
                                                : Icons
                                                .person_add_alt_1_rounded,
                                          ),
                                          label: Text(
                                            subscribeProvider
                                                .isLoading
                                                ? 'جارٍ الاشتراك...'
                                                : detailsProvider
                                                .isSubscribed
                                                ? 'تم الاشتراك'
                                                : 'اشتراك',
                                          ),
                                          style:
                                          ElevatedButton.styleFrom(
                                            backgroundColor:
                                            const Color(
                                              0xff2A9D8F,
                                            ),
                                            disabledBackgroundColor:
                                            detailsProvider
                                                .isSubscribed
                                                ? const Color(
                                              0xffB7DED8,
                                            )
                                                : const Color(
                                              0xff2A9D8F,
                                            ),
                                            foregroundColor:
                                            Colors.white,
                                            disabledForegroundColor:
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
                                              fontSize: 16,
                                              fontWeight:
                                              FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),

                                  const SizedBox(
                                    height: 12,
                                  ),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: SizedBox(
                                          height: 52,
                                          child:
                                          ElevatedButton.icon(
                                            onPressed:
                                            detailsProvider
                                                .canRate
                                                ? _openRatingBottomSheet
                                                : null,
                                            icon: Icon(
                                              alreadyRated
                                                  ? Icons
                                                  .check_circle_rounded
                                                  : Icons
                                                  .star_outline_rounded,
                                            ),
                                            label: Text(
                                              alreadyRated
                                                  ? 'تم التقييم'
                                                  : 'تقييم',
                                            ),
                                            style:
                                            ElevatedButton.styleFrom(
                                              backgroundColor:
                                              const Color(
                                                0xff264653,
                                              ),
                                              disabledBackgroundColor:
                                              alreadyRated
                                                  ? const Color(
                                                0xffB7DED8,
                                              )
                                                  : Colors.grey
                                                  .shade400,
                                              foregroundColor:
                                              Colors.white,
                                              disabledForegroundColor:
                                              alreadyRated
                                                  ? const Color(
                                                0xff264653,
                                              )
                                                  : Colors.white,
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
                                                fontSize: 12,
                                                fontWeight:
                                                FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                      const SizedBox(
                                        width: 12,
                                      ),

                                      Expanded(
                                        child: SizedBox(
                                          height: 52,
                                          child:
                                          ElevatedButton.icon(
                                            onPressed:
                                            detailsProvider
                                                .canOpenVideos
                                                ? _openVideos
                                                : null,
                                            icon: const Icon(
                                              Icons
                                                  .play_circle_outline_rounded,
                                            ),
                                            label:
                                            const Text(
                                              'عرض الفيديوهات',
                                            ),
                                            style:
                                            ElevatedButton.styleFrom(
                                              backgroundColor:
                                              const Color(
                                                0xff264653,
                                              ),
                                              disabledBackgroundColor:
                                              Colors.grey
                                                  .shade400,
                                              foregroundColor:
                                              Colors.white,
                                              disabledForegroundColor:
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
                                                fontSize: 12,
                                                fontWeight:
                                                FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  if (!detailsProvider
                                      .isSubscribed)
                                    const Padding(
                                      padding:
                                      EdgeInsets.only(
                                        top: 10,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons
                                                .lock_outline_rounded,
                                            size: 18,
                                            color: Color(
                                              0xff264653,
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          Flexible(
                                            child: Text(
                                              'يجب الاشتراك حتى تتمكن من مشاهدة الفيديوهات وتقييم القائمة',
                                              textAlign:
                                              TextAlign.center,
                                              style:
                                              TextStyle(
                                                fontFamily:
                                                'Tajawal',
                                                fontSize: 12,
                                                color:
                                                Color(
                                                  0xff264653,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                  if (detailsProvider
                                      .isSubscribed &&
                                      alreadyRated)
                                    Padding(
                                      padding:
                                      const EdgeInsets.only(
                                        top: 10,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons
                                                .check_circle_rounded,
                                            size: 18,
                                            color:
                                            Color(
                                              0xff2A9D8F,
                                            ),
                                          ),

                                          const SizedBox(
                                            width: 5,
                                          ),

                                          Flexible(
                                            child: Text(
                                              'لقد قيّمت قائمة التشغيل بـ ${detailsProvider.formattedRating}',
                                              textAlign:
                                              TextAlign.center,
                                              style:
                                              const TextStyle(
                                                fontFamily:
                                                'Tajawal',
                                                fontSize: 12,
                                                fontWeight:
                                                FontWeight.bold,
                                                color:
                                                Color(
                                                  0xff2A9D8F,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}