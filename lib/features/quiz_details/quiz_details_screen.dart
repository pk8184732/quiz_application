import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_application/features/bg/bg.dart';
import 'package:quiz_application/features/quiz_details/quiz_details_controller.dart';
import 'package:quiz_application/mode/quiz_model.dart';

class QuizDetailsScreen extends StatelessWidget {
  const QuizDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final quiz = Get.arguments as QuizModel;
    final c = Get.put(QuizDetailsController(quiz: quiz));

    return Scaffold(
      body: Stack(
        children: [
          PurpleBackground(),
          Column(
            children: [
              // Top Section
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),
                      // Image
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(24),
                          bottomRight: Radius.circular(24),
                        ),
                        child: Image.network(
                          c.quiz.imageUrl,
                          height: 220,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Title
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          c.quiz.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Price
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          c.quiz.price != null && c.quiz.price!.isNotEmpty
                              ? "₹${c.quiz.price}"
                              : "Free",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: c.quiz.price != null ? Colors.red : Colors.green,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Description
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          c.quiz.description,
                          style: const TextStyle(fontSize: 16,   color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom Section
              SafeArea(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: c.startQuiz,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Start Quiz",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
