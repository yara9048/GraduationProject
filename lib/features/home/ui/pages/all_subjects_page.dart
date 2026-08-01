import 'package:flutter/material.dart';
import 'package:graduationprojct/features/home/ui/pages/main_navigation_page.dart';
import 'package:graduationprojct/features/home/ui/pages/subject_search_page.dart';
import 'package:graduationprojct/features/home/ui/widgets/subjects_card_template.dart';
import 'package:provider/provider.dart';

import '../../providers/display_subjects_provider.dart';

class AllSubjectsPage extends StatefulWidget {
  const AllSubjectsPage({super.key});

  @override
  State<AllSubjectsPage> createState() => _AllSubjectsPageState();
}

class _AllSubjectsPageState extends State<AllSubjectsPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DisplaySubjectsProvider>().getSubjects();

    });
  }
  Widget build(BuildContext context) {
    final subjectsProvider = context.watch<DisplaySubjectsProvider>();
    final subjects = subjectsProvider.subjects;
    final List<String> subjectImages = [
      'assets/Images/Group 51.png',
      'assets/Images/Group 52.png',
    ];
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        child: Column(
          children: [
            SizedBox(
              height: 150,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Image.asset('assets/Images/Ellipse 4.png'),
                  ),
                  Positioned(
                    top: 50,
                    left: 8,
                    child: IconButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context){return SubjectSearchPage();}));},
                      icon: Icon(
                        Icons.search,
                        color: const Color(0xff2A9D8F),
                        size: 30,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 55,
                    right: 16,
                    child: IconButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context){return MainNavigationPage();})),
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        textDirection: TextDirection.rtl,
                        color: Color(0xff2A9D8F),
                        size: 30,
                      ),
                    ),
                  ),

                  Positioned(
                    top: 50,
                    right: 70,
                    child: Text(
                      "لمّاح ",
                      style: TextStyle(
                        fontSize: 43,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff2A9D8F),
                        fontFamily: "Tajawal",
                        shadows: [
                          Shadow(
                            offset: Offset(-1, 4),
                            blurRadius: 16,
                            color: Colors.black26,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: MediaQuery.removePadding(
                removeTop: true,
                context: context,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ListView.builder(
                            itemCount:subjects.length<3? subjects.length : 3,
                            itemBuilder: (context, index) {
                              final sub = subjects[index];
                              return SizedBox(
                                height: 90,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: SubjectsCard(
                                    title: sub.name,
                                    imagePath: subjectImages[
                                    index % subjectImages.length],
                                    textColor: Color(0xffA67500),
                                    width: 300,
                                    top: 10,
                                    width2: 250,
                                    fit: BoxFit.fitWidth, id: sub.id,
                                  ),
                                ),
                              );
                            },
                          ),
                        )),
                  )

          ],
        ),
      ),
    );
  }
}