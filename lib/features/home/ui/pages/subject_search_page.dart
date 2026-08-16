import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../auth/ui/widgets/text_field_template.dart';
import '../../providers/subject_search_provider.dart';
import '../widgets/subjects_card_template.dart';
import 'main_navigation_page.dart';

class SubjectSearchPage extends StatefulWidget {
  const SubjectSearchPage({
    super.key,
  });

  @override
  State<SubjectSearchPage> createState() =>
      _SubjectSearchPageState();
}

class _SubjectSearchPageState
    extends State<SubjectSearchPage> {
  final TextEditingController controller =
  TextEditingController();

  bool hasSearched = false;

  final List<String> subjectImages = const [
    'assets/Images/Group 42.png',
    'assets/Images/Group 48.png',
    'assets/Images/Group 47.png',
  ];

  final List<Color> subjectColors = const [
    Color(0xffE76F51),
    Color(0xff2A9D8F),
    Color(0xffA67500),
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      controller.clear();

      context
          .read<SubjectSearchProvider>()
          .resetSearch();

      setState(() {
        hasSearched = false;
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void search() {
    final String query =
    controller.text.trim();

    if (query.isEmpty) {
      context
          .read<SubjectSearchProvider>()
          .resetSearch();

      setState(() {
        hasSearched = false;
      });

      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      hasSearched = true;
    });

    context
        .read<SubjectSearchProvider>()
        .subjectSearch(
      query: query,
    );
  }

  void closeSearchPage() {
    controller.clear();

    context
        .read<SubjectSearchProvider>()
        .resetSearch();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
        const MainNavigationPage(),
      ),
    );
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
              ),
            ),

            SafeArea(
              child: Column(
                children: [
                  // ============================
                  // Header
                  // ============================

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
                            onTap: closeSearchPage,
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
                              child: Row(
                                mainAxisSize:
                                MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons
                                        .arrow_back_ios_new_rounded,
                                    textDirection:
                                    TextDirection.rtl,
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
                                    'البحث عن مادة',
                                    style:
                                    TextStyle(
                                      fontWeight:
                                      FontWeight.bold,
                                      color:
                                      Color(
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
                        ],
                      ),
                    ),
                  ),

                  // ============================
                  // Search
                  // ============================

                  Padding(
                    padding:
                    const EdgeInsets.only(
                      top: 8,
                      bottom: 10,
                    ),
                    child: TextFieldTemplate(
                      hint:
                      'ابحث عن مادة',
                      size: 20,
                      size2: 21,
                      icon: Icons.search,
                      controller: controller,
                      onSubmitted: (_) {
                        search();
                      },
                    ),
                  ),

                  // ============================
                  // Results
                  // ============================

                  Expanded(
                    child:
                    Consumer<SubjectSearchProvider>(
                      builder: (
                          context,
                          provider,
                          child,
                          ) {
                        if (provider.isLoading) {
                          return const Center(
                            child: SizedBox(
                              width: 32,
                              height: 32,
                              child:
                              CircularProgressIndicator(
                                strokeWidth: 3,
                                color:
                                Color(
                                  0xff2A9D8F,
                                ),
                              ),
                            ),
                          );
                        }

                        if (provider.errorMessage !=
                            null) {
                          return _buildErrorState(
                            provider.errorMessage!,
                          );
                        }

                        if (!hasSearched) {
                          return _buildInitialState();
                        }

                        if (provider.subjects.isEmpty) {
                          return _buildEmptyState();
                        }

                        return RefreshIndicator(
                          color:
                          const Color(
                            0xff2A9D8F,
                          ),
                          onRefresh: () async {
                            search();
                          },
                          child: MediaQuery.removePadding(
                            removeTop: true,
                            context: context,
                            child: ListView.builder(
                              physics:
                              const AlwaysScrollableScrollPhysics(),
                              keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior
                                  .onDrag,
                              padding:
                              const EdgeInsets.fromLTRB(
                                20,
                                10,
                                20,
                                30,
                              ),
                              itemCount:
                              provider.subjects.length,
                              itemBuilder:
                                  (context, index) {
                                final sub =
                                provider.subjects[
                                index];

                                return Padding(
                                  padding:
                                  const EdgeInsets.only(
                                    bottom: 12,
                                  ),
                                  child: SizedBox(
                                    height: 90,
                                    child:
                                    SubjectsCard(
                                      title:
                                      sub.name,
                                      imagePath:
                                      subjectImages[
                                      index %
                                          subjectImages
                                              .length
                                      ],
                                      textColor:
                                      subjectColors[
                                      index %
                                          subjectColors
                                              .length
                                      ],
                                      width: 300,
                                      top: 10,
                                      width2: 250,
                                      fit:
                                      BoxFit.fitWidth,
                                      id: sub.id,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
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

  Widget _buildInitialState() {
    return Padding(
      padding:
      const EdgeInsets.only(
        bottom: 150,
      ),
      child: Center(
        child: Column(
          mainAxisSize:
          MainAxisSize.min,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration:
              BoxDecoration(
                color:
                const Color(
                  0xff2A9D8F,
                ).withValues(
                  alpha: 0.10,
                ),
                shape:
                BoxShape.circle,
              ),
              child:
              const Icon(
                Icons
                    .menu_book_rounded,
                size: 46,
                color:
                Color(
                  0xff2A9D8F,
                ),
              ),
            ),

            const SizedBox(
              height: 18,
            ),

            const Text(
              'ابحث عن المادة',
              textAlign:
              TextAlign.center,
              style:
              TextStyle(
                fontFamily:
                'Tajawal',
                fontSize: 19,
                fontWeight:
                FontWeight.bold,
                color:
                Color(
                  0xff264653,
                ),
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            const Text(
              'اكتب اسم المادة التي تريد الوصول إليها.',
              textAlign:
              TextAlign.center,
              style:
              TextStyle(
                fontFamily:
                'Tajawal',
                fontSize: 14,
                height: 1.6,
                color:
                Color(
                  0xff6C7A7A,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding:
        const EdgeInsets.symmetric(
          horizontal: 30,
        ),
        child: Column(
          mainAxisSize:
          MainAxisSize.min,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration:
              BoxDecoration(
                color:
                const Color(
                  0xffE9C46A,
                ).withValues(
                  alpha: 0.16,
                ),
                shape:
                BoxShape.circle,
              ),
              child:
              const Icon(
                Icons
                    .search_off_rounded,
                size: 48,
                color:
                Color(
                  0xffA67500,
                ),
              ),
            ),

            const SizedBox(
              height: 18,
            ),

            const Text(
              'لا توجد نتائج',
              style:
              TextStyle(
                fontFamily:
                'Tajawal',
                fontSize: 19,
                fontWeight:
                FontWeight.bold,
                color:
                Color(
                  0xff264653,
                ),
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            const Text(
              'لم نعثر على مادة مطابقة لبحثك، جرّب كلمة أخرى.',
              textAlign:
              TextAlign.center,
              style:
              TextStyle(
                fontFamily:
                'Tajawal',
                fontSize: 14,
                height: 1.6,
                color:
                Color(
                  0xff6C7A7A,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(
      String error,
      ) {
    return Center(
      child: Padding(
        padding:
        const EdgeInsets.symmetric(
          horizontal: 30,
        ),
        child: Column(
          mainAxisSize:
          MainAxisSize.min,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration:
              BoxDecoration(
                color:
                Colors.red
                    .withValues(
                  alpha: 0.10,
                ),
                shape:
                BoxShape.circle,
              ),
              child:
              const Icon(
                Icons
                    .error_outline_rounded,
                size: 48,
                color:
                Colors.red,
              ),
            ),

            const SizedBox(
              height: 18,
            ),

            const Text(
              'تعذر تنفيذ البحث',
              textAlign:
              TextAlign.center,
              style:
              TextStyle(
                fontFamily:
                'Tajawal',
                fontSize: 19,
                fontWeight:
                FontWeight.bold,
                color:
                Color(
                  0xff264653,
                ),
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            Text(
              error,
              textAlign:
              TextAlign.center,
              style:
              const TextStyle(
                fontFamily:
                'Tajawal',
                fontSize: 13,
                height: 1.5,
                color:
                Color(
                  0xff6C7A7A,
                ),
              ),
            ),

            const SizedBox(
              height: 18,
            ),

            OutlinedButton.icon(
              onPressed: search,
              icon:
              const Icon(
                Icons
                    .refresh_rounded,
                color:
                Color(
                  0xff2A9D8F,
                ),
              ),
              label:
              const Text(
                'إعادة المحاولة',
                style:
                TextStyle(
                  fontFamily:
                  'Tajawal',
                  fontWeight:
                  FontWeight.bold,
                  color:
                  Color(
                    0xff2A9D8F,
                  ),
                ),
              ),
              style:
              OutlinedButton
                  .styleFrom(
                side:
                const BorderSide(
                  color:
                  Color(
                    0xff2A9D8F,
                  ),
                ),
                shape:
                RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(
                    14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}