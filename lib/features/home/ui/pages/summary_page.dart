import 'package:flutter/material.dart';
import 'package:graduationprojct/features/home/providers/ai_features_provider.dart';
import 'package:graduationprojct/features/home/ui/pages/video_details_page.dart';
import 'package:graduationprojct/features/home/ui/widgets/mind_map_card_template.dart';
import 'package:graduationprojct/features/home/ui/widgets/summary_card_template.dart';
import 'package:provider/provider.dart';

class SummaryPage extends StatefulWidget {
  final int id;
  final String name;
  final int playlistId;
  const SummaryPage({
    super.key,
    required this.id,
    required this.name,
    required this.playlistId
  });

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AiFeaturesProvider>().getAiFeatures(
        videoId: widget.id,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AiFeaturesProvider>();

    if (provider.isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(
            strokeWidth: 3,
            color: Color(0xff2A9D8F),
          ),
        ),
      );
    }

    if (provider.errorMessage != null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Text(
            provider.errorMessage!,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final academic =
    provider.getSummaryByType("academic");

    final simple =
    provider.getSummaryByType("simple");

    final mindMap =
    provider.getSummaryByType("mind_map");

    final String academicText = academic != null
        ? provider.getSummaryText(academic)
        : "";

    final String simpleText = simple != null
        ? provider.getSummaryText(simple)
        : "";

    final String mindMapUrl = mindMap != null
        ? provider.getMindMapUrl(mindMap)
        : "";

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
                    height: 100,
                    child: Stack(
                      children: [
                        Positioned(
                          top: 20,
                          right: 16,
                          child: IconButton(
                           onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context){return VideoDetailsPage(videoId: widget.id, videoName: widget.name, playlistId: widget.playlistId,);})),
                            icon: const Icon(
                              Icons
                                  .arrow_back_ios_new_rounded,
                              textDirection:
                              TextDirection.rtl,
                              color: Color(0xff2A9D8F),
                              size: 30,
                            ),
                          ),
                        ),
                        const Positioned(
                          top: 20,
                          right: 70,
                          child: Text(
                            "لمّاح ",
                            style: TextStyle(
                              fontSize: 43,
                              fontWeight:
                              FontWeight.bold,
                              color:
                              Color(0xff2A9D8F),
                              fontFamily: "Tajawal",
                              shadows: [
                                Shadow(
                                  offset:
                                  Offset(-1, 4),
                                  blurRadius: 16,
                                  color:
                                  Colors.black26,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Column(
                      children: [
                        Text(
                          widget.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight:
                            FontWeight.bold,
                            color:
                            Color(0xff181C1F),
                            fontFamily: "Tajawal",
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          "ملخص الدرس",
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: "Tajawal",
                            color:
                            Color(0xff1A2429),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: DefaultTabController(
                      length: 3,
                      child: Column(
                        children: [
                          Padding(
                            padding:
                            const EdgeInsets
                                .symmetric(
                              horizontal: 20,
                            ),
                            child: Container(
                              height: 40,
                              decoration:
                              BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                BorderRadius
                                    .circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black
                                        .withOpacity(.08),
                                    blurRadius: 10,
                                    offset:
                                    const Offset(
                                      0,
                                      4,
                                    ),
                                  ),
                                ],
                              ),
                              child: const TabBar(
                                indicator:
                                BoxDecoration(
                                  color:
                                  Color(0xff2A9D8F),
                                  borderRadius:
                                  BorderRadius.all(
                                    Radius.circular(25),
                                  ),
                                ),
                                indicatorSize:
                                TabBarIndicatorSize
                                    .tab,
                                dividerColor:
                                Colors.transparent,
                                labelColor:
                                Colors.white,
                                unselectedLabelColor:
                                Colors.grey,
                                labelStyle:
                                TextStyle(
                                  fontWeight:
                                  FontWeight.bold,
                                  fontSize: 12,
                                ),
                                tabs: [
                                  Tab(
                                    text:
                                    "ملخص أكاديمي",
                                  ),
                                  Tab(
                                    text:
                                    "ملخص مبسط",
                                  ),
                                  Tab(
                                    text:
                                    "خريطة ذهنية",
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Expanded(
                            child: TabBarView(
                              children: [
                                academicText.isNotEmpty
                                    ? SingleChildScrollView(
                                  padding:
                                  const EdgeInsets
                                      .only(
                                    bottom: 20,
                                  ),
                                  child:
                                  SummaryCard(
                                    data:
                                    academicText,
                                  ),
                                )
                                    : const Center(
                                  child: Text(
                                    "لا يوجد ملخص أكاديمي",
                                  ),
                                ),
                                simpleText.isNotEmpty
                                    ? SingleChildScrollView(
                                  padding:
                                  const EdgeInsets
                                      .only(
                                    bottom: 20,
                                  ),
                                  child:
                                  SummaryCard(
                                    data:
                                    simpleText,
                                  ),
                                )
                                    : const Center(
                                  child: Text(
                                    "لا يوجد ملخص مبسط",
                                  ),
                                ),
                                mindMapUrl.isNotEmpty
                                    ? SingleChildScrollView(
                                  padding:
                                  const EdgeInsets
                                      .only(
                                    bottom: 20,
                                  ),
                                  child:
                                  MindMapCard(
                                    svgUrl:
                                    mindMapUrl,
                                  ),
                                )
                                    : const Center(
                                  child: Text(
                                    "لا توجد خريطة ذهنية",
                                  ),
                                ),
                              ],
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
