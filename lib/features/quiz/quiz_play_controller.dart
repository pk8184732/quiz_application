import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:quiz_application/routes/app_routes.dart';
import '../../mode/quiz_model.dart';
import '../../mode/question_model.dart';

class QuizPlayController extends GetxController {
  final QuizModel quiz;
  QuizPlayController({required this.quiz});

  // Reactive state
  final currentIndex = 0.obs;
  final selectedOption = ''.obs;            // current question selected option id
  final score = 0.obs;                       // current score
  final oldScore = 0.obs;                   // previous score for animation
  final timeLeft = 15.obs;                  // per-question timer (seconds)
  final locked = false.obs;                 // true when showing correct/incorrect
  final Map<String, String> selectedAnswers = {}; // questionId -> optionId

  final Duration revealDelay = const Duration(milliseconds: 1200);
  Timer? _timer;

  QuestionModel get currentQuestion => quiz.questions[currentIndex.value];

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  void startTimer() {
    timeLeft.value = currentQuestion.timeLimit;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft.value > 0) {
        timeLeft.value--;
      } else {
        _timer?.cancel();
        revealCorrectThenNext();
      }
    });
  }

  /// Called when user selects an option
  void selectOption(String optionId) {
    if (locked.value) return;

    selectedOption.value = optionId;
    selectedAnswers[currentQuestion.id] = optionId;

    debugPrint('Selected answer:- ${selectedAnswers.toString()}');

    final option = currentQuestion.options.firstWhere((o) => o.id == optionId);

    if (option.isCorrect) {
      oldScore.value = score.value; // for animation
      score.value += currentQuestion.points;
    }

    _timer?.cancel();
    revealCorrectThenNext();
  }

  /// Called when user clicks "Skip"
  void skipQuestion() {
    if (locked.value) return;

    final correctOption = currentQuestion.options.firstWhere((o) => o.isCorrect);
    selectedOption.value = correctOption.id;
    selectedAnswers[currentQuestion.id] = correctOption.id;

    _timer?.cancel();
    revealCorrectThenNext();
  }

  /// Lock UI, show correct answer briefly, then move next
  void revealCorrectThenNext() {
    if (locked.value) return;

    locked.value = true;

    // Highlight correct answer if nothing selected
    if (selectedOption.value.isEmpty) {
      final correctOption = currentQuestion.options.firstWhere((o) => o.isCorrect);
      selectedOption.value = correctOption.id;
      selectedAnswers[currentQuestion.id] = correctOption.id;
    }

    Future.delayed(revealDelay, () {
      nextQuestion();
    });
  }

  void nextQuestion() {
    if (currentIndex.value < quiz.questions.length - 1) {
      currentIndex.value++;
      selectedOption.value = '';
      locked.value = false;
      startTimer();
    } else {
      _timer?.cancel();
      finishQuiz();
    }
  }

  void finishQuiz() {
    // Navigate to result screen with quiz and selected answers
    Get.toNamed(
      AppRoutes.quizResult,
      arguments: {
        'quiz': quiz,
        'answers': selectedAnswers,
        'scroll': 0.0, // optional, initial scroll position
      },
    );
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
