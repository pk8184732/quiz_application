// lib/features/quiz/quiz_details_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_application/mode/quiz_model.dart';
import 'package:quiz_application/routes/app_routes.dart';

class QuizDetailsController extends GetxController {
  final QuizModel quiz;
  RxBool isJoined = false.obs;

  QuizDetailsController({required this.quiz});

  void startQuiz() {
    _showCountdownDialog();
  }

  void _showCountdownDialog() {
    RxString displayText = '1'.obs; // reactive text for display
    int counter = 1; // internal counter

    Timer? timer;

    Get.dialog(
      Scaffold(
        body: Center(
          child: Obx(
                () => Text(
              displayText.value,
              style: const TextStyle(
                fontSize: 80,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: false,
      useSafeArea: false,
      barrierColor: Colors.black.withOpacity(0.8),
    );

    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      counter++;
      if (counter <= 3) {
        displayText.value = '$counter';
      } else if (counter == 4) {
        displayText.value = 'START';
      } else if (counter == 5) {
        t.cancel();
        Get.back(); // close dialog
        Get.toNamed(AppRoutes.quiz, arguments: quiz); // go to quiz
      }
    });
  }
}
