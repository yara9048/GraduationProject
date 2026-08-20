import 'package:flutter/material.dart';
import 'package:graduationprojct/features/home/providers/regenerate_mcq_provider.dart';
import 'package:graduationprojct/features/home/ui/pages/video_details_page.dart';
import 'package:provider/provider.dart';

import '../../providers/ai_features_provider.dart';
import '../../providers/mcq_quiz_provider.dart';

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
  State<McqScreen> createState() =>
      _McqScreenState();
}

class _McqScreenState
    extends State<McqScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance
        .addPostFrameCallback(
          (_) async {
        if (!mounted) {
          return;
        }

        context
            .read<McqQuizProvider>()
            .reset();

        await context
            .read<AiFeaturesProvider>()
            .getAiFeatures(
          videoId:
          widget.videoId,
        );
      },
    );
  }

  void _finishQuiz() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
            VideoDetailsPage(
              videoId:
              widget.videoId,
              playlistId:
              widget.playlistId,
              videoName:
              widget.videoName,
            ),
      ),
    );
  }

  void _showAnswersReport(
      AiFeaturesProvider aiProvider,
      McqQuizProvider quizProvider,
      ) {
    showDialog(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection:
          TextDirection.rtl,
          child: Dialog(
            backgroundColor:
            Colors.white,
            shape:
            RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(
                22,
              ),
            ),
            child:
            ConstrainedBox(
              constraints:
              BoxConstraints(
                maxHeight:
                MediaQuery.of(
                  context,
                ).size.height *
                    0.78,
              ),
              child: Column(
                mainAxisSize:
                MainAxisSize.min,
                children: [
                  Padding(
                    padding:
                    const EdgeInsets
                        .fromLTRB(
                      10,
                      18,
                      10,
                      12,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration:
                          BoxDecoration(
                            color:
                            const Color(
                              0xff2A9D8F,
                            ).withOpacity(
                              0.10,
                            ),
                            shape:
                            BoxShape
                                .circle,
                          ),
                          child:
                          const Icon(
                            Icons
                                .info_outline_rounded,
                            color:
                            Color(
                              0xff2A9D8F,
                            ),
                            size: 25,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Expanded(
                          child: Text(
                            'تقرير الإجابات',
                            style:
                            TextStyle(
                              fontFamily:
                              'Tajawal',
                              fontSize:
                              20,
                              fontWeight:
                              FontWeight
                                  .bold,
                              color:
                              Color(
                                0xff1A2429,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed:
                              () {
                            Navigator.pop(
                              context,
                            );
                          },
                          icon:
                          const Icon(
                            Icons
                                .close_rounded,
                            color:
                            Color(
                              0xff4D5A5D,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    height: 1,
                  ),
                  Flexible(
                    child:
                    ListView
                        .separated(
                      padding:
                      const EdgeInsets
                          .all(
                        16,
                      ),
                      itemCount:
                      aiProvider
                          .mcqs
                          .length,
                      separatorBuilder:
                          (
                          _,
                          __,
                          ) {
                        return const SizedBox(
                          height:
                          14,
                        );
                      },
                      itemBuilder:
                          (
                          context,
                          index,
                          ) {
                        final q =
                        aiProvider
                            .mcqs[
                        index];

                        final String?
                        userAnswer =
                        quizProvider
                            .answerFor(
                          q.id,
                        );

                        final bool
                        isCorrect =
                        quizProvider
                            .isCorrect(
                          questionId:
                          q.id,
                          correctAnswer:
                          q.answer,
                        );

                        return Container(
                          padding:
                          const EdgeInsets
                              .all(
                            16,
                          ),
                          decoration:
                          BoxDecoration(
                            color:
                            isCorrect
                                ? const Color(
                              0xff2A9D8F,
                            ).withOpacity(
                              0.07,
                            )
                                : const Color(
                              0xffE76F51,
                            ).withOpacity(
                              0.07,
                            ),
                            borderRadius:
                            BorderRadius
                                .circular(
                              16,
                            ),
                            border:
                            Border.all(
                              color:
                              isCorrect
                                  ? const Color(
                                0xff2A9D8F,
                              )
                                  : const Color(
                                0xffE76F51,
                              ),
                              width:
                              1.3,
                            ),
                          ),
                          child:
                          Column(
                            crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    isCorrect
                                        ? Icons
                                        .check_circle_rounded
                                        : Icons
                                        .cancel_rounded,
                                    color:
                                    isCorrect
                                        ? const Color(
                                      0xff2A9D8F,
                                    )
                                        : const Color(
                                      0xffE76F51,
                                    ),
                                    size:
                                    24,
                                  ),
                                  const SizedBox(
                                    width:
                                    8,
                                  ),
                                  Text(
                                    isCorrect
                                        ? 'إجابة صحيحة'
                                        : 'إجابة خاطئة',
                                    style:
                                    TextStyle(
                                      fontFamily:
                                      'Tajawal',
                                      fontSize:
                                      14,
                                      fontWeight:
                                      FontWeight
                                          .bold,
                                      color:
                                      isCorrect
                                          ? const Color(
                                        0xff2A9D8F,
                                      )
                                          : const Color(
                                        0xffE76F51,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    'السؤال ${index + 1}',
                                    style:
                                    const TextStyle(
                                      fontFamily:
                                      'Tajawal',
                                      fontSize:
                                      13,
                                      color:
                                      Colors
                                          .black54,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height:
                                14,
                              ),
                              Text(
                                q.question,
                                textAlign:
                                TextAlign
                                    .right,
                                style:
                                const TextStyle(
                                  fontFamily:
                                  'Tajawal',
                                  fontSize:
                                  15,
                                  height:
                                  1.5,
                                  fontWeight:
                                  FontWeight
                                      .bold,
                                  color:
                                  Color(
                                    0xff181C1F,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height:
                                16,
                              ),
                              const Text(
                                'إجابتك:',
                                style:
                                TextStyle(
                                  fontFamily:
                                  'Tajawal',
                                  fontSize:
                                  14,
                                  fontWeight:
                                  FontWeight
                                      .bold,
                                  color:
                                  Color(
                                    0xff4D5A5D,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height:
                                5,
                              ),
                              Container(
                                width:
                                double
                                    .infinity,
                                padding:
                                const EdgeInsets
                                    .symmetric(
                                  horizontal:
                                  12,
                                  vertical:
                                  10,
                                ),
                                decoration:
                                BoxDecoration(
                                  color:
                                  Colors
                                      .white,
                                  borderRadius:
                                  BorderRadius
                                      .circular(
                                    10,
                                  ),
                                ),
                                child:
                                Text(
                                  userAnswer ??
                                      'لم يتم اختيار إجابة',
                                  style:
                                  TextStyle(
                                    fontFamily:
                                    'Tajawal',
                                    fontSize:
                                    14,
                                    fontWeight:
                                    FontWeight
                                        .w600,
                                    color:
                                    isCorrect
                                        ? const Color(
                                      0xff2A9D8F,
                                    )
                                        : const Color(
                                      0xffE76F51,
                                    ),
                                  ),
                                ),
                              ),
                              if (!isCorrect) ...[
                                const SizedBox(
                                  height:
                                  14,
                                ),
                                const Text(
                                  'الإجابة الصحيحة:',
                                  style:
                                  TextStyle(
                                    fontFamily:
                                    'Tajawal',
                                    fontSize:
                                    14,
                                    fontWeight:
                                    FontWeight
                                        .bold,
                                    color:
                                    Color(
                                      0xff4D5A5D,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height:
                                  5,
                                ),
                                Container(
                                  width:
                                  double
                                      .infinity,
                                  padding:
                                  const EdgeInsets
                                      .symmetric(
                                    horizontal:
                                    12,
                                    vertical:
                                    10,
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
                                    BorderRadius
                                        .circular(
                                      10,
                                    ),
                                  ),
                                  child:
                                  Text(
                                    q.answer,
                                    style:
                                    const TextStyle(
                                      fontFamily:
                                      'Tajawal',
                                      fontSize:
                                      14,
                                      fontWeight:
                                      FontWeight
                                          .bold,
                                      color:
                                      Color(
                                        0xff2A9D8F,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showResultDialog({
    required int score,
    required AiFeaturesProvider aiProvider,
    required McqQuizProvider quizProvider,
  }) {
    final int totalQuestions =
        aiProvider.mcqs.length;

    final bool passed =
    quizProvider.passed(
      score: score,
      totalQuestions:
      totalQuestions,
    );

    final String message =
    quizProvider
        .resultMessage(
      score: score,
      totalQuestions:
      totalQuestions,
    );

    showDialog(
      context: context,
      barrierDismissible:
      false,
      builder: (_) {
        return Directionality(
          textDirection:
          TextDirection.rtl,
          child: Dialog(
            backgroundColor:
            Colors.white,
            shape:
            RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(
                24,
              ),
            ),
            child: Padding(
              padding:
              const EdgeInsets.all(
                24,
              ),
              child:
              SingleChildScrollView(
                child: Column(
                  mainAxisSize:
                  MainAxisSize.min,
                  children: [
                    Container(
                      width: 86,
                      height: 86,
                      decoration:
                      BoxDecoration(
                        color:
                        const Color(
                          0xff2A9D8F,
                        ).withOpacity(
                          0.12,
                        ),
                        shape:
                        BoxShape.circle,
                      ),
                      child: Icon(
                        passed
                            ? Icons
                            .check_circle_rounded
                            : Icons
                            .quiz_rounded,
                        size: 62,
                        color:
                        const Color(
                          0xff2A9D8F,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'نتيجة الاختبار',
                      textAlign:
                      TextAlign.center,
                      style:
                      TextStyle(
                        fontFamily:
                        'Tajawal',
                        fontSize:
                        22,
                        fontWeight:
                        FontWeight
                            .bold,
                        color:
                        Color(
                          0xff1A2429,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      '$score / $totalQuestions',
                      textAlign:
                      TextAlign.center,
                      style:
                      const TextStyle(
                        fontFamily:
                        'Tajawal',
                        fontSize:
                        30,
                        fontWeight:
                        FontWeight
                            .bold,
                        color:
                        Color(
                          0xff2A9D8F,
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
                      style:
                      const TextStyle(
                        fontFamily:
                        'Tajawal',
                        fontSize:
                        15,
                        height:
                        1.5,
                        color:
                        Colors
                            .black87,
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    ClipRRect(
                      borderRadius:
                      BorderRadius
                          .circular(
                        20,
                      ),
                      child:
                      LinearProgressIndicator(
                        value:
                        totalQuestions ==
                            0
                            ? 0
                            : score /
                            totalQuestions,
                        minHeight:
                        10,
                        backgroundColor:
                        Colors.grey
                            .shade300,
                        valueColor:
                        const AlwaysStoppedAnimation(
                          Color(
                            0xff2A9D8F,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    SizedBox(
                      width:
                      double.infinity,
                      height: 50,
                      child:
                      OutlinedButton
                          .icon(
                        onPressed:
                            () {
                          _showAnswersReport(
                            aiProvider,
                            quizProvider,
                          );
                        },
                        style:
                        OutlinedButton
                            .styleFrom(
                          foregroundColor:
                          const Color(
                            0xff2A9D8F,
                          ),
                          side:
                          const BorderSide(
                            color:
                            Color(
                              0xff2A9D8F,
                            ),
                            width:
                            1.5,
                          ),
                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius
                                .circular(
                              15,
                            ),
                          ),
                        ),
                        icon:
                        const Icon(
                          Icons
                              .info_outline_rounded,
                          color:
                          Color(
                            0xff2A9D8F,
                          ),
                          size:
                          23,
                        ),
                        label:
                        const Text(
                          'عرض تقرير الإجابات',
                          style:
                          TextStyle(
                            fontFamily:
                            'Tajawal',
                            fontSize:
                            16,
                            fontWeight:
                            FontWeight
                                .bold,
                            color:
                            Color(
                              0xff2A9D8F,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    SizedBox(
                      width:
                      double.infinity,
                      height: 50,
                      child:
                      ElevatedButton
                          .icon(
                        onPressed:
                            () async {
                          final mcqProvider =
                          context.read<
                              RegenerateMcqProvider>();

                          await mcqProvider
                              .regenerate(
                            videoId:
                            widget
                                .videoId,
                          );

                          if (!context
                              .mounted) {
                            return;
                          }

                          if (mcqProvider
                              .errorMessage !=
                              null) {
                            ScaffoldMessenger
                                .of(
                              context,
                            ).showSnackBar(
                              SnackBar(
                                content:
                                Text(
                                  mcqProvider
                                      .errorMessage!,
                                ),
                              ),
                            );

                            return;
                          }

                          if (mcqProvider
                              .mcq ==
                              null) {
                            ScaffoldMessenger
                                .of(
                              context,
                            ).showSnackBar(
                              const SnackBar(
                                content:
                                Text(
                                  'تعذر',
                                ),
                              ),
                            );

                            return;
                          }

                          quizProvider
                              .reset();

                          Navigator
                              .push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) {
                                return VideoDetailsPage(
                                  playlistId:
                                  widget
                                      .playlistId,
                                  videoId:
                                  widget
                                      .videoId,
                                  videoName:
                                  widget
                                      .videoName,
                                );
                              },
                            ),
                          );
                        },
                        style:
                        ElevatedButton
                            .styleFrom(
                          backgroundColor:
                          const Color(
                            0xff2A9D8F,
                          ),
                          foregroundColor:
                          Colors.white,
                          elevation:
                          0,
                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius
                                .circular(
                              15,
                            ),
                          ),
                        ),
                        icon:
                        const Icon(
                          Icons
                              .refresh_rounded,
                          color:
                          Colors.white,
                          size:
                          23,
                        ),
                        label:
                        const Text(
                          'اعادة توليد اسئلة',
                          style:
                          TextStyle(
                            fontFamily:
                            'Tajawal',
                            fontSize:
                            16,
                            fontWeight:
                            FontWeight
                                .bold,
                            color:
                            Colors
                                .white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    SizedBox(
                      width:
                      double.infinity,
                      height: 50,
                      child:
                      OutlinedButton(
                        onPressed:
                        _finishQuiz,
                        style:
                        OutlinedButton
                            .styleFrom(
                          foregroundColor:
                          const Color(
                            0xff2A9D8F,
                          ),
                          side:
                          const BorderSide(
                            color:
                            Color(
                              0xff2A9D8F,
                            ),
                            width:
                            1.5,
                          ),
                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius
                                .circular(
                              15,
                            ),
                          ),
                        ),
                        child:
                        const Text(
                          'إنهاء',
                          style:
                          TextStyle(
                            fontFamily:
                            'Tajawal',
                            fontSize:
                            16,
                            fontWeight:
                            FontWeight
                                .bold,
                            color:
                            Color(
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
          ),
        );
      },
    );
  }

  void _submitAnswer(
      AiFeaturesProvider aiProvider,
      McqQuizProvider quizProvider,
      ) {
    final question =
    aiProvider.mcqs[
    quizProvider
        .currentQuestion
    ];

    final bool isLast =
    quizProvider
        .isLastQuestion(
      aiProvider.mcqs.length,
    );

    int? nextQuestionId;

    if (!isLast) {
      nextQuestionId =
          aiProvider
              .mcqs[
          quizProvider
              .currentQuestion +
              1
          ]
              .id;
    }

    final bool moved =
    quizProvider
        .submitAndMoveNext(
      questionId:
      question.id,
      totalQuestions:
      aiProvider.mcqs.length,
      nextQuestionId:
      nextQuestionId,
    );

    if (moved) {
      return;
    }

    final int score =
    quizProvider
        .calculateScore(
      aiProvider.mcqs,
    );

    _showResultDialog(
      score: score,
      aiProvider:
      aiProvider,
      quizProvider:
      quizProvider,
    );
  }

  @override
  Widget build(
      BuildContext context,
      ) {
    final aiProvider =
    context.watch<
        AiFeaturesProvider>();

    final quizProvider =
    context.watch<
        McqQuizProvider>();

    if (aiProvider.isLoading) {
      return const Scaffold(
        backgroundColor:
        Colors.white,
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

    if (aiProvider.errorMessage !=
        null) {
      return Scaffold(
        backgroundColor:
        Colors.white,
        body: Center(
          child: Padding(
            padding:
            const EdgeInsets.all(
              24,
            ),
            child: Text(
              aiProvider
                  .errorMessage!,
              textAlign:
              TextAlign.center,
              style:
              const TextStyle(
                fontFamily:
                'Tajawal',
              ),
            ),
          ),
        ),
      );
    }

    if (aiProvider.mcqs.isEmpty) {
      return const Scaffold(
        backgroundColor:
        Colors.white,
        body: Center(
          child: Text(
            'لا توجد أسئلة',
            style: TextStyle(
              fontFamily: "Tajawal",
              fontSize: 15,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    final question =
    aiProvider.mcqs[
    quizProvider
        .currentQuestion
    ];

    final double progress =
    quizProvider.progress(
      aiProvider.mcqs.length,
    );

    final bool isLast =
    quizProvider
        .isLastQuestion(
      aiProvider.mcqs.length,
    );

    return Directionality(
      textDirection:
      TextDirection.rtl,
      child: Scaffold(
        backgroundColor:
        Colors.white,
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
                          top: 30,
                          right: 10,
                          child:
                          InkWell(
                            onTap:
                            _finishQuiz,
                            borderRadius:
                            BorderRadius
                                .circular(
                              12,
                            ),
                            child:
                            const Padding(
                              padding:
                              EdgeInsets
                                  .symmetric(
                                horizontal:
                                8,
                                vertical:
                                8,
                              ),
                              child: Row(
                                mainAxisSize:
                                MainAxisSize
                                    .min,
                                children: [
                                  Icon(
                                    Icons
                                        .arrow_back_ios_new_rounded,
                                    textDirection:
                                    TextDirection
                                        .rtl,
                                    color:
                                    Color(
                                      0xff2A9D8F,
                                    ),
                                    size:
                                    20,
                                  ),
                                  SizedBox(
                                    width:
                                    10,
                                  ),
                                  Text(
                                    'اختبار الفيديو',
                                    style:
                                    TextStyle(
                                      fontWeight:
                                      FontWeight
                                          .bold,
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
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child:
                    MediaQuery
                        .removePadding(
                      removeTop:
                      true,
                      context:
                      context,
                      child:
                      SingleChildScrollView(
                        physics:
                        const BouncingScrollPhysics(),
                        child:
                        Padding(
                          padding:
                          const EdgeInsets
                              .symmetric(
                            horizontal:
                            15,
                          ),
                          child:
                          Column(
                            crossAxisAlignment:
                            CrossAxisAlignment
                                .end,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '${(progress * 100).toStringAsFixed(0)}%',
                                    style:
                                    const TextStyle(
                                      fontFamily:
                                      'Tajawal',
                                      color:
                                      Color(
                                        0xff2A9D8F,
                                      ),
                                      fontWeight:
                                      FontWeight
                                          .bold,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    'السؤال ${quizProvider.currentQuestion + 1} من ${aiProvider.mcqs.length}',
                                    style:
                                    const TextStyle(
                                      fontFamily:
                                      'Tajawal',
                                      fontWeight:
                                      FontWeight
                                          .w500,
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
                              ClipRRect(
                                borderRadius:
                                BorderRadius
                                    .circular(
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
                              Card(
                                color:
                                Colors
                                    .white,
                                elevation:
                                3,
                                surfaceTintColor:
                                Colors
                                    .white,
                                shape:
                                RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius
                                      .circular(
                                    20,
                                  ),
                                ),
                                child:
                                Padding(
                                  padding:
                                  const EdgeInsets
                                      .all(
                                    20,
                                  ),
                                  child:
                                  Column(
                                    children: [
                                      if (question
                                          .category
                                          .trim()
                                          .isNotEmpty)
                                        Container(
                                          padding:
                                          const EdgeInsets
                                              .symmetric(
                                            horizontal:
                                            12,
                                            vertical:
                                            6,
                                          ),
                                          margin:
                                          const EdgeInsets
                                              .only(
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
                                            BorderRadius
                                                .circular(
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
                                              'Tajawal',
                                              color:
                                              Color(
                                                0xff2A9D8F,
                                              ),
                                              fontWeight:
                                              FontWeight
                                                  .bold,
                                              fontSize:
                                              12,
                                            ),
                                          ),
                                        ),
                                      Text(
                                        question
                                            .question,
                                        textAlign:
                                        TextAlign
                                            .center,
                                        style:
                                        const TextStyle(
                                          fontSize:
                                          17,
                                          height:
                                          1.5,
                                          fontWeight:
                                          FontWeight
                                              .bold,
                                          fontFamily:
                                          'Tajawal',
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
                                      ...question
                                          .options
                                          .map(
                                            (
                                            option,
                                            ) {
                                          final bool
                                          selected =
                                              quizProvider
                                                  .selectedAnswer ==
                                                  option;

                                          return Padding(
                                            padding:
                                            const EdgeInsets
                                                .only(
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
                                              BorderRadius
                                                  .circular(
                                                14,
                                              ),
                                              child:
                                              RadioListTile<String>(
                                                value:
                                                option,
                                                groupValue:
                                                quizProvider
                                                    .selectedAnswer,
                                                selected:
                                                selected,
                                                shape:
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(
                                                    14,
                                                  ),
                                                  side:
                                                  BorderSide(
                                                    color:
                                                    selected
                                                        ? const Color(
                                                      0xff2A9D8F,
                                                    )
                                                        : Colors
                                                        .grey
                                                        .shade300,
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
                                                WidgetStateProperty
                                                    .resolveWith<
                                                    Color>(
                                                      (
                                                      states,
                                                      ) {
                                                    if (states
                                                        .contains(
                                                      WidgetState
                                                          .selected,
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
                                                const EdgeInsets
                                                    .symmetric(
                                                  horizontal:
                                                  12,
                                                  vertical:
                                                  2,
                                                ),
                                                title:
                                                Text(
                                                  option,
                                                  textAlign:
                                                  TextAlign
                                                      .center,
                                                  style:
                                                  TextStyle(
                                                    fontSize:
                                                    15,
                                                    fontFamily:
                                                    'Tajawal',
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
                                                ListTileControlAffinity
                                                    .trailing,
                                                onChanged:
                                                quizProvider
                                                    .selectAnswer,
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
                              Center(
                                child:
                                SizedBox(
                                  width:
                                  240,
                                  height:
                                  52,
                                  child:
                                  ElevatedButton
                                      .icon(
                                    onPressed:
                                    quizProvider
                                        .hasSelectedAnswer
                                        ? () {
                                      _submitAnswer(
                                        aiProvider,
                                        quizProvider,
                                      );
                                    }
                                        : null,
                                    icon:
                                    Icon(
                                      isLast
                                          ? Icons
                                          .check_rounded
                                          : Icons
                                          .arrow_back_rounded,
                                    ),
                                    label:
                                    Text(
                                      isLast
                                          ? 'إنهاء الاختبار'
                                          : 'التالي',
                                      style:
                                      const TextStyle(
                                        color:
                                        Colors
                                            .white,
                                        fontWeight:
                                        FontWeight
                                            .bold,
                                        fontFamily:
                                        'Tajawal',
                                        fontSize:
                                        16,
                                      ),
                                    ),
                                    style:
                                    ElevatedButton
                                        .styleFrom(
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
                                        BorderRadius
                                            .circular(
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