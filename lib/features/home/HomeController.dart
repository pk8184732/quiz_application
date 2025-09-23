// lib/features/home/home_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_application/routes/app_pages.dart';
import 'package:quiz_application/routes/app_routes.dart';

import '../../mode/banner_model.dart';
import '../../mode/category_model.dart';
import '../../mode/question_model.dart';
import '../../mode/quiz_model.dart';
import '../../mode/user_stats_model.dart';

class HomeController extends GetxController {
  // Business logo (can be updated later from API)
  final String logoUrl = "https://img.icons8.com/color/96/quiz-logo.png";

  // Loading state
  var isLoading = false.obs;
  var selectedQuizIndex = (-1).obs;
  var selectedCategoryIndex = 0.obs;

  // Categories with quizzes and questions
  var categories = <CategoryModel>[].obs;

  // Premium banners for carousel slider - converted to model
  var premiumBanners = <PremiumBannerModel>[].obs;

  // Enhanced quiz list data - converted to model
  var quizzes = <QuizModel>[].obs;

  // User statistics - converted to model
  var userStats =
      UserStatsModel(
        totalQuizzesCompleted: 0,
        totalPoints: 0,
        averageScore: 0.0,
        rank: "Beginner",
        streak: 0,
        achievements: [],
      ).obs;

  // Categories for filtering
  var categoryNames =
      <String>[
        "All",
        "General",
        "Science",
        "Mathematics",
        "Culture",
        "Technology",
        "Sports",
      ].obs;

  var selectedCategory = "All".obs;

  @override
  void onInit() {
    super.onInit();
    initializeData();
  }

