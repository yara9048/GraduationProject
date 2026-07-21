import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/summary_card_template.dart';

class SummaryPage extends StatelessWidget {
  const SummaryPage({super.key});

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
                    height: 100,
                    child: Stack(
                      children: [
                        Positioned(
                          top: 20,
                          right: 16,
                          child: IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              textDirection: TextDirection.rtl,
                              color: Color(0xff2A9D8F),
                              size: 30,
                            ),
                          ),
                        ),

                        const Positioned(
                          top: 20,
                          right: 70,
                          child: Text(
                            "مسار",
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

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Text(
                          "مقدمة في قانون أصول المحاكمات الجزائرية",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff181C1F),
                            fontFamily: "Tajawal",
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "ملخص الدرس",
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: "Tajawal",
                            color: Colors.grey,
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
                            const EdgeInsets.symmetric(horizontal: 20),
                            child: Container(
                              height: 35,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(.08),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const TabBar(
                                indicator: BoxDecoration(
                                  color: Color(0xff2A9D8F),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                                ),
                                indicatorSize: TabBarIndicatorSize.tab,
                                dividerColor: Colors.transparent,
                                labelColor: Colors.white,
                                unselectedLabelColor: Colors.grey,
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                tabs: [
                                  Tab(text: "ملخص أكاديمي"),
                                  Tab(text: "ملخص مبسط"),
                                  Tab(text: "خريطة ذهنية"),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          const Expanded(
                            child: TabBarView(
                              children: [
                                Padding(
                                  padding:
                                  EdgeInsets.symmetric(horizontal: 16),
                                  child: SummaryCard(),
                                ),

                                Center(
                                  child: Text(
                                    "ملخص مبسط",
                                    style: TextStyle(fontSize: 18,                              fontFamily: "Tajawal",
                                    ),
                                  ),
                                ),

                                Center(
                                  child: Text(
                                    "خريطة ذهنية",
                                    style: TextStyle(fontSize: 18,                              fontFamily: "Tajawal",
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}