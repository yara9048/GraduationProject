import 'package:flutter/material.dart';
import 'package:graduationprojct/features/home/providers/regenerate_mcq_provider.dart';
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

  final Map<int, String> userAnswers = {};

  // ============================================================
  // Init
  // ============================================================

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<AiFeaturesProvider>().getAiFeatures(
        videoId: widget.videoId,
      );
    });
  }

  // ============================================================
  // Reset quiz
  // ============================================================

  void _resetQuizState() {
    currentQuestion = 0;
    selectedAnswer = null;
    userAnswers.clear();
  }


  void _finishQuiz() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => VideoDetailsPage(
          videoId: widget.videoId,
          playlistId: widget.playlistId,
          videoName: widget.videoName,
        ),
      ),
    );
  }

  // ============================================================
  // Result Dialog
  // ============================================================

  void _showResultDialog({
    required int score,
    required int totalQuestions,
  }) {
    String message;

    if (score == totalQuestions) {
      message = "ممتاز! أجبت على جميع الأسئلة بشكل صحيح";
    } else if (score >= totalQuestions / 2) {
      message =
      "أحسنت! أجبت على $score من $totalQuestions بشكل صحيح";
    } else {
      message =
      "لا بأس، أجبت على $score من $totalQuestions بشكل صحيح. حاول مرة أخرى 💪";
    }

    final bool passed =
        score >= totalQuestions / 2;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // =================================================
                  // Result icon
                  // =================================================

                  Container(
                    width: 86,
                    height: 86,
                    decoration: BoxDecoration(
                      color:
                          const Color(0xff2A9D8F)
                          .withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      passed
                          ? Icons.check_circle_rounded
                          : Icons.quiz_rounded,
                      size: 62,
                      color: const Color(0xff2A9D8F)
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  // =================================================
                  // Title
                  // =================================================

                  const Text(
                    "نتيجة الاختبار",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "Tajawal",
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff1A2429),
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  // =================================================
                  // Score
                  // =================================================

                  Text(
                    "$score / $totalQuestions",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: "Tajawal",
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff2A9D8F),
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  // =================================================
                  // Message
                  // =================================================

                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: "Tajawal",
                      fontSize: 15,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  // =================================================
                  // Result progress
                  // =================================================

                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: LinearProgressIndicator(
                      value: totalQuestions == 0
                          ? 0
                          : score / totalQuestions,
                      minHeight: 10,
                      backgroundColor:
                      Colors.grey.shade300,
                      valueColor:
                      const AlwaysStoppedAnimation(
                        Color(0xff2A9D8F),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 26,
                  ),

                  // =================================================
                  // Regenerate button
                  // =================================================

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final mcqProvider =
                        context.read<RegenerateMcqProvider>();
                        await mcqProvider.regenerate(
                          videoId: widget.videoId,
                        );
                        if (!context.mounted) return;
                        if (mcqProvider.errorMessage != null) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            SnackBar(
                              content: Text(
                                mcqProvider.errorMessage!,
                              ),
                            ),
                          );

                          return;
                        }

                        final mcq =
                            mcqProvider.mcq;

                        if (mcq == null) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            const SnackBar(
                              content: Text(
                                'تعذر',
                              ),
                            ),
                          );

                          return;
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return VideoDetailsPage(
                                playlistId:  widget.playlistId, videoId: widget.videoId, videoName:  widget.videoName,
                              );
                            },
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        const Color(0xff2A9D8F),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(15),
                        ),
                      ),
                      icon: const Icon(
                        Icons.refresh_rounded,
                        color: Colors.white,
                        size: 23,
                      ),
                      label: const Text(
                        "اعادة توليد اسئلة",
                        style: TextStyle(
                          fontFamily: "Tajawal",
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  // =================================================
                  // Finish button
                  // =================================================

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton(
                      onPressed: _finishQuiz,
                      style: OutlinedButton.styleFrom(
                        foregroundColor:
                        const Color(0xff2A9D8F),
                        side: const BorderSide(
                          color: Color(0xff2A9D8F),
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        "إنهاء",
                        style: TextStyle(
                          fontFamily: "Tajawal",
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff2A9D8F),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // Next question
  // ============================================================

  void _nextQuestion(
      AiFeaturesProvider provider,
      ) {
    if (selectedAnswer == null) {
      return;
    }

    final question =
    provider.mcqs[currentQuestion];

    userAnswers[question.id] =
    selectedAnswer!;

    // ============================================================
    // More questions
    // ============================================================

    if (currentQuestion <
        provider.mcqs.length - 1) {
      setState(() {
        currentQuestion++;

        final nextQuestion =
        provider.mcqs[currentQuestion];

        selectedAnswer =
        userAnswers[nextQuestion.id];
      });

      return;
    }

    // ============================================================
    // Finished
    // ============================================================

    int score = 0;

    for (final q in provider.mcqs) {
      if (userAnswers[q.id] ==
          q.answer) {
        score++;
      }
    }

    _showResultDialog(
      score: score,
      totalQuestions:
      provider.mcqs.length,
    );
  }

  // ============================================================
  // Build
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final provider =
    context.watch<AiFeaturesProvider>();

    // ============================================================
    // Loading
    // ============================================================

    if (provider.isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child:
          CircularProgressIndicator(
            strokeWidth: 3,
            color: Color(
              0xff2A9D8F,
            ),
          ),
        ),
      );
    }

    // ============================================================
    // Error
    // ============================================================

    if (provider.errorMessage !=
        null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding:
            const EdgeInsets.all(
              24,
            ),
            child: Text(
              provider.errorMessage!,
              textAlign:
              TextAlign.center,
              style:
              const TextStyle(
                fontFamily:
                "Tajawal",
              ),
            ),
          ),
        ),
      );
    }

    // ============================================================
    // Empty
    // ============================================================

    if (provider.mcqs.isEmpty) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Text(
            "لا توجد أسئلة",
            style: TextStyle(
              fontFamily: "Tajawal",
            ),
          ),
        ),
      );
    }

    // ============================================================
    // Safety
    // ============================================================

    if (currentQuestion >=
        provider.mcqs.length) {
      currentQuestion = 0;
      selectedAnswer = null;
    }

    final question =
    provider.mcqs[currentQuestion];

    final double progress =
        (currentQuestion + 1) /
            provider.mcqs.length;

    // ============================================================
    // UI
    // ============================================================

    return Directionality(
      textDirection:
      TextDirection.rtl,
      child: Scaffold(
        backgroundColor:
        Colors.white,

        body: Stack(
          children: [
            // ======================================================
            // Background decoration
            // ======================================================

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

            // ======================================================
            // Content
            // ======================================================

            SafeArea(
              child: Column(
                children: [
                  // =================================================
                  // Header
                  // =================================================

                  SizedBox(
                    height: 100,
                    child: Stack(
                      children: [
                        Positioned(
                          top: 30,
                          right: 10,
                          child: InkWell(
                            onTap:
                            _finishQuiz,
                            borderRadius:
                            BorderRadius.circular(
                              12,
                            ),
                            child:
                            const Padding(
                              padding:
                              EdgeInsets.symmetric(
                                horizontal:
                                8,
                                vertical:
                                8,
                              ),
                              child: Row(
                                mainAxisSize:
                                MainAxisSize.min,
                                children: [
                                  Text(
                                    'اختبار الفيديو',
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
                                      fontSize:
                                      20,
                                    ),
                                  ),

                                  SizedBox(
                                    width:
                                    10,
                                  ),

                                  Icon(
                                    Icons
                                        .arrow_back_ios_new_rounded,
                                    textDirection:
                                    TextDirection.rtl,
                                    color:
                                    Color(
                                      0xff2A9D8F,
                                    ),
                                    size:
                                    20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // =================================================
                  // Scroll
                  // =================================================

                  Expanded(
                    child:
                    MediaQuery.removePadding(
                      removeTop: true,
                      context:
                      context,
                      child:
                      SingleChildScrollView(
                        physics:
                        const BouncingScrollPhysics(),
                        child:
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(
                            horizontal:
                            15,
                          ),
                          child:
                          Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.end,
                            children: [
                              // =====================================
                              // Progress text
                              // =====================================

                              Row(
                                children: [
                                  Text(
                                    "${(progress * 100).toStringAsFixed(0)}%",
                                    style:
                                    const TextStyle(
                                      fontFamily:
                                      "Tajawal",
                                      color:
                                      Color(
                                        0xff2A9D8F,
                                      ),
                                      fontWeight:
                                      FontWeight.bold,
                                    ),
                                  ),

                                  const Spacer(),

                                  Text(
                                    "السؤال ${currentQuestion + 1} من ${provider.mcqs.length}",
                                    style:
                                    const TextStyle(
                                      fontFamily:
                                      "Tajawal",
                                      fontWeight:
                                      FontWeight.w500,
                                      color:
                                      Color(
                                        0xff4D5A5D,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(
                                height:
                                10,
                              ),

                              // =====================================
                              // Progress
                              // =====================================

                              ClipRRect(
                                borderRadius:
                                BorderRadius.circular(
                                  20,
                                ),
                                child:
                                LinearProgressIndicator(
                                  value:
                                  progress,
                                  minHeight:
                                  8,
                                  backgroundColor:
                                  const Color(
                                    0xffE0E0E0,
                                  ),
                                  valueColor:
                                  const AlwaysStoppedAnimation(
                                    Color(
                                      0xff2A9D8F,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(
                                height:
                                20,
                              ),

                              // =====================================
                              // Question Card
                              // =====================================

                              Card(
                                color:
                                Colors.white,
                                elevation:
                                3,
                                surfaceTintColor:
                                Colors.white,
                                shape:
                                RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(
                                    20,
                                  ),
                                ),
                                child:
                                Padding(
                                  padding:
                                  const EdgeInsets.all(
                                    20,
                                  ),
                                  child:
                                  Column(
                                    children: [
                                      // =================================
                                      // Category
                                      // =================================

                                      if (question
                                          .category
                                          .trim()
                                          .isNotEmpty)
                                        Container(
                                          padding:
                                          const EdgeInsets.symmetric(
                                            horizontal:
                                            12,
                                            vertical:
                                            6,
                                          ),
                                          margin:
                                          const EdgeInsets.only(
                                            bottom:
                                            14,
                                          ),
                                          decoration:
                                          BoxDecoration(
                                            color:
                                            const Color(
                                              0xff2A9D8F,
                                            ).withOpacity(
                                              0.10,
                                            ),
                                            borderRadius:
                                            BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          child:
                                          Text(
                                            question
                                                .category,
                                            style:
                                            const TextStyle(
                                              fontFamily:
                                              "Tajawal",
                                              color:
                                              Color(
                                                0xff2A9D8F,
                                              ),
                                              fontWeight:
                                              FontWeight.bold,
                                              fontSize:
                                              12,
                                            ),
                                          ),
                                        ),

                                      // =================================
                                      // Question
                                      // =================================

                                      Text(
                                        question
                                            .question,
                                        textAlign:
                                        TextAlign.center,
                                        style:
                                        const TextStyle(
                                          fontSize:
                                          17,
                                          height:
                                          1.5,
                                          fontWeight:
                                          FontWeight.bold,
                                          fontFamily:
                                          "Tajawal",
                                          color:
                                          Color(
                                            0xff181C1F,
                                          ),
                                        ),
                                      ),

                                      const SizedBox(
                                        height:
                                        24,
                                      ),

                                      // =================================
                                      // Options
                                      // =================================

                                      ...question
                                          .options
                                          .map(
                                            (
                                            option,
                                            ) {
                                          final bool
                                          selected =
                                              selectedAnswer ==
                                                  option;

                                          return Padding(
                                            padding:
                                            const EdgeInsets.only(
                                              bottom:
                                              14,
                                            ),
                                            child:
                                            Material(
                                              color:
                                              selected
                                                  ? const Color(
                                                0xff2A9D8F,
                                              ).withOpacity(
                                                0.09,
                                              )
                                                  : Colors.white,
                                              borderRadius:
                                              BorderRadius.circular(
                                                14,
                                              ),
                                              child:
                                              RadioListTile<String>(
                                                value:
                                                option,
                                                groupValue:
                                                selectedAnswer,
                                                selected:
                                                selected,

                                                shape:
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                    14,
                                                  ),
                                                  side:
                                                  BorderSide(
                                                    color:
                                                    selected
                                                        ? const Color(
                                                      0xff2A9D8F,
                                                    )
                                                        : Colors.grey.shade300,
                                                    width:
                                                    2,
                                                  ),
                                                ),

                                                tileColor:
                                                Colors.white,

                                                selectedTileColor:
                                                const Color(
                                                  0xff2A9D8F,
                                                ).withOpacity(
                                                  0.09,
                                                ),

                                                radioScaleFactor:
                                                1.2,

                                                fillColor:
                                                WidgetStateProperty.resolveWith<Color>(
                                                      (
                                                      states,
                                                      ) {
                                                    if (states.contains(
                                                      WidgetState.selected,
                                                    )) {
                                                      return const Color(
                                                        0xff2A9D8F,
                                                      );
                                                    }

                                                    return const Color(
                                                      0xffB8C1D1,
                                                    );
                                                  },
                                                ),

                                                activeColor:
                                                const Color(
                                                  0xff2A9D8F,
                                                ),

                                                contentPadding:
                                                const EdgeInsets.symmetric(
                                                  horizontal:
                                                  12,
                                                  vertical:
                                                  2,
                                                ),

                                                title:
                                                Text(
                                                  option,
                                                  textAlign:
                                                  TextAlign.center,
                                                  style:
                                                  TextStyle(
                                                    fontSize:
                                                    15,
                                                    fontFamily:
                                                    "Tajawal",
                                                    fontWeight:
                                                    selected
                                                        ? FontWeight.bold
                                                        : FontWeight.w500,
                                                    color:
                                                    const Color(
                                                      0xff181C1F,
                                                    ),
                                                  ),
                                                ),

                                                controlAffinity:
                                                ListTileControlAffinity.trailing,

                                                onChanged:
                                                    (
                                                    value,
                                                    ) {
                                                  setState(
                                                        () {
                                                      selectedAnswer =
                                                          value;
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(
                                height:
                                30,
                              ),

                              // =====================================
                              // Next / Finish button
                              // =====================================

                              Center(
                                child:
                                SizedBox(
                                  width:
                                  240,
                                  height:
                                  52,
                                  child:
                                  ElevatedButton.icon(
                                    onPressed:
                                    selectedAnswer ==
                                        null
                                        ? null
                                        : () {
                                      _nextQuestion(
                                        provider,
                                      );
                                    },

                                    icon:
                                    Icon(
                                      currentQuestion ==
                                          provider.mcqs.length -
                                              1
                                          ? Icons
                                          .check_rounded
                                          : Icons
                                          .arrow_back_rounded,
                                    ),

                                    label:
                                    Text(
                                      currentQuestion ==
                                          provider.mcqs.length -
                                              1
                                          ? "إنهاء الاختبار"
                                          : "التالي",
                                      style:
                                      const TextStyle(
                                        color:
                                        Colors.white,
                                        fontWeight:
                                        FontWeight.bold,
                                        fontFamily:
                                        "Tajawal",
                                        fontSize:
                                        16,
                                      ),
                                    ),

                                    style:
                                    ElevatedButton.styleFrom(
                                      backgroundColor:
                                      const Color(
                                        0xff2A9D8F,
                                      ),
                                      foregroundColor:
                                      Colors.white,
                                      disabledBackgroundColor:
                                      const Color(
                                        0xffC7D5D3,
                                      ),
                                      disabledForegroundColor:
                                      Colors.white,
                                      elevation:
                                      0,
                                      shape:
                                      RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(
                                          14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(
                                height:
                                40,
                              ),
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
      ),
    );
  }
}