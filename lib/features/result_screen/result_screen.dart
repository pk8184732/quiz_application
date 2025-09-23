import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../mode/quiz_model.dart';
import '../../mode/question_model.dart';

class QuizResultScreen extends StatelessWidget {
  const QuizResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Receive arguments as a map
    final args = Get.arguments as Map<String, dynamic>;
    final QuizModel quiz = args['quiz'] as QuizModel;
    final Map<String, String> selectedAnswers =
    args['answers'] as Map<String, String>; // questionId -> optionId
    final double scroll = args['scroll'] ?? 0.0;

    // Calculate results
    int totalQuestions = quiz.questions.length;
    int correctAnswers = quiz.questions.where((q) {
      final selectedOptionId = selectedAnswers[q.id];
      if (selectedOptionId == null) return false;
      final selectedOption = q.options.firstWhere((o) => o.id == selectedOptionId);
      return selectedOption.isCorrect;
    }).length;

    int totalScore = quiz.questions.fold<int>(0, (prev, q) {
      final selectedOptionId = selectedAnswers[q.id];
      if (selectedOptionId == null) return prev;
      final selectedOption = q.options.firstWhere((o) => o.id == selectedOptionId);
      return prev + (selectedOption.isCorrect ? q.points : 0);
    });

    return Scaffold(
      backgroundColor: Colors.deepPurple.shade700,
      body: SafeArea(
        child: SingleChildScrollView(
          controller: ScrollController(initialScrollOffset: scroll),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Quiz Completed!",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              const Icon(
                Icons.emoji_events,
                size: 80,
                color: Colors.amber,
              ),
              const SizedBox(height: 30),
              // Score Card
              Card(
                color: Colors.white.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: Column(
                    children: [
                      _resultRow("Total Questions", totalQuestions.toString()),
                      const SizedBox(height: 12),
                      _resultRow("Correct Answers", correctAnswers.toString()),
                      const SizedBox(height: 12),
                      _resultRow("Total Score", totalScore.toString()),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Get.offAllNamed('/home');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  "Back to Home",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () {
                  Get.offNamed('/quiz-play', arguments: quiz);
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  "Retry Quiz",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _resultRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white70),
        ),
        Text(
          value,
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ],
    );
  }
}
