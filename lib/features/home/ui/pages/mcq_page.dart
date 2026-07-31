import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationprojct/features/home/ui/pages/video_details_page.dart';
import 'package:provider/provider.dart';

import '../../providers/ai_features_provider.dart';

class McqScreen extends StatefulWidget {
  final int videoId;
  final String videoName;
  final int playlistId;
  const McqScreen({
    super.key,
    required this.videoName,
    required this.videoId,
    required this.playlistId,
  });

  @override
  State<McqScreen> createState() => _McqScreenState();
}

class _McqScreenState extends State<McqScreen> {
  int currentQuestion = 0;
  String? selectedAnswer;
  double progress = 0;
  final Map<int, String> userAnswers = {};

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AiFeaturesProvider>().getAiFeatures(videoId: widget.videoId);
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
      return Scaffold(body: Center(child: Text(provider.errorMessage!)));
    }

    if (provider.mcqs.isEmpty) {
      return const Scaffold(body: Center(child: Text("لا توجد أسئلة")));
    }

    final question = provider.mcqs[currentQuestion];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset('assets/Images/Ellipse 4.png'),
          ),

          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset('assets/Images/Ellipse 7.png'),
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
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return VideoDetailsPage(
                                  videoId: widget.videoId,
                                  videoName: widget.videoName,
                                  playlistId: widget.playlistId,
                                );
                              },
                            ),
                          ),
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
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "اختبار: ${widget.videoName}",
                              textDirection: TextDirection.rtl,
                              style: const TextStyle(
                                color: Color(0xff1A2429),
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                fontFamily: "Tajawal",
                              ),
                            ),

                            const SizedBox(height: 20),

                            Row(
                              children: [
                                Text(
                                  "${(progress * 100).toStringAsFixed(0)}%",
                                  style: const TextStyle(
                                    fontFamily: "Tajawal",
                                    color: Colors.teal,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  "السؤال ${currentQuestion + 1} من ${provider.mcqs.length}",
                                  style: const TextStyle(fontFamily: "Tajawal"),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: LinearProgressIndicator(
                                  value: progress,
                                  minHeight: 8,
                                  borderRadius: BorderRadius.circular(20),
                                  backgroundColor: const Color(0xffE0E0E0),
                                  valueColor: const AlwaysStoppedAnimation(
                                    Color(0xff2A9D8F),
                                  ),
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
                                    Text(
                                      question.question,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Tajawal",
                                      ),
                                    ),

                                    const SizedBox(height: 20),

                                    ...question.options.map((option) {
                                      final selected = selectedAnswer == option;

                                      return Container(
                                        margin: const EdgeInsets.only(
                                          bottom: 18,
                                        ),
                                        decoration: BoxDecoration(
                                          color: selected
                                              ? const Color(
                                                  0xff2A9D8F,
                                                ).withOpacity(0.09)
                                              : Colors.white,
                                          border: Border.all(
                                            color: selected
                                                ? const Color(0xff2A9D8F)
                                                : Colors.grey.shade300,
                                            width: 2.2,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                        ),
                                        child: RadioListTile<String>(
                                          value: option,
                                          groupValue: selectedAnswer,
                                          radioScaleFactor: 1.3,
                                          fillColor:
                                              WidgetStateProperty.resolveWith<
                                                Color
                                              >((states) {
                                                if (states.contains(
                                                  WidgetState.selected,
                                                )) {
                                                  return const Color(
                                                    0xff2A9D8F,
                                                  );
                                                }
                                                return const Color(0xffB8C1D1);
                                              }),
                                          activeColor: const Color(0xff2A9D8F),
                                          title: Text(
                                            option,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: "Tajawal",
                                              fontWeight: selected
                                                  ? FontWeight.bold
                                                  : FontWeight.w500,
                                              color: const Color(0xff181C1F),
                                            ),
                                          ),
                                          controlAffinity:
                                              ListTileControlAffinity.trailing,
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
                                  onPressed: selectedAnswer == null
                                      ? null
                                      : () {
                                          userAnswers[question.id] =
                                              selectedAnswer!;

                                          if (currentQuestion <
                                              provider.mcqs.length - 1) {
                                            setState(() {
                                              currentQuestion++;
                                              progress =
                                                  currentQuestion /
                                                  provider.mcqs.length;

                                              selectedAnswer =
                                                  userAnswers[provider
                                                      .mcqs[currentQuestion]
                                                      .id];
                                            });
                                          } else {
                                            setState(() {
                                              progress = 1;
                                            });
                                            int score = 0;

                                            for (final q in provider.mcqs) {
                                              if (userAnswers[q.id] ==
                                                  q.answer) {
                                                score++;
                                              }
                                            }
                                            String message;

                                            if (score == provider.mcqs.length) {
                                              message =
                                                  "ممتاز! أجبت على جميع الأسئلة بشكل صحيح";
                                            } else if (score >=
                                                provider.mcqs.length / 2) {
                                              message =
                                                  "أحسنت! أجبت على $score من ${provider.mcqs.length} بشكل صحيح";
                                            } else {
                                              message =
                                                  "لا بأس، أجبت على $score من ${provider.mcqs.length} بشكل صحيح. حاول مرة أخرى 💪";
                                            }

                                            final isCorrect =
                                                selectedAnswer ==
                                                question.answer;
                                            showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (_) => Dialog(
                                                backgroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(24),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                    24,
                                                  ),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Container(
                                                        width: 80,
                                                        height: 80,
                                                        decoration: BoxDecoration(
                                                          color: isCorrect
                                                              ? Colors.green
                                                                    .withOpacity(
                                                                      .12,
                                                                    )
                                                              : Colors.red
                                                                    .withOpacity(
                                                                      .12,
                                                                    ),
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                        child: Icon(
                                                          isCorrect
                                                              ? Icons
                                                                    .check_circle_rounded
                                                              : Icons
                                                                    .cancel_rounded,
                                                          size: 60,
                                                          color: isCorrect
                                                              ? Colors.green
                                                              : Colors.red,
                                                        ),
                                                      ),

                                                      const SizedBox(
                                                        height: 20,
                                                      ),

                                                      Text(
                                                        isCorrect
                                                            ? "أحسنت الاجابة صحيحة "
                                                            : "الاجابة خاطئة",
                                                        style: TextStyle(
                                                          fontFamily: "Tajawal",
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Color(
                                                            0xff1A2429,
                                                          ),
                                                        ),
                                                      ),

                                                      const SizedBox(
                                                        height: 10,
                                                      ),

                                                      Text(
                                                        message,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: const TextStyle(
                                                          fontFamily: "Tajawal",
                                                          fontSize: 16,
                                                          color: Colors.black87,
                                                        ),
                                                      ),

                                                      const SizedBox(
                                                        height: 25,
                                                      ),

                                                      LinearProgressIndicator(
                                                        value:
                                                            score /
                                                            provider
                                                                .mcqs
                                                                .length,
                                                        minHeight: 10,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              20,
                                                            ),
                                                        backgroundColor: Colors
                                                            .grey
                                                            .shade300,
                                                        valueColor:
                                                            const AlwaysStoppedAnimation(
                                                              Color(0xff2A9D8F),
                                                            ),
                                                      ),

                                                      const SizedBox(
                                                        height: 25,
                                                      ),

                                                      SizedBox(
                                                        width: double.infinity,
                                                        height: 50,
                                                        child: ElevatedButton(
                                                          style: ElevatedButton.styleFrom(
                                                            backgroundColor:
                                                                const Color(
                                                                  0xff2A9D8F,
                                                                ),
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    15,
                                                                  ),
                                                            ),
                                                          ),
                                                          onPressed: () => Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) {
                                                                return VideoDetailsPage(
                                                                  videoId: widget
                                                                      .videoId,
                                                                  videoName: widget
                                                                      .videoName,
                                                                  playlistId: widget
                                                                      .playlistId,
                                                                );
                                                              },
                                                            ),
                                                          ),

                                                          child: const Text(
                                                            "إنهاء",
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  "Tajawal",
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                  icon: const Icon(Icons.arrow_back),
                                  label: Text(
                                    currentQuestion == provider.mcqs.length - 1
                                        ? "إنهاء"
                                        : "التالي",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Tajawal",
                                      fontSize: 16,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xff2A9D8F),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
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
