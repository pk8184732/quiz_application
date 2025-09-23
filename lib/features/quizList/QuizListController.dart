// lib/features/quiz_list/quiz_list_controller.dart
import 'package:get/get.dart';

import '../../mode/category_model.dart';
import '../../mode/quiz_model.dart';


class QuizListController extends GetxController {
  // Observables
  var isLoading = false.obs;
  var selectedCategory = Rxn<CategoryModel>();
  var allQuizzes = <QuizModel>[].obs;
  var filteredQuizzes = <QuizModel>[].obs;

  // Filter states
  var selectedDifficulties = <String>[].obs;
  var selectedTypes = <String>[].obs;
  var sortBy = 'Popular'.obs;

  @override
  void onInit() {
    super.onInit();

    // Get arguments passed from previous screen
    final arguments = Get.arguments;
    if (arguments != null) {
      if (arguments['category'] != null) {
        selectedCategory.value = arguments['category'];
        allQuizzes.value = selectedCategory.value!.quizzes;
      } else if (arguments['quizzes'] != null) {
        allQuizzes.value = arguments['quizzes'];
      }
    }

    // Initialize filtered quizzes
    filteredQuizzes.value = allQuizzes;

    loadQuizzes();
  }

  void loadQuizzes() {
    isLoading.value = true;

    // Simulate loading delay
    Future.delayed(const Duration(milliseconds: 800), () {
      applyFilters();
      isLoading.value = false;
    });
  }

  void applyFilters() {
    var filtered = List<QuizModel>.from(allQuizzes);

    // Apply difficulty filter
    if (selectedDifficulties.isNotEmpty) {
      filtered = filtered.where((quiz) =>
          selectedDifficulties.contains(quiz.difficulty)).toList();
    }

    // Apply type filter
    if (selectedTypes.isNotEmpty) {
      filtered = filtered.where((quiz) =>
          selectedTypes.contains(quiz.type)).toList();
    }

    // Apply sorting
    switch (sortBy.value) {
      case 'Popular':
        filtered.sort((a, b) => b.attempts.compareTo(a.attempts));
        break;
      case 'Newest':
        filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'Rating':
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'Difficulty':
        final difficultyOrder = {'Easy': 1, 'Medium': 2, 'Hard': 3};
        filtered.sort((a, b) {
          final aOrder = difficultyOrder[a.difficulty] ?? 0;
          final bOrder = difficultyOrder[b.difficulty] ?? 0;
          return aOrder.compareTo(bOrder);
        });
        break;
    }

    filteredQuizzes.value = filtered;
  }

  void toggleDifficultyFilter(String difficulty) {
    if (selectedDifficulties.contains(difficulty)) {
      selectedDifficulties.remove(difficulty);
    } else {
      selectedDifficulties.add(difficulty);
    }
  }

  void toggleTypeFilter(String type) {
    if (selectedTypes.contains(type)) {
      selectedTypes.remove(type);
    } else {
      selectedTypes.add(type);
    }
  }

  void setSortBy(String sortOption) {
    sortBy.value = sortOption;
    applyFilters();
  }

  void clearFilters() {
    selectedDifficulties.clear();
    selectedTypes.clear();
    sortBy.value = 'Popular';
    applyFilters();
  }

  void startQuiz(String quizId) {
    final quiz = allQuizzes.firstWhere((q) => q.id == quizId);
    Get.toNamed('/quiz-detail', arguments: {'quiz': quiz});
  }
}
