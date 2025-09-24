import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_application/features/bg/bg.dart';
import 'package:quiz_application/features/quiz_details/quiz_details_controller.dart';
import 'package:quiz_application/mode/quiz_model.dart';
import 'package:quiz_application/utils/snack_bar.dart';

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

                      // Title & Subtitle
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              c.quiz.title,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              c.quiz.subtitle,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Info Section: Joining Fee, Winning Prize, Total Attempts, Difficulty, Duration, No of Questions, Rating
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Joining Fee
                            Row(
                              children: [
                                const Text(
                                  "Joining Fee : ",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  c.quiz.price != null &&
                                          c.quiz.price!.isNotEmpty
                                      ? "${c.quiz.price}"
                                      : "Free",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color:
                                        c.quiz.price != null &&
                                                c.quiz.price!.isNotEmpty
                                            ? Colors.red
                                            : Colors.green,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            // Winning Prize
                            Row(
                              children: [
                                const Text(
                                  "Winning Prize : ",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  c.quiz.prize != null &&
                                          c.quiz.prize!.isNotEmpty
                                      ? "${c.quiz.prize}"
                                      : "No Prize",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.yellow,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            // Total Attempts
                            Row(
                              children: [
                                const Text(
                                  "Total Attempts : ",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  "${c.quiz.attempts}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.orangeAccent,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            // Difficulty, Duration, No of Questions, Rating
                            Wrap(
                              spacing: 16,
                              runSpacing: 8,
                              children: [
                                _buildInfoChip(
                                  "Difficulty",
                                  c.quiz.difficulty,
                                  Colors.cyanAccent,
                                ),
                                _buildInfoChip(
                                  "Duration",
                                  c.quiz.duration,
                                  Colors.pinkAccent,
                                ),
                                _buildInfoChip(
                                  "Questions",
                                  "${c.quiz.totalQuestions}",
                                  Colors.limeAccent,
                                ),
                                _buildInfoChip(
                                  "Rating",
                                  "${c.quiz.rating}",
                                  Colors.amberAccent,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Description
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          c.quiz.description,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Terms & Conditions
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Terms & Conditions",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ...c.quiz.termsAndConditions.map(
                              (term) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 2,
                                ),
                                child: Text(
                                  "• $term",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white70,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),

              // Bottom Button
              SafeArea(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 0,
                  ),
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (c.quiz.price != null && c.quiz.price!.isNotEmpty && !c.isJoined.value ) {
                        SnackBarHelper.showMessage(
                          "Success",
                          "Joining Successful",
                        );
                        c.isJoined.value = true;
                      } else {
                        c.startQuiz();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Obx(
                          () => Text(
                        c.quiz.price != null && c.quiz.price!.isNotEmpty
                            ? c.isJoined.value
                                ? "Start Now"
                                : "Join ₹${c.quiz.price}"
                            : "Start Now",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "$title: ",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            TextSpan(text: value, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