  // Initialize sample data with model classes
  void initializeData() {
    // Initialize premium banners with model classes
    premiumBanners.addAll([
      PremiumBannerModel(
        id: "premium_1",
        title: "Art & Color Master",
        subtitle: "Premium - Advanced Level",
        description:
            "Test your knowledge of art history, color theory, and famous artists",
        type: "PREMIUM",
        primaryColor: Colors.amber,
        secondaryColor: Colors.orange,
        questions: 25,
        points: 10,
        duration: "30 min",
        difficulty: "Hard",
        category: "Art",
        price: "\$4.99",
        rating: 4.8,
        enrolledUsers: 1250,
        imageUrl: "https://img.icons8.com/color/96/artist-palette.png",
      ),
      PremiumBannerModel(
        id: "premium_2",
        title: "Science Genius",
        subtitle: "Premium - Expert Level",
        description:
            "Advanced physics, chemistry, and biology questions for science enthusiasts",
        type: "PREMIUM",
        primaryColor: Colors.purple,
        secondaryColor: Colors.deepPurple,
        questions: 30,
        points: 15,
        duration: "45 min",
        difficulty: "Expert",
        category: "Science",
        price: "\$6.99",
        rating: 4.9,
        enrolledUsers: 890,
        imageUrl: "https://img.icons8.com/color/96/laboratory.png",
      ),
      PremiumBannerModel(
        id: "premium_3",
        title: "History Explorer",
        subtitle: "Premium - World History",
        description:
            "Journey through world history from ancient civilizations to modern times",
        type: "PREMIUM",
        primaryColor: Colors.teal,
        secondaryColor: Colors.cyan,
        questions: 35,
        points: 12,
        duration: "40 min",
        difficulty: "Hard",
        category: "History",
        price: "\$5.99",
        rating: 4.7,
        enrolledUsers: 1100,
        imageUrl: "https://img.icons8.com/color/96/ancient-columns.png",
      ),
    ]);

    // Create sample questions with model classes
    // List<QuestionModel> generalQuestions = [
    //   QuestionModel(
    //     id: "q1",
    //     question: "What is the capital of France?",
    //     type: QuestionType.multipleChoice,
    //     options: [
    //       QuestionOption(id: "opt1", text: "London", isCorrect: false),
    //       QuestionOption(id: "opt2", text: "Berlin", isCorrect: false),
    //       QuestionOption(id: "opt3", text: "Paris", isCorrect: true),
    //       QuestionOption(id: "opt4", text: "Madrid", isCorrect: false),
    //     ],
    //     correctAnswer: "Paris",
    //     explanation: "Paris is the capital and largest city of France.",
    //     points: 10,
    //     timeLimit: 30,
    //     difficulty: "Easy",
    //     tags: ["Geography", "Europe"],
    //   ),
    //   QuestionModel(
    //     id: "q2",
    //     question: "Which planet is closest to the Sun?",
    //     type: QuestionType.multipleChoice,
    //     options: [
    //       QuestionOption(id: "opt1", text: "Venus", isCorrect: false),
    //       QuestionOption(id: "opt2", text: "Mercury", isCorrect: true),
    //       QuestionOption(id: "opt3", text: "Earth", isCorrect: false),
    //       QuestionOption(id: "opt4", text: "Mars", isCorrect: false),
    //     ],
    //     correctAnswer: "Mercury",
    //     explanation: "Mercury is the smallest planet and closest to the Sun.",
    //     points: 10,
    //     timeLimit: 30,
    //     difficulty: "Easy",
    //     tags: ["Space", "Astronomy"],
    //   ),
    // ];

    List<QuestionModel> scienceQuestions = [
      QuestionModel(
        id: "sq1",
        question: "What is the chemical symbol for water?",
        type: QuestionType.multipleChoice,
        options: [
          QuestionOption(id: "opt1", text: "H2O", isCorrect: true),
          QuestionOption(id: "opt2", text: "CO2", isCorrect: false),
          QuestionOption(id: "opt3", text: "NaCl", isCorrect: false),
          QuestionOption(id: "opt4", text: "O2", isCorrect: false),
        ],
        correctAnswer: "H2O",
        explanation:
            "Water is composed of two hydrogen atoms and one oxygen atom.",
        points: 15,
        timeLimit: 25,
        difficulty: "Medium",
        tags: ["Chemistry", "Basic"],
      ),
    ];

    List<QuestionModel> mathQuestions = [
      QuestionModel(
        id: "mq1",
        question: "What is 15 + 25?",
        type: QuestionType.multipleChoice,
        options: [
          QuestionOption(id: "opt1", text: "35", isCorrect: false),
          QuestionOption(id: "opt2", text: "40", isCorrect: true),
          QuestionOption(id: "opt3", text: "45", isCorrect: false),
          QuestionOption(id: "opt4", text: "50", isCorrect: false),
        ],
        correctAnswer: "40",
        explanation: "15 + 25 = 40",
        points: 10,
        timeLimit: 20,
        difficulty: "Easy",
        tags: ["Addition", "Basic"],
      ),
    ];

    List<QuestionModel> generalQuestions = [
      // 1. Multiple Choice
      QuestionModel(
        id: "q1",
        question: "What is the capital of France?",
        type: QuestionType.multipleChoice,
        options: [
          QuestionOption(id: "opt1", text: "London", isCorrect: false),
          QuestionOption(id: "opt2", text: "Berlin", isCorrect: false),
          QuestionOption(id: "opt3", text: "Paris", isCorrect: true),
          QuestionOption(id: "opt4", text: "Madrid", isCorrect: false),
        ],
        correctAnswer: "Paris",
        explanation: "Paris is the capital and largest city of France.",
        points: 10,
        timeLimit: 30,
        difficulty: "Easy",
        tags: ["Geography", "Europe"],
      ),
      // 2. True/False
      QuestionModel(
        id: "q2",
        question: "The Great Wall of China is visible from the Moon.",
        type: QuestionType.trueFalse,
        options: [
          QuestionOption(id: "opt1", text: "True", isCorrect: false),
          QuestionOption(id: "opt2", text: "False", isCorrect: true),
        ],
        correctAnswer: "False",
        explanation: "The Great Wall is not visible from the Moon with the naked eye.",
        points: 10,
        timeLimit: 20,
        difficulty: "Easy",
        tags: ["Geography", "Fact"],
      ),


      // 4. Image Choice
      QuestionModel(
        id: "q4",
        question: "Identify the landmark in the image.",
        type: QuestionType.imageChoice,
        questionImageUrl: "https://example.com/eiffel_tower.jpg",
        options: [
          QuestionOption(
              id: "opt1",
              text: "Statue of Liberty",
              imageUrl: "https://example.com/statue_liberty.jpg",
              isCorrect: false),
          QuestionOption(
              id: "opt2",
              text: "Eiffel Tower",
              imageUrl: "https://example.com/eiffel_tower.jpg",
              isCorrect: true),
          QuestionOption(
              id: "opt3",
              text: "Big Ben",
              imageUrl: "https://example.com/big_ben.jpg",
              isCorrect: false),
        ],
        correctAnswer: "Eiffel Tower",
        explanation: "The image shows the Eiffel Tower in Paris, France.",
        points: 20,
        timeLimit: 30,
        difficulty: "Medium",
        tags: ["Landmark", "Image"],
      ),
      // 5. Image Question
      QuestionModel(
        id: "q5",
        question: "Which country's flag is shown?",
        type: QuestionType.imageQuestion,
        questionImageUrl: "https://example.com/japan_flag.png",
        options: [
          QuestionOption(id: "opt1", text: "Japan", isCorrect: true),
          QuestionOption(id: "opt2", text: "China", isCorrect: false),
          QuestionOption(id: "opt3", text: "South Korea", isCorrect: false),
        ],
        correctAnswer: "Japan",
        explanation: "The flag with a red circle on white background is Japan's flag.",
        points: 15,
        timeLimit: 20,
        difficulty: "Easy",
        tags: ["Flag", "Image"],
      ),
      // 6-10: Add similar questions to fill up 10 questions per category
      QuestionModel(
        id: "q6",
        question: "Which continent is known as the 'Dark Continent'?",
        type: QuestionType.multipleChoice,
        options: [
          QuestionOption(id: "opt1", text: "Africa", isCorrect: true),
          QuestionOption(id: "opt2", text: "Asia", isCorrect: false),
          QuestionOption(id: "opt3", text: "Europe", isCorrect: false),
          QuestionOption(id: "opt4", text: "South America", isCorrect: false),
        ],
        correctAnswer: "Africa",
        explanation: "Africa was historically called the 'Dark Continent'.",
        points: 10,
        timeLimit: 25,
        difficulty: "Medium",
        tags: ["Geography", "Continent"],
      ),

      QuestionModel(
        id: "q8",
        question: "The Statue of Liberty is located in New York.",
        type: QuestionType.trueFalse,
        options: [
          QuestionOption(id: "opt1", text: "True", isCorrect: true),
          QuestionOption(id: "opt2", text: "False", isCorrect: false),
        ],
        correctAnswer: "True",
        explanation: "The Statue of Liberty is in New York Harbor, USA.",
        points: 10,
        timeLimit: 20,
        difficulty: "Easy",
        tags: ["Landmark", "Fact"],
      ),
      QuestionModel(
        id: "q9",
        question: "Identify the animal in the image.",
        type: QuestionType.imageChoice,
        questionImageUrl: "https://example.com/lion.jpg",
        options: [
          QuestionOption(
              id: "opt1",
              text: "Tiger",
              imageUrl: "https://example.com/tiger.jpg",
              isCorrect: false),
          QuestionOption(
              id: "opt2",
              text: "Lion",
              imageUrl: "https://example.com/lion.jpg",
              isCorrect: true),
        ],
        correctAnswer: "Lion",
        explanation: "The image shows a Lion.",
        points: 15,
        timeLimit: 20,
        difficulty: "Medium",
        tags: ["Animals", "Image"],
      ),

    ];


    // Initialize quizzes with model classes
    quizzes.addAll([
      QuizModel(
        id: "quiz_1",
        title: "General Knowledge",
        subtitle: "Test your basic knowledge",
        description:
            "A comprehensive quiz covering various topics including current affairs, basic science, and general awareness",
        type: "FREE",
        color: Colors.purple,
        duration: "15 min",
        difficulty: "Easy",
        category: "General",
        rating: 4.5,
        attempts: 5420,
        imageUrl: "https://img.icons8.com/color/96/brain.png",
        tags: ["Popular", "Beginner"],
        isCompleted: false,
        bestScore: 0,
        questions: generalQuestions,
        createdAt: DateTime.now().subtract(Duration(days: 30)),
      ),
      QuizModel(
        id: "quiz_2",
        title: "Science Fundamentals",
        subtitle: "Basic science concepts",
        description:
            "Explore fundamental concepts in physics, chemistry, and biology suitable for beginners",
        type: "PREMIUM",
        color: Colors.pink,
        duration: "20 min",
        difficulty: "Medium",
        category: "Science",
        rating: 4.6,
        attempts: 2180,
        price: "\$2.99",
        imageUrl: "https://img.icons8.com/color/96/microscope.png",
        tags: ["Educational", "Science"],
        isCompleted: false,
        bestScore: 0,
        questions: scienceQuestions,
        createdAt: DateTime.now().subtract(Duration(days: 20)),
      ),
      QuizModel(
        id: "quiz_3",
        title: "Mathematics Challenge",
        subtitle: "Math problems & puzzles",
        description:
            "Challenge yourself with mathematical problems ranging from basic arithmetic to advanced concepts",
        type: "FREE",
        color: Colors.blue,
        duration: "25 min",
        difficulty: "Medium",
        category: "Mathematics",
        rating: 4.4,
        attempts: 3890,
        imageUrl: "https://img.icons8.com/color/96/calculator.png",
        tags: ["Challenge", "Logic"],
        isCompleted: true,
        bestScore: 120,
        lastAttempt: "2025-09-20",
        questions: mathQuestions,
        createdAt: DateTime.now().subtract(Duration(days: 15)),
      ),
      QuizModel(
        id: "quiz_4",
        title: "Art & Culture",
        subtitle: "Arts, culture & creativity",
        description:
            "Discover the world of art, culture, music, and creative expressions from around the globe",
        type: "PREMIUM",
        color: Colors.amber,
        duration: "18 min",
        difficulty: "Easy",
        category: "Culture",
        rating: 4.3,
        attempts: 1560,
        price: "\$1.99",
        imageUrl: "https://img.icons8.com/color/96/museum.png",
        tags: ["Creative", "Culture"],
        isCompleted: false,
        bestScore: 0,
        questions: [],
        createdAt: DateTime.now().subtract(Duration(days: 25)),
      ),
      QuizModel(
        id: "quiz_5",
        title: "Technology & Innovation",
        subtitle: "Modern tech trends",
        description:
            "Stay updated with the latest in technology, AI, programming, and digital innovations",
        type: "FREE",
        color: Colors.green,
        duration: "20 min",
        difficulty: "Medium",
        category: "Technology",
        rating: 4.7,
        attempts: 4250,
        imageUrl: "https://img.icons8.com/color/96/computer.png",
        tags: ["Trending", "Tech"],
        isCompleted: false,
        bestScore: 0,
        questions: [],
        createdAt: DateTime.now().subtract(Duration(days: 10)),
      ),
      QuizModel(
        id: "quiz_6",
        title: "Sports & Games",
        subtitle: "Sports knowledge test",
        description:
            "Test your knowledge about various sports, famous athletes, and sporting events worldwide",
        type: "FREE",
        color: Colors.orange,
        duration: "16 min",
        difficulty: "Easy",
        category: "Sports",
        rating: 4.2,
        attempts: 2890,
        imageUrl: "https://img.icons8.com/color/96/football.png",
        tags: ["Sports", "Fun"],
        isCompleted: false,
        bestScore: 0,
        questions: [],
        createdAt: DateTime.now().subtract(Duration(days: 5)),
      ),
    ]);

    // Your categories initialization will now work correctly
    categories.addAll([
      CategoryModel(
        id: "cat_general",
        name: "General Knowledge",
        description: "Test your general awareness and basic knowledge",
        imageUrl: "https://img.icons8.com/color/96/brain.png",
        color: Colors.purple,
        type: "free",
        quizzes: [quizzes[0]],
        // General Knowledge quiz
        totalQuestions: generalQuestions.length,
        // Now works
        totalPoints: generalQuestions.fold(0, (sum, q) => sum + q.points),
        // Now works
        totalQuizzes: 1,
        // Fixed value
        createdAt: DateTime.now().subtract(Duration(days: 60)),
      ),
      CategoryModel(
        id: "cat_science",
        name: "Science",
        description: "Explore the world of science and discovery",
        imageUrl: "https://img.icons8.com/color/96/microscope.png",
        color: Colors.pink,
        type: "premium",
        quizzes: [quizzes[1]],
        // Science Fundamentals quiz
        totalQuestions: scienceQuestions.length,
        // Now works
        totalPoints: scienceQuestions.fold(0, (sum, q) => sum + q.points),
        // Now works
        totalQuizzes: 1,
        // Fixed value
        createdAt: DateTime.now().subtract(Duration(days: 45)),
      ),
      CategoryModel(
        id: "cat_math",
        name: "Mathematics",
        description: "Challenge your mathematical skills",
        imageUrl: "https://img.icons8.com/color/96/calculator.png",
        color: Colors.blue,
        type: "free",
        quizzes: [quizzes[2]],
        // Mathematics Challenge quiz
        totalQuestions: mathQuestions.length,
        // Now works
        totalPoints: mathQuestions.fold(0, (sum, q) => sum + q.points),
        // Now works
        totalQuizzes: 1,
        // Fixed value
        createdAt: DateTime.now().subtract(Duration(days: 30)),
      ),
    ]);
  }

  // Start a quiz
  void viewDetails(CategoryModel category) {
    Get.toNamed(AppRoutes.quizList, arguments: {'category': category});
  }
}
