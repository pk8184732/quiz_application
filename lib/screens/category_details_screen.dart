import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quiz_application/screens/quiz_play_screen.dart';

import '../models/quiz_models.dart';

class CategoryDetailScreen extends StatelessWidget {
  final QuizCategory category;
  const CategoryDetailScreen({super.key, required this.category});

  // sample "terms" list
  List<String> get terms => [
    "10 Questions - timed",
    "Each correct answer +5 points",
    "No negative marking",
    "You can retake quiz after 30 minutes",
    "Paid content requires purchase",
  ];

  // sample questions for this category
  List<Question> get sampleQuestions => [
    Question(
      text: "What is the capital of India?",
      options: ["Mumbai", "Delhi", "Kolkata", "Chennai"],
      correctIndex: 1,
      imageUrl: null,
      timeSeconds: 12,
    ),
    Question(
      text: "Which planet is known as the Red Planet?",
      options: ["Earth", "Venus", "Mars", "Jupiter"],
      correctIndex: 2,
      imageUrl: "https://images.unsplash.com/photo-1462331940025-496dfbfc7564",
      timeSeconds: 15,
    ),
    // ... add until 10 questions (for demo we'll reuse)
  ];

  @override
  Widget build(BuildContext context) {
    // prepare list of 10 by repeating or creating new ones
    final questions = List<Question>.generate(10, (i) => sampleQuestions[i % sampleQuestions.length]);

    return Scaffold(
      appBar: AppBar(
        title: Text(category.title),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // top image and gradient
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 260,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(image: NetworkImage(category.imageUrl), fit: BoxFit.cover),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.black.withOpacity(0.45), Colors.transparent], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                ),
              ),
            ),
          ),
          // content
          Positioned.fill(
            top: 200,
            child: Container(
              decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(category.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6), decoration: BoxDecoration(color: category.isPaid ? Colors.orange[100] : Colors.green[100], borderRadius: BorderRadius.circular(8)), child: Text(category.isPaid ? "Paid" : "Free")),
                        const SizedBox(width: 12),
                        const Text("10 Questions • 5 pts each"),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text("Terms and Conditions", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    ...terms.map((t) => ListTile(leading: const Icon(Icons.check_circle_outline), title: Text(t))).toList(),
                    const Spacer(),

                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, padding: const EdgeInsets.symmetric(vertical: 14)),
                            onPressed: () {
                              // start quiz: navigate to quiz screen with prepared questions
                              Navigator.push(context, MaterialPageRoute(builder: (_) => QuizPlayScreen(category: category, questions: questions)));
                            },
                            child: const Text("Go to Quiz", style: TextStyle(fontSize: 16)),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
