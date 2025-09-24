// lib/features/home/home_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
// import 'package:just_audio/just_audio.dart';
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
  bool isAudioLoaded = false;
  bool isAudioPlaying = false;
  AudioPlayer? musicPlayer;
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
        name: 'puja',
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

  // void startAudio() {
  //   musicPlayer ??= AudioPlayer();
  //   musicPlayer!.setAsset("assets/ringtone/click.mp3");
  //   musicPlayer!.play();
  //   isAudioPlaying = true;
  //   //
  //
  // }
  //
  // void stopAudio() {
  //   musicPlayer?.stop();
  //   isAudioPlaying = false;
  // }


  void startAudio(String file) {
    musicPlayer ??= AudioPlayer();
    musicPlayer!.setAsset("assets/ringtone/$file");
    musicPlayer!.play();
    isAudioPlaying = true;
  }

  void stopAudio() {
    musicPlayer?.stop();
    isAudioPlaying = false;
  }

// inside your answer checking


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
        price: "\₹4.99",
        rating: 4.8,
        enrolledUsers: 1250,
        imageUrl: "https://i0.wp.com/magicofcreativity.com/wp-content/uploads/2016/09/Master-colors1.jpg?fit=813%2C605&ssl=1",
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
        price: "\₹6.99",
        rating: 4.9,
        enrolledUsers: 890,
        imageUrl: "https://yt3.ggpht.com/a/AATXAJzEv9F0T5qMXFeahiizcumObPSSdwLJ3bi0mA=s900-c-k-c0xffffffff-no-rj-mo",
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
        price: "\₹5.99",
        rating: 4.7,
        enrolledUsers: 1100,
        imageUrl: "https://images.twinkl.co.uk/tw1n/image/private/t_630_eco/image_repo/d9/0a/au-t2-h-001-history-display-banner-_ver_1.jpg",
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
        explanation: "Water is composed of two hydrogen atoms and one oxygen atom.",
        points: 15,
        timeLimit: 25,
        difficulty: "Medium",
        tags: ["Chemistry", "Basic"],
      ),

      QuestionModel(
        id: "sq2",
        question: "What planet is known as the Red Planet?",
        type: QuestionType.multipleChoice,
        options: [
          QuestionOption(id: "opt1", text: "Mars", isCorrect: true),
          QuestionOption(id: "opt2", text: "Venus", isCorrect: false),
          QuestionOption(id: "opt3", text: "Jupiter", isCorrect: false),
          QuestionOption(id: "opt4", text: "Saturn", isCorrect: false),
        ],
        correctAnswer: "Mars",
        explanation: "Mars appears red due to iron oxide (rust) on its surface.",
        points: 10,
        timeLimit: 20,
        difficulty: "Easy",
        tags: ["Astronomy"],
      ),

      QuestionModel(
        id: "sq3",
        question: "Which gas do humans inhale to survive?",
        type: QuestionType.multipleChoice,
        options: [
          QuestionOption(id: "opt1", text: "Oxygen", isCorrect: true),
          QuestionOption(id: "opt2", text: "Carbon Dioxide", isCorrect: false),
          QuestionOption(id: "opt3", text: "Nitrogen", isCorrect: false),
          QuestionOption(id: "opt4", text: "Hydrogen", isCorrect: false),
        ],
        correctAnswer: "Oxygen",
        explanation: "Humans need oxygen for cellular respiration.",
        points: 10,
        timeLimit: 20,
        difficulty: "Easy",
        tags: ["Biology"],
      ),

      QuestionModel(
        id: "sq4",
        question: "What is the speed of light in vacuum?",
        type: QuestionType.multipleChoice,
        options: [
          QuestionOption(id: "opt1", text: "3 × 10^8 m/s", isCorrect: true),
          QuestionOption(id: "opt2", text: "1.5 × 10^8 m/s", isCorrect: false),
          QuestionOption(id: "opt3", text: "3 × 10^6 m/s", isCorrect: false),
          QuestionOption(id: "opt4", text: "1 × 10^5 m/s", isCorrect: false),
        ],
        correctAnswer: "3 × 10^8 m/s",
        explanation: "Light travels at approximately 300,000 km/s in a vacuum.",
        points: 20,
        timeLimit: 30,
        difficulty: "Hard",
        tags: ["Physics"],
      ),

      QuestionModel(
        id: "sq5",
        question: "Which vitamin is produced in the skin with the help of sunlight?",
        type: QuestionType.multipleChoice,
        options: [
          QuestionOption(id: "opt1", text: "Vitamin A", isCorrect: false),
          QuestionOption(id: "opt2", text: "Vitamin B12", isCorrect: false),
          QuestionOption(id: "opt3", text: "Vitamin D", isCorrect: true),
          QuestionOption(id: "opt4", text: "Vitamin C", isCorrect: false),
        ],
        correctAnswer: "Vitamin D",
        explanation: "Sunlight helps the body produce Vitamin D from cholesterol.",
        points: 15,
        timeLimit: 25,
        difficulty: "Medium",
        tags: ["Biology", "Health"],
      ),

      QuestionModel(
        id: "sq6",
        question: "Who is known as the father of modern physics?",
        type: QuestionType.multipleChoice,
        options: [
          QuestionOption(id: "opt1", text: "Isaac Newton", isCorrect: false),
          QuestionOption(id: "opt2", text: "Albert Einstein", isCorrect: true),
          QuestionOption(id: "opt3", text: "Galileo Galilei", isCorrect: false),
          QuestionOption(id: "opt4", text: "Niels Bohr", isCorrect: false),
        ],
        correctAnswer: "Albert Einstein",
        explanation: "Einstein's theories revolutionized physics in the 20th century.",
        points: 15,
        timeLimit: 25,
        difficulty: "Medium",
        tags: ["Physics", "History"],
      ),

      QuestionModel(
        id: "sq7",
        question: "What is the powerhouse of the cell?",
        type: QuestionType.multipleChoice,
        options: [
          QuestionOption(id: "opt1", text: "Nucleus", isCorrect: false),
          QuestionOption(id: "opt2", text: "Mitochondria", isCorrect: true),
          QuestionOption(id: "opt3", text: "Ribosome", isCorrect: false),
          QuestionOption(id: "opt4", text: "Chloroplast", isCorrect: false),
        ],
        correctAnswer: "Mitochondria",
        explanation: "Mitochondria produce energy in the form of ATP.",
        points: 10,
        timeLimit: 20,
        difficulty: "Easy",
        tags: ["Biology"],
      ),

      QuestionModel(
        id: "sq8",
        question: "Which element has the chemical symbol 'Fe'?",
        type: QuestionType.multipleChoice,
        options: [
          QuestionOption(id: "opt1", text: "Iron", isCorrect: true),
          QuestionOption(id: "opt2", text: "Fluorine", isCorrect: false),
          QuestionOption(id: "opt3", text: "Francium", isCorrect: false),
          QuestionOption(id: "opt4", text: "Fermium", isCorrect: false),
        ],
        correctAnswer: "Iron",
        explanation: "Fe comes from the Latin word 'Ferrum', meaning iron.",
        points: 15,
        timeLimit: 25,
        difficulty: "Medium",
        tags: ["Chemistry"],
      ),

      QuestionModel(
        id: "sq9",
        question: "Which organ in the human body purifies blood?",
        type: QuestionType.multipleChoice,
        options: [
          QuestionOption(id: "opt1", text: "Heart", isCorrect: false),
          QuestionOption(id: "opt2", text: "Liver", isCorrect: false),
          QuestionOption(id: "opt3", text: "Kidney", isCorrect: true),
          QuestionOption(id: "opt4", text: "Lungs", isCorrect: false),
        ],
        correctAnswer: "Kidney",
        explanation: "The kidneys filter waste from blood and produce urine.",
        points: 15,
        timeLimit: 25,
        difficulty: "Medium",
        tags: ["Biology", "Human Body"],
      ),

      QuestionModel(
        id: "sq10",
        question: "What is the largest planet in our Solar System?",
        type: QuestionType.multipleChoice,
        options: [
          QuestionOption(id: "opt1", text: "Earth", isCorrect: false),
          QuestionOption(id: "opt2", text: "Saturn", isCorrect: false),
          QuestionOption(id: "opt3", text: "Jupiter", isCorrect: true),
          QuestionOption(id: "opt4", text: "Neptune", isCorrect: false),
        ],
        correctAnswer: "Jupiter",
        explanation: "Jupiter is the largest planet, with a mass 318 times that of Earth.",
        points: 10,
        timeLimit: 20,
        difficulty: "Easy",
        tags: ["Astronomy"],
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

      QuestionModel(
        id: "mq2",
        question: "What is 12 × 8?",
        type: QuestionType.multipleChoice,
        options: [
          QuestionOption(id: "opt1", text: "96", isCorrect: true),
          QuestionOption(id: "opt2", text: "86", isCorrect: false),
          QuestionOption(id: "opt3", text: "108", isCorrect: false),
          QuestionOption(id: "opt4", text: "88", isCorrect: false),
        ],
        correctAnswer: "96",
        explanation: "12 × 8 = 96",
        points: 10,
        timeLimit: 20,
        difficulty: "Easy",
        tags: ["Multiplication", "Basic"],
      ),

      QuestionModel(
        id: "mq3",
        question: "What is the square root of 144?",
        type: QuestionType.multipleChoice,
        options: [
          QuestionOption(id: "opt1", text: "10", isCorrect: false),
          QuestionOption(id: "opt2", text: "11", isCorrect: false),
          QuestionOption(id: "opt3", text: "12", isCorrect: true),
          QuestionOption(id: "opt4", text: "14", isCorrect: false),
        ],
        correctAnswer: "12",
        explanation: "√144 = 12",
        points: 15,
        timeLimit: 25,
        difficulty: "Medium",
        tags: ["Square Root"],
      ),

      QuestionModel(
        id: "mq4",
        question: "Solve: 50 ÷ 5",
        type: QuestionType.multipleChoice,
        options: [
          QuestionOption(id: "opt1", text: "5", isCorrect: false),
          QuestionOption(id: "opt2", text: "10", isCorrect: true),
          QuestionOption(id: "opt3", text: "15", isCorrect: false),
          QuestionOption(id: "opt4", text: "20", isCorrect: false),
        ],
        correctAnswer: "10",
        explanation: "50 ÷ 5 = 10",
        points: 10,
        timeLimit: 20,
        difficulty: "Easy",
        tags: ["Division", "Basic"],
      ),

      QuestionModel(
        id: "mq5",
        question: "What is the value of π (approx)?",
        type: QuestionType.multipleChoice,
        options: [
          QuestionOption(id: "opt1", text: "2.14", isCorrect: false),
          QuestionOption(id: "opt2", text: "3.14", isCorrect: true),
          QuestionOption(id: "opt3", text: "4.13", isCorrect: false),
          QuestionOption(id: "opt4", text: "3.41", isCorrect: false),
        ],
        correctAnswer: "3.14",
        explanation: "The approximate value of π is 3.14159 ≈ 3.14",
        points: 15,
        timeLimit: 25,
        difficulty: "Medium",
        tags: ["Geometry", "Constants"],
      ),

      QuestionModel(
        id: "mq6",
        question: "If a triangle has angles 90°, 45°, and 45°, what type is it?",
        type: QuestionType.multipleChoice,
        options: [
          QuestionOption(id: "opt1", text: "Equilateral", isCorrect: false),
          QuestionOption(id: "opt2", text: "Isosceles Right", isCorrect: true),
          QuestionOption(id: "opt3", text: "Scalene", isCorrect: false),
          QuestionOption(id: "opt4", text: "Obtuse", isCorrect: false),
        ],
        correctAnswer: "Isosceles Right",
        explanation: "A 90°, 45°, 45° triangle is an isosceles right triangle.",
        points: 20,
        timeLimit: 30,
        difficulty: "Medium",
        tags: ["Geometry", "Triangles"],
      ),

      QuestionModel(
        id: "mq7",
        question: "What is 7²?",
        type: QuestionType.multipleChoice,
        options: [
          QuestionOption(id: "opt1", text: "42", isCorrect: false),
          QuestionOption(id: "opt2", text: "47", isCorrect: false),
          QuestionOption(id: "opt3", text: "49", isCorrect: true),
          QuestionOption(id: "opt4", text: "56", isCorrect: false),
        ],
        correctAnswer: "49",
        explanation: "7 × 7 = 49",
        points: 10,
        timeLimit: 20,
        difficulty: "Easy",
        tags: ["Squares", "Basic"],
      ),

      QuestionModel(
        id: "mq8",
        question: "If x = 5, what is the value of 2x + 3?",
        type: QuestionType.multipleChoice,
        options: [
          QuestionOption(id: "opt1", text: "10", isCorrect: false),
          QuestionOption(id: "opt2", text: "12", isCorrect: false),
          QuestionOption(id: "opt3", text: "13", isCorrect: true),
          QuestionOption(id: "opt4", text: "15", isCorrect: false),
        ],
        correctAnswer: "13",
        explanation: "2 × 5 + 3 = 10 + 3 = 13",
        points: 15,
        timeLimit: 25,
        difficulty: "Medium",
        tags: ["Algebra"],
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
        questionImageUrl:
        "https://upload.wikimedia.org/wikipedia/commons/a/a8/Tour_Eiffel_Wikimedia_Commons.jpg", // Eiffel Tower
        options: [
          QuestionOption(
              id: "opt1",
              text: "Statue of Liberty",
              imageUrl:
              "https://upload.wikimedia.org/wikipedia/commons/a/a1/Statue_of_Liberty_7.jpg",
              isCorrect: false),
          QuestionOption(
              id: "opt2",
              text: "Eiffel Tower",
              imageUrl:
              "https://upload.wikimedia.org/wikipedia/commons/a/a8/Tour_Eiffel_Wikimedia_Commons.jpg",
              isCorrect: true),
          QuestionOption(
              id: "opt3",
              text: "Big Ben",
              imageUrl:
              "https://as2.ftcdn.net/v2/jpg/01/02/15/85/1000_F_102158532_QuFWceYGUVGS2Buo0UFujTTeGGVsQFGh.jpg",
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
        questionImageUrl:
        "https://th.bing.com/th/id/R.12a9e02aa7f57016fd6b34560abd1bfa?rik=ZiAUUlEeCeSVsA&riu=http%3a%2f%2fwww.rankflags.com%2fwp-content%2fuploads%2f2015%2f05%2fPicture-Of-Japan-Flag.jpg&ehk=AtcV477o%2fViy7WZe0lxqzrrpiyV%2f8G3y2gXxlZlfuHk%3d&risl=&pid=ImgRaw&r=0",
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

      // 6. Multiple Choice
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

      // 8. True/False
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

      // 9. Image Choice
      QuestionModel(
        id: "q9",
        question: "Identify the animal in the image.",
        type: QuestionType.imageChoice,
        questionImageUrl:
        "https://upload.wikimedia.org/wikipedia/commons/7/73/Lion_waiting_in_Namibia.jpg", // Lion
        options: [
          QuestionOption(
              id: "opt1",
              text: "Tiger",
              imageUrl:
              "https://upload.wikimedia.org/wikipedia/commons/5/56/Tiger.50.jpg",
              isCorrect: false),
          QuestionOption(
              id: "opt2",
              text: "Lion",
              imageUrl:
              "https://upload.wikimedia.org/wikipedia/commons/7/73/Lion_waiting_in_Namibia.jpg",
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
        "A comprehensive quiz covering various topics including current affairs, basic science, and general awareness.",
        type: "FREE",
        color: Colors.purple,
        duration: "15 min",
        difficulty: "Easy",
        category: "General",
        rating: 4.5,
        attempts: 5420,
        imageUrl: "https://img.freepik.com/premium-photo/human-brain-book-color-background-minimal-abstract-concept-school-culture-intelligence-reading-education-charger-brain-idea-generative-ai_58409-29271.jpg",
        tags: ["Popular", "Beginner"],
        isCompleted: false,
        bestScore: 0,
        questions: generalQuestions,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        termsAndConditions: [
          "Each player can attempt the quiz only once per day.",
          "Leaderboard is refreshed daily at midnight.",
          "No negative marking for wrong answers.",
          "Prizes (if applicable) will be distributed within 24 hours.",
          "By joining, you agree to our fair-play policy.",
        ],
      ),
      QuizModel(
        id: "quiz_2",
        title: "Science Fundamentals",
        subtitle: "Basic science concepts",
        description:
        "Explore fundamental concepts in physics, chemistry, and biology suitable for beginners.",
        type: "PREMIUM",
        color: Colors.pink,
        duration: "20 min",
        difficulty: "Medium",
        category: "Science",
        rating: 4.6,
        attempts: 2180,
        price: "₹2.99",
        imageUrl: "https://img.freepik.com/free-vector/hand-drawn-science-education-background_23-2148494536.jpg?size=626&ext=jpg",
        tags: ["Educational", "Science"],
        isCompleted: false,
        bestScore: 0,
        questions: scienceQuestions,
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        prize: "₹200",
        termsAndConditions: [
          "Joining fee is non-refundable.",
          "Top 3 scorers will receive the prize money.",
          "Cheating or multiple logins will disqualify participants.",
          "Prize will be credited to your wallet within 48 hours.",
          "The decision of the organizers will be final.",
          "By joining, you accept all terms & conditions.",
        ],
      ),
      QuizModel(
        id: "quiz_3",
        title: "Mathematics Challenge",
        subtitle: "Math problems & puzzles",
        description:
        "Challenge yourself with mathematical problems ranging from basic arithmetic to advanced concepts.",
        type: "FREE",
        color: Colors.blue,
        duration: "25 min",
        difficulty: "Medium",
        category: "Mathematics",
        rating: 4.4,
        attempts: 3890,
        imageUrl: "https://img.freepik.com/free-vector/maths-realistic-chalkboard-background_23-2148159115.jpg?w=2000",
        tags: ["Challenge", "Logic"],
        isCompleted: true,
        bestScore: 120,
        lastAttempt: "2025-09-20",
        questions: mathQuestions,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        termsAndConditions: [
          "This quiz is for practice purposes only.",
          "You can retry multiple times to improve your score.",
          "Leaderboard ranks are visible to all players.",
          "Share with friends to unlock bonus challenges.",
        ],
      ),
      QuizModel(
        id: "quiz_4",
        title: "Art & Culture",
        subtitle: "Arts, culture & creativity",
        description:
        "Discover the world of art, culture, music, and creative expressions from around the globe.",
        type: "PREMIUM",
        color: Colors.amber,
        duration: "18 min",
        difficulty: "Easy",
        category: "Culture",
        rating: 4.3,
        attempts: 1560,
        price: "₹1.99",
        imageUrl: "https://tse1.mm.bing.net/th/id/OIP.Ogla9WteCseMDLa4APr9YQHaEQ?rs=1&pid=ImgDetMain&o=7&rm=3",
        tags: ["Creative", "Culture"],
        isCompleted: false,
        bestScore: 0,
        questions: [],
        createdAt: DateTime.now().subtract(const Duration(days: 25)),
        prize: "₹150",
        termsAndConditions: [
          "Participation fee applies to all players.",
          "Prize will be awarded to the highest scorer.",
          "In case of tie, prize will be shared equally.",
          "Ensure stable internet connection during play.",
          "Organizers reserve the right to disqualify fraud accounts.",
        ],
      ),
      QuizModel(
        id: "quiz_5",
        title: "Technology & Innovation",
        subtitle: "Modern tech trends",
        description:
        "Stay updated with the latest in technology, AI, programming, and digital innovations.",
        type: "FREE",
        color: Colors.green,
        duration: "20 min",
        difficulty: "Medium",
        category: "Technology",
        rating: 4.7,
        attempts: 4250,
        imageUrl: "https://thumbs.dreamstime.com/z/creative-innovation-technology-ideas-inspiration-concept-60795016.jpg",
        tags: ["Trending", "Tech"],
        isCompleted: false,
        bestScore: 0,
        questions: [],
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        termsAndConditions: [
          "Free for all registered players.",
          "Top scorers will be featured on the leaderboard.",
          "Can be attempted once per user.",
          "No cash prize for free category quizzes.",
        ],
      ),
      QuizModel(
        id: "quiz_6",
        title: "Sports & Games",
        subtitle: "Sports knowledge test",
        description:
        "Test your knowledge about various sports, famous athletes, and sporting events worldwide.",
        type: "FREE",
        color: Colors.orange,
        duration: "16 min",
        difficulty: "Easy",
        category: "Sports",
        rating: 4.2,
        attempts: 2890,
        imageUrl: "https://images.squarespace-cdn.com/content/v1/58ee0b551e5b6c8ff18b94ad/1699891416586-ISX1YK543UHUKVS9WHSA/sports+quiz+questions+and+answers.jpg",
        tags: ["Sports", "Fun"],
        isCompleted: false,
        bestScore: 0,
        questions: [],
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        termsAndConditions: [
          "Each player can join unlimited times.",
          "Leaderboard is updated in real-time.",
          "Top scorers get special badges.",
          "This is a free-to-play quiz, no prize included.",
        ],
      ),
    ]);


    // Your categories initialization will now work correctly
    categories.addAll([
      CategoryModel(
        id: "cat_general",
        name: "General Knowledge",
        description: "Test your general awareness and basic knowledge",
        imageUrl: "https://img.freepik.com/premium-photo/knowledge-ideas-human-head_597582-505.jpg",
        color: Colors.purple,
        type: "free",
        quizzes: [quizzes[0],quizzes[5]],
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
        imageUrl: "https://img.freepik.com/free-vector/hand-drawn-science-education-background_23-2148494536.jpg?size=626&ext=jpg",
        color: Colors.pink,
        type: "premium",
        quizzes: [quizzes[1],quizzes[3]],
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
        imageUrl: "https://img.freepik.com/free-vector/maths-realistic-chalkboard-background_23-2148159115.jpg?w=2000",
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
