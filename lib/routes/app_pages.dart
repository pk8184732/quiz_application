import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:quiz_application/features/home/home.dart';
import 'package:quiz_application/features/quiz/quiz_screen.dart';
import 'package:quiz_application/features/quizList/QuizListScreen.dart';
import 'package:quiz_application/features/quiz_details/quiz_details_screen.dart';
import 'package:quiz_application/features/result_screen/result_screen.dart';
import 'package:quiz_application/features/welcome/welcome_screen.dart';
import '../features/leaderboard/leaderboard_screen.dart';
import 'app_routes.dart';

class AppRoutePages {
  static var getPages = [
    GetPage(
      name: AppRoutes.start,
      page: () => WelcomeScreen(),
      transition: Transition.noTransition,
    ),

    GetPage(
      name: AppRoutes.home,
      page: () => HomeScreen(),
      transition: Transition.size,
    ),
    GetPage(
      name: AppRoutes.quizList,
      page: () => QuizListScreen(),
      transition: Transition.size,
    ),
    GetPage(
      name: AppRoutes.quiz,
      page: () => QuizPlayScreen(),
      transition: Transition.size,
    ),
    GetPage(
      name: AppRoutes.quizResult,
      page: () => QuizResultScreen(),
      transition: Transition.size,
    ),
    GetPage(
      name: AppRoutes.leaderboard,
      page: () => LeaderboardScreen(),
      transition: Transition.size,
    ),
    GetPage(
      name: AppRoutes.details,
      page: () => QuizDetailsScreen(),
      transition: Transition.size,
    ),
  ];
}
