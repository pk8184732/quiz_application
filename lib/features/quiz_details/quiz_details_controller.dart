// lib/features/quiz/quiz_details_screen.dart
import 'package:get/get.dart';
import 'package:quiz_application/mode/quiz_model.dart';
import 'package:quiz_application/routes/app_routes.dart';

class QuizDetailsController extends GetxController {
  final QuizModel quiz;

  QuizDetailsController({required this.quiz});

  void startQuiz() {
    Get.toNamed(AppRoutes.quiz, arguments: quiz);
  }
}

