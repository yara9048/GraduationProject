import 'package:flutter/material.dart';

class McqScreen extends StatefulWidget {
  const McqScreen({super.key});

  @override
  State<McqScreen> createState() => _McqScreenState();
}

class _McqScreenState extends State<McqScreen> {
  String? selectedAnswer = "قاضي التحقيق";

  final List<String> answers = [
    "النيابة العامة التمييزية",
    "قاضي التحقيق",
    "الضابطة العدلية",
    "المحكمة الابتدائية",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

                Expanded(
                  child: MediaQuery.removePadding(
                    removeTop: true,
                    context: context,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              "اختبار: قانون أصول المحاكمات الجزئية",
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                color: Color(0xff1A2429),
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),

                            const SizedBox(height: 20),

                            Row(
                              children: const [
                                Text(
                                  "20%",
                                  style: TextStyle(
                                    color: Colors.teal,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Spacer(),
                                Text("السؤال 1 من 10"),
                              ],
                            ),

                            const SizedBox(height: 10),

                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: const Directionality(
                                textDirection: TextDirection.rtl,
                                child: LinearProgressIndicator(
                                  value: 0.2,
                                  minHeight: 8,
                                  valueColor: AlwaysStoppedAnimation(
                                    Color(0xff2A9D8F),
                                  ),
                                  backgroundColor: Color(0xffE0E0E0),
                                ),
                              ),
                            ),

                            const SizedBox(height: 15),

                            Card(
                              color: Colors.white,
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    const Text(
                                      "ما هي الجهة المختصة بإصدار مذكرة التوقيف في الجنايات وفقاً لقانون أصول المحاكمات الجزائية؟",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Color(0xff181C1F),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 20),

                                    ...answers.map((answer) {
                                      final selected =
                                          selectedAnswer == answer;

                                      return Container(
                                        margin: const EdgeInsets.only(
                                            bottom: 18),
                                        decoration: BoxDecoration(
                                          color: selected
                                              ? const Color(0xff2A9D8F)
                                              .withOpacity(0.09)
                                              : Colors.white,
                                          border: Border.all(
                                            color: selected
                                                ? const Color(0xff2A9D8F)
                                                : Colors.grey.shade300,
                                            width: 2.2,
                                          ),
                                          borderRadius:
                                          BorderRadius.circular(14),
                                        ),
                                        child: RadioListTile<String>(
                                          value: answer,
                                          groupValue: selectedAnswer,
                                          radioScaleFactor: 1.3,
                                          fillColor:
                                          WidgetStateProperty.resolveWith<
                                              Color>((states) {
                                            if (states.contains(
                                                WidgetState.selected)) {
                                              return const Color(0xff2A9D8F);
                                            }
                                            return const Color(0xffB8C1D1);
                                          }),
                                          activeColor:
                                          const Color(0xff2A9D8F),
                                          title: Text(
                                            answer,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 19,
                                              fontWeight: selected
                                                  ? FontWeight.bold
                                                  : FontWeight.w500,
                                              color:
                                              const Color(0xff181C1F),
                                            ),
                                          ),
                                          controlAffinity:
                                          ListTileControlAffinity
                                              .trailing,
                                          onChanged: (value) {
                                            setState(() {
                                              selectedAnswer = value;
                                            });
                                          },
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 30),

                            Center(
                              child: SizedBox(
                                width: 240,
                                height: 52,
                                child: ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.arrow_back),
                                  label: const Text(
                                    "التالي",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Tajawal",
                                      fontSize: 18,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                    const Color(0xff2A9D8F),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(14),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}