import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_application/features/bg/bg.dart';
import '../../mode/quiz_model.dart';
import '../../mode/question_model.dart';
import '../../routes/app_routes.dart';

const Color _card = Colors.white; // Card background color

class QuizResultScreen extends StatelessWidget {
  const QuizResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>;
    final QuizModel quiz = args['quiz'] as QuizModel;
    final Map<String, String> selectedAnswers =
    args['answers'] as Map<String, String>; // questionId -> optionId

    int totalQuestions = quiz.questions.length;
    int correct = quiz.questions.where((q) {
      final selectedOptionId = selectedAnswers[q.id];
      if (selectedOptionId == null) return false;
      final selectedOption = q.options.firstWhere((o) => o.id == selectedOptionId);
      return selectedOption.isCorrect;
    }).length;
    int wrong = totalQuestions - correct;
    double completion = totalQuestions > 0 ? correct / totalQuestions : 0;
    int totalScore = quiz.questions.fold<int>(0, (prev, q) {
      final selectedOptionId = selectedAnswers[q.id];
      if (selectedOptionId == null) return prev;
      final selectedOption = q.options.firstWhere((o) => o.id == selectedOptionId);
      return prev + (selectedOption.isCorrect ? q.points : 0);
    });

    return Scaffold(
      body: Stack(

        children: [
          PurpleBackground(),
          SafeArea(
            child: Column(
              children: [
                // App bar row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      _GlassIconButton(
                        icon: Icons.arrow_back,
                        onTap: () => Get.offAllNamed('/home'),
                      ),
                      const Spacer(),
                      _GlassIconButton(
                        icon: Icons.more_horiz,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),

                // Score ring
                const SizedBox(height: 20),
                _ScoreRing(
                  score: totalScore,
                  completion: completion,
                  color: Colors.amber,
                ),
                const SizedBox(height: 50),

                // Stats card
                _StatsCard(
                  completionPct: (completion * 100).round(),
                  total: totalQuestions,
                  correct: correct,
                  wrong: wrong,
                ),
                const SizedBox(height: 12),

                // Actions grid
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                //   child: GridView(
                //     shrinkWrap: true,
                //     physics: const NeverScrollableScrollPhysics(),
                //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                //       crossAxisCount: 3,
                //       crossAxisSpacing: 12,
                //       mainAxisSpacing: 12,
                //       childAspectRatio: 1.1,
                //     ),
                //     children: [
                //       IconAction(
                //         icon: Icons.refresh_rounded,
                //         label: 'Play Again',
                //         onTap: () => Get.offNamed('/quiz-play', arguments: quiz),
                //       ),
                //       IconAction(
                //         icon: Icons.visibility_rounded,
                //         label: 'Review Answer',
                //         onTap: () {},
                //       ),
                //       IconAction(
                //         icon: Icons.share_rounded,
                //         label: 'Share Score',
                //         onTap: () {},
                //       ),
                //       IconAction(
                //         icon: Icons.picture_as_pdf_rounded,
                //         label: 'Generate PDF',
                //         onTap: () {},
                //       ),
                //       IconAction(
                //         icon: Icons.home_rounded,
                //         label: 'Home',
                //         onTap: () => Get.offAllNamed('/home'),
                //       ),
                //       IconAction(
                //         icon: Icons.emoji_events_rounded,
                //         label: 'Leaderboard',
                //         onTap: () {Get.offAllNamed(AppRoutes.leaderboard);},
                //       ),
                //     ],
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 90,
                          child: IconAction(
                            icon: Icons.home_rounded,
                            label: 'Home',
                            onTap: () => Get.offAllNamed('/home'),
                          ),
                        ),
                      ),
                      SizedBox(width: 20,),
                      Expanded(
                        child: SizedBox(
                          height: 90,
                          child: IconAction(
                            icon: Icons.emoji_events_rounded,
                            label: 'Leaderboard',
                            onTap: () {Get.offAllNamed(AppRoutes.leaderboard);},
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// =====================
/// CUSTOM WIDGETS
/// =====================

class IconAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const IconAction(
      {super.key, required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
         color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: cs.primary, size: 24),
            const SizedBox(height: 8),
            Text(label,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _ScoreRing extends StatelessWidget {
  final int score;
  final double completion;
  final Color color;
  const _ScoreRing(
      {required this.score, required this.completion, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: 200,
            width: 200,
            child: CircularProgressIndicator(
              value: completion.clamp(0.0, 1.0),
              strokeWidth: 14,
              backgroundColor: Colors.white24,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Your Score',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 4),
              Text(
                '$score pt',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  final int completionPct;
  final int total;
  final int correct;
  final int wrong;
  const _StatsCard(
      {required this.completionPct,
        required this.total,
        required this.correct,
        required this.wrong});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(
              title: 'Completion',
              value: '$completionPct%',
              color: Colors.purple),
          _StatItem(
              title: 'Total Question', value: '$total', color: Colors.deepPurple),
          _StatItem(title: 'Correct', value: '$correct', color: Colors.green),
          _StatItem(title: 'Wrong', value: '$wrong', color: Colors.redAccent),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  const _StatItem(
      {required this.title, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                fontWeight: FontWeight.w700, color: color, fontSize: 16)),
        const SizedBox(height: 6),
        Text(
          title,
          style: const TextStyle(color: Colors.black87, fontSize: 13,fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class _GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _GlassIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 28,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.20),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}
