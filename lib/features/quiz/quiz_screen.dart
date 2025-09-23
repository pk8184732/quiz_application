import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_application/features/quiz/quiz_play_controller.dart';
import '../../mode/quiz_model.dart';
import '../../mode/question_model.dart';

class QuizPlayScreen extends StatelessWidget {
  const QuizPlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final QuizModel quiz = Get.arguments as QuizModel;
    final controller = Get.put(QuizPlayController(quiz: quiz));

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Obx(() => Text(
          "${quiz.title} • Q${controller.currentIndex.value + 1}/${quiz.questions.length}",
          style: const TextStyle(fontWeight: FontWeight.w600),
        )),
        titleTextStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
        centerTitle: false,
      ),
      bottomNavigationBar: Container(
        height: 90,
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            Obx(() => ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: (controller.currentIndex.value + 1) / (quiz.questions.isEmpty ? 1 : quiz.questions.length),
                color: Colors.amber,
                backgroundColor: Colors.white.withOpacity(0.15),
                minHeight: 6,
              ),
            )),
            const SizedBox(height: 12),
            // Bottom bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => Text(
                  "Q ${controller.currentIndex.value + 1}/${quiz.questions.length}",
                  style: TextStyle(color: Colors.white.withOpacity(0.9)),
                )),
                Obx(() {
                  final isLastQuestion = controller.currentIndex.value == quiz.questions.length - 1;
                  return TextButton(
                    onPressed: isLastQuestion ? controller.finishQuiz : controller.skipQuestion,
                    style: TextButton.styleFrom(foregroundColor: Colors.white),
                    child: Text(isLastQuestion ? "Finish" : "Skip"),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          final question = controller.currentQuestion;

          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(
                    children: [
                      const Icon(Icons.timer, size: 24, color: Colors.white),
                      const SizedBox(width: 4),
                      Text(
                        "${controller.timeLeft.value}s",
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                      const Spacer(),
                      const Icon(Icons.star, color: Colors.amber, size: 24),
                      const SizedBox(width: 4),
                      // Animated score
                      Obx(() {
                        return TweenAnimationBuilder<int>(
                          tween: IntTween(begin: controller.oldScore.value, end: controller.score.value),
                          duration: const Duration(milliseconds: 600),
                          builder: (context, value, child) {
                            return Text(
                              "$value",
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
                            );
                          },
                        );
                      }),
                      const SizedBox(width: 4),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Question text
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          question.question,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 18),
                        _buildQuestionType(question, controller),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildQuestionType(QuestionModel question, QuizPlayController controller) {
    switch (question.type) {
      case QuestionType.multipleChoice:
      case QuestionType.imageChoice:
        return Column(
          children: List.generate(question.options.length, (index) {
            final option = question.options[index];

            final answered = controller.locked.value;
            final isSelected = controller.selectedOption.value == option.id;
            final isCorrect = option.isCorrect;

            final colors = _optionColors(answered: answered, isSelected: isSelected, isCorrect: isCorrect);

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => controller.selectOption(option.id),
                  borderRadius: BorderRadius.circular(14),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: colors.background,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: colors.border, width: 1.2),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: colors.badgeBg,
                          child: Text(
                            _letterForIndex(index),
                            style: TextStyle(color: colors.badgeText, fontWeight: FontWeight.w700),
                          ),
                        ),
                        const SizedBox(width: 12),
                        if (question.type == QuestionType.imageChoice && option.imageUrl != null)
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: AspectRatio(
                                aspectRatio: 16 / 9,
                                child: Image.network(
                                  option.imageUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (ctx, err, st) => Container(
                                    color: Colors.black26,
                                    alignment: Alignment.center,
                                    child: const Icon(Icons.broken_image, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          )
                        else ...[
                          if (option.imageUrl != null)
                            Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  option.imageUrl!,
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                  errorBuilder: (ctx, err, st) => Container(
                                    width: 40,
                                    height: 40,
                                    color: Colors.black26,
                                    alignment: Alignment.center,
                                    child: const Icon(Icons.broken_image, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          Expanded(
                            child: Text(
                              option.text,
                              style: TextStyle(color: colors.text, fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                        if (answered && isCorrect)
                          const Icon(Icons.check_circle, color: Colors.white, size: 20)
                        else if (answered && isSelected && !isCorrect)
                          const Icon(Icons.cancel, color: Colors.white, size: 20),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        );

      case QuestionType.trueFalse:
        return Row(
          children: [
            Expanded(child: _trueFalseTile("True", controller, question)),
            const SizedBox(width: 12),
            Expanded(child: _trueFalseTile("False", controller, question)),
          ],
        );

      case QuestionType.imageQuestion:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (question.questionImageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  question.questionImageUrl!,
                  height: 160,
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, err, st) => Container(
                    height: 160,
                    color: Colors.black26,
                    alignment: Alignment.center,
                    child: const Icon(Icons.broken_image, color: Colors.white),
                  ),
                ),
              ),
            const SizedBox(height: 12),
            Column(
              children: List.generate(question.options.length, (index) {
                final option = question.options[index];

                final answered = controller.locked.value;
                final isSelected = controller.selectedOption.value == option.id;
                final isCorrect = option.isCorrect;

                final colors = _optionColors(answered: answered, isSelected: isSelected, isCorrect: isCorrect);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => controller.selectOption(option.id),
                      borderRadius: BorderRadius.circular(14),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeInOut,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: colors.background,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: colors.border, width: 1.2),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: colors.badgeBg,
                              child: Text(
                                _letterForIndex(index),
                                style: TextStyle(color: colors.badgeText, fontWeight: FontWeight.w700),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                option.text,
                                style: TextStyle(color: colors.text, fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ),
                            if (answered && isCorrect)
                              const Icon(Icons.check_circle, color: Colors.white, size: 20)
                            else if (answered && isSelected && !isCorrect)
                              const Icon(Icons.cancel, color: Colors.white, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        );
    }
  }

  Widget _trueFalseTile(String text, QuizPlayController controller, QuestionModel question) {
    final matches = question.options.where((o) => o.text.toLowerCase() == text.toLowerCase()).toList();
    if (matches.isEmpty) return Opacity(opacity: 0.5, child: _disabledTile(text));

    final option = matches.first;
    final answered = controller.locked.value;
    final isSelected = controller.selectedOption.value == option.id;
    final isCorrect = option.isCorrect;

    final colors = _optionColors(answered: answered, isSelected: isSelected, isCorrect: isCorrect);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => controller.selectOption(option.id),
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: colors.background,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: colors.border, width: 1.2),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(color: colors.text, fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ),
    );
  }

  Widget _disabledTile(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.18), width: 1.2),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(color: Colors.white54, fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  _OptionColors _optionColors({required bool answered, required bool isSelected, required bool isCorrect}) {
    final baseBg = Colors.white.withOpacity(0.08);
    final baseBorder = Colors.white.withOpacity(0.18);
    const baseText = Colors.white;
    final baseBadgeBg = Colors.white.withOpacity(0.18);
    const baseBadgeText = Colors.white;

    if (answered) {
      if (isCorrect) return _OptionColors(background: const Color(0xFF2E7D32), border: const Color(0xFF1B5E20), text: Colors.white, badgeBg: Colors.white.withOpacity(0.22), badgeText: Colors.white);
      if (isSelected && !isCorrect) return const _OptionColors(background: Color(0xFFC62828), border: Color(0xFF8E0000), text: Colors.white, badgeBg: Color(0x33FFFFFF), badgeText: Colors.white);
      return _OptionColors(background: baseBg, border: baseBorder, text: baseText, badgeBg: baseBadgeBg, badgeText: baseBadgeText);
    }

    if (!answered && isSelected) return _OptionColors(background: Colors.white.withOpacity(0.14), border: Colors.white.withOpacity(0.30), text: baseText, badgeBg: Colors.white.withOpacity(0.22), badgeText: baseBadgeText);

    return _OptionColors(background: baseBg, border: baseBorder, text: baseText, badgeBg: baseBadgeBg, badgeText: baseBadgeText);
  }

  String _letterForIndex(int i) => String.fromCharCode(65 + i);
}

class _OptionColors {
  final Color background;
  final Color border;
  final Color text;
  final Color badgeBg;
  final Color badgeText;
  const _OptionColors({required this.background, required this.border, required this.text, required this.badgeBg, required this.badgeText});
}



