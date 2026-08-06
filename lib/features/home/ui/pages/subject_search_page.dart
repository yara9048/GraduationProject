import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../auth/ui/widgets/text_field_template.dart';
import '../../providers/subject_search_provider.dart';
import '../widgets/subjects_card_template.dart';
import 'main_navigation_page.dart';

class SubjectSearchPage extends StatefulWidget {
  const SubjectSearchPage({super.key});

  @override
  State<SubjectSearchPage> createState() =>
      _SubjectSearchPageState();
}

class _SubjectSearchPageState
    extends State<SubjectSearchPage> {
  final TextEditingController controller =
  TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      controller.clear();

      context
          .read<SubjectSearchProvider>()
          .resetSearch();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void search() {
    final query = controller.text.trim();

    if (query.isEmpty) {
      context
          .read<SubjectSearchProvider>()
          .resetSearch();

      return;
    }

    FocusScope.of(context).unfocus();

    context
        .read<SubjectSearchProvider>()
        .subjectSearch(query: query);
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
    final List<String> subjectImages = [
      'assets/Images/Group 47.png',
      'assets/Images/Group 48.png',
      'assets/Images/Group 49.png',
    ];

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

            Positioned(
              top: 120,
              left: 10,
              right: 5,
              child: TextFieldTemplate(
                hint: 'ابحث هنا',
                size: 20,
                size2: 21,
                icon: Icons.search,
                controller: controller,
                onSubmitted: (_) {
                  search();
                },
              ),
            ),

            Positioned(
              top: 220,
              left: 15,
              right: 15,
              bottom: 20,
              child:
              Consumer<SubjectSearchProvider>(
                builder:
                    (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(
                      child:
                      CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xff2A9D8F),
                      ),
                    );
                  }

                  if (provider.errorMessage !=
                      null) {
                    return Center(
                      child: Text(
                        provider.errorMessage!,
                        style: const TextStyle(
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    );
                  }

                  if (controller.text
                      .trim()
                      .isEmpty) {
                    return const SizedBox.shrink();
                  }

                  if (provider.subjects.isEmpty) {
                    return const Center(
                      child: Text(
                        'لا يوجد نتائج',
                        style: TextStyle(
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    );
                  }

                  return MediaQuery.removePadding(
                    removeTop: true,
                    context: context,
                    child: Padding(
                      padding:
                      const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: ListView.builder(
                        keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior
                            .onDrag,
                        itemCount:
                        provider.subjects.length,
                        itemBuilder:
                            (context, index) {
                          final sub =
                          provider.subjects[
                          index];

                          return SizedBox(
                            height: 90,
                            child: Padding(
                              padding:
                              const EdgeInsets
                                  .only(
                                bottom: 10,
                              ),
                              child: SubjectsCard(
                                title: sub.name,
                                imagePath:
                                subjectImages[
                                index %
                                    subjectImages
                                        .length
                                ],
                                textColor:
                                const Color(
                                0xffA67500,
                              ),
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

            Positioned(
              top: 55,
              right: 16,
              child: InkWell(
                onTap: closeSearchPage,
                child: const Row(
                  children: [
                    Icon(
                      Icons
                          .arrow_back_ios_new_rounded,
                      color: Color(0xff2A9D8F),
                      size: 20,
                    ),
                    SizedBox(width: 20),
                    Text(
                      'البحث',
                      style: TextStyle(
                        fontWeight:
                        FontWeight.bold,
                        color:
                        Color(0xff2A9D8F),
                        fontFamily: 'Tajawal',
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}