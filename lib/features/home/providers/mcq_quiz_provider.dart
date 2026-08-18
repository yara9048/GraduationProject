import 'package:flutter/foundation.dart';

class McqQuizProvider extends ChangeNotifier {
  int _currentQuestion = 0;
  String? _selectedAnswer;

  final Map<int, String> _userAnswers = {};

  int get currentQuestion =>
      _currentQuestion;

  String? get selectedAnswer =>
      _selectedAnswer;

  Map<int, String> get userAnswers =>
      Map.unmodifiable(_userAnswers);

  bool get hasSelectedAnswer =>
      _selectedAnswer != null;

  void selectAnswer(
      String? answer,
      ) {
    _selectedAnswer = answer;
    notifyListeners();
  }

  String? answerFor(
      int questionId,
      ) {
    return _userAnswers[
    questionId
    ];
  }

  bool isCorrect({
    required int questionId,
    required String correctAnswer,
  }) {
    return _userAnswers[
    questionId
    ] ==
        correctAnswer;
  }

  double progress(
      int totalQuestions,
      ) {
    if (totalQuestions <= 0) {
      return 0;
    }

    return (_currentQuestion + 1) /
        totalQuestions;
  }

  bool isLastQuestion(
      int totalQuestions,
      ) {
    if (totalQuestions <= 0) {
      return false;
    }

    return _currentQuestion ==
        totalQuestions - 1;
  }

  bool submitAndMoveNext({
    required int questionId,
    required int totalQuestions,
    int? nextQuestionId,
  }) {
    if (_selectedAnswer == null) {
      return false;
    }

    _userAnswers[
    questionId
    ] = _selectedAnswer!;

    if (_currentQuestion <
        totalQuestions - 1 &&
        nextQuestionId != null) {
      _currentQuestion++;

      _selectedAnswer =
      _userAnswers[
      nextQuestionId
      ];

      notifyListeners();

      return true;
    }

    notifyListeners();

    return false;
  }

  int calculateScore(
      List<dynamic> questions,
      ) {
    int score = 0;

    for (final question
    in questions) {
      if (_userAnswers[
      question.id
      ] ==
          question.answer) {
        score++;
      }
    }

    return score;
  }

  bool passed({
    required int score,
    required int totalQuestions,
  }) {
    if (totalQuestions <= 0) {
      return false;
    }

    return score >=
        totalQuestions / 2;
  }

  String resultMessage({
    required int score,
    required int totalQuestions,
  }) {
    if (score ==
        totalQuestions) {
      return 'ممتاز! أجبت على جميع الأسئلة بشكل صحيح';
    }

    if (score >=
        totalQuestions / 2) {
      return 'أحسنت! أجبت على $score من $totalQuestions بشكل صحيح';
    }

    return 'لا بأس، أجبت على $score من $totalQuestions بشكل صحيح. حاول مرة أخرى 💪';
  }

  void reset() {
    _currentQuestion = 0;
    _selectedAnswer = null;
    _userAnswers.clear();

    notifyListeners();
  }
}