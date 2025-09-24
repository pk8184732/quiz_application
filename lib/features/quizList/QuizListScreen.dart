// lib/features/quiz_list/quiz_list_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_application/features/bg/bg.dart';
import 'package:quiz_application/routes/app_routes.dart';

import 'QuizListController.dart';

class QuizListScreen extends StatelessWidget {
  const QuizListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(QuizListController());

    return Scaffold(
      body: Stack(
          children: [
          PurpleBackground(),
      CustomScrollView(
        slivers: [
          // Header with image, title, and description
          SliverAppBar(
            expandedHeight: 280,
            floating: false,
            pinned: true,
            backgroundColor: Colors.deepPurple,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Get.back(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.deepPurple,
                      Colors.deepPurple.withOpacity(0.8),
                    ],
                  ),
                ),
                child: Obx(() {
                  final category = controller.selectedCategory.value;
                  return Stack(
                    children: [
                      // Background Image
                      Positioned.fill(
                        child: Image.network(
                          category?.imageUrl ?? "https://img.icons8.com/color/96/brain.png",
                          fit: BoxFit.cover,
                          color: Colors.black.withOpacity(0.3),
                          colorBlendMode: BlendMode.darken,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.deepPurple.withOpacity(0.3),
                              child: Icon(
                                Icons.quiz,
                                size: 80,
                                color: Colors.white.withOpacity(0.5),
                              ),
                            );
                          },
                        ),
                      ),

                      // Content Overlay
                      Positioned(
                        bottom: 40,
                        left: 16,
                        right: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Category Title
                            Text(
                              category?.name ?? "All Quizzes",
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    offset: Offset(0, 2),
                                    blurRadius: 4,
                                    color: Colors.black26,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Category Description
                            Text(
                              category?.description ?? "Explore all available quizzes and test your knowledge",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                                height: 1.4,
                                shadows: [
                                  Shadow(
                                    offset: Offset(0, 1),
                                    blurRadius: 2,
                                    color: Colors.black26,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Stats Row
                            Row(
                              children: [
                                _buildStatItem(
                                  Icons.quiz,
                                  "${controller.filteredQuizzes.length} Quizzes",
                                ),
                                const SizedBox(width: 16),
                                _buildStatItem(
                                  Icons.star,
                                  "${category?.averageRating.toStringAsFixed(1) ?? '4.5'}",
                                ),
                                const SizedBox(width: 16),
                                _buildStatItem(
                                  Icons.access_time,
                                   "45 min",
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),

          // Filter and Sort Bar
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Filter Button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _showFilterBottomSheet(context, controller),
                      icon: Icon(Icons.filter_list, size: 18),
                      label: Text("Filter"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.deepPurple,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Sort Button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _showSortOptions(context, controller),
                      icon: Icon(Icons.sort, size: 18),
                      label: Text("Sort"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.deepPurple,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Quiz List
          Obx(() {
            if (controller.isLoading.value) {
              return SliverToBoxAdapter(
                child: Container(
                  height: 300,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
              );
            }

            final quizzes = controller.filteredQuizzes;

            if (quizzes.isEmpty) {
              return SliverToBoxAdapter(
                child: Container(
                  height: 300,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.quiz_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "No quizzes found",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Try adjusting your filters",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            return SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final quiz = quizzes[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildQuizCard(quiz, controller),
                    );
                  },
                  childCount: quizzes.length,
                ),
              ),
            );
          }),
        ],
      ),]
    ));
  }

  Widget _buildStatItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.white70,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildQuizCard(dynamic quiz, QuizListController controller) {
    return GestureDetector(
      onTap: () =>  Get.toNamed(AppRoutes.quiz, arguments: quiz),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              quiz.color,
              quiz.color.withOpacity(0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: quiz.color.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quiz Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Quiz Title
                        Text(
                          quiz.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),

                        // Quiz Subtitle
                        Text(
                          quiz.subtitle,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Type Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: quiz.isPremium
                          ? Colors.amber.withOpacity(0.2)
                          : Colors.green.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: quiz.isPremium ? Colors.amber : Colors.green,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      quiz.type,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: quiz.isPremium ? Colors.amber : Colors.green,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Description
              Text(
                quiz.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 16),

              // Stats Row
              Row(
                children: [
                  _buildQuizStat(Icons.help_outline, "${quiz.totalQuestions}"),
                  const SizedBox(width: 16),
                  _buildQuizStat(Icons.access_time, quiz.duration),
                  const SizedBox(width: 16),
                  _buildQuizStat(Icons.signal_cellular_alt, quiz.difficulty),
                  const Spacer(),

                  // Rating
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star,
                          size: 14,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          quiz.rating.toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),


            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuizStat(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
          color: Colors.white70,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  void _showFilterBottomSheet(BuildContext context, QuizListController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Filter Quizzes",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () => controller.clearFilters(),
                  child: const Text("Clear All"),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Difficulty Filter
            const Text(
              "Difficulty",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Obx(() => Wrap(
              spacing: 8,
              children: ['Easy', 'Medium', 'Hard'].map((difficulty) {
                final isSelected = controller.selectedDifficulties.contains(difficulty);
                return FilterChip(
                  label: Text(difficulty),
                  selected: isSelected,
                  onSelected: (selected) => controller.toggleDifficultyFilter(difficulty),
                  backgroundColor: Colors.grey[200],
                  selectedColor: Colors.deepPurple.withOpacity(0.2),
                  checkmarkColor: Colors.deepPurple,
                );
              }).toList(),
            )),

            const SizedBox(height: 20),

            // Type Filter
            const Text(
              "Type",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Obx(() => Wrap(
              spacing: 8,
              children: ['FREE', 'PREMIUM'].map((type) {
                final isSelected = controller.selectedTypes.contains(type);
                return FilterChip(
                  label: Text(type),
                  selected: isSelected,
                  onSelected: (selected) => controller.toggleTypeFilter(type),
                  backgroundColor: Colors.grey[200],
                  selectedColor: Colors.deepPurple.withOpacity(0.2),
                  checkmarkColor: Colors.deepPurple,
                );
              }).toList(),
            )),

            const Spacer(),

            // Apply Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  controller.applyFilters();
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Apply Filters",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSortOptions(BuildContext context, QuizListController controller) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Sort By",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            ...['Popular', 'Newest', 'Rating', 'Difficulty'].map((option) {
              return ListTile(
                title: Text(option),
                trailing: Obx(() => Radio<String>(
                  value: option,
                  groupValue: controller.sortBy.value,
                  onChanged: (value) {
                    controller.setSortBy(value!);
                    Get.back();
                  },
                  activeColor: Colors.deepPurple,
                )),
                onTap: () {
                  controller.setSortBy(option);
                  Get.back();
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
