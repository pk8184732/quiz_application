import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quiz_application/screens/quiz_result_screen.dart';

import '../models/quiz_models.dart';

class QuizPlayScreen extends StatefulWidget {
  final QuizCategory category;
  final List<Question> questions;

  const QuizPlayScreen({super.key, required this.category, required this.questions});

  @override
  State<QuizPlayScreen> createState() => _QuizPlayScreenState();
}

class _QuizPlayScreenState extends State<QuizPlayScreen> with TickerProviderStateMixin {
  int currentIndex = 0;
  int totalScore = 0;
  int? selectedIndex;
  bool answered = false;
  Timer? questionTimer;
  int remainingSeconds = 0;
  Stopwatch _stopwatch = Stopwatch();

  // for +5 animation
  bool showPlusFive = false;
  late AnimationController _plusCtrl;
  late Animation<Offset> _plusOffset;
  late Animation<double> _plusOpacity;

  @override
  void initState() {
    super.initState();
    _startQuestion();
    _plusCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _plusOffset = Tween<Offset>(begin: const Offset(0, 0.2), end: const Offset(0, -1.2)).animate(CurvedAnimation(parent: _plusCtrl, curve: Curves.easeOut));
    _plusOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(parent: _plusCtrl, curve: Curves.easeOut));
    _stopwatch.start();
  }

  @override
  void dispose() {
    questionTimer?.cancel();
    _plusCtrl.dispose();
    _stopwatch.stop();
    super.dispose();
  }

  void _startQuestion() {
    final q = widget.questions[currentIndex];
    remainingSeconds = q.timeSeconds;
    questionTimer?.cancel();
    questionTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        remainingSeconds--;
        if (remainingSeconds <= 0) {
          t.cancel();
          _onTimeUp();
        }
      });
    });
    setState(() {
      selectedIndex = null;
      answered = false;
      showPlusFive = false;
    });
  }

  void _onTimeUp() {
    // mark unanswered and go next after short delay
    setState(() { answered = true; selectedIndex = null; });
    Future.delayed(const Duration(milliseconds: 800), _nextQuestion);
  }

  void _selectOption(int index) {
    if (answered) return;
    setState(() {
      selectedIndex = index;
      answered = true;
    });
    questionTimer?.cancel();

    final correct = widget.questions[currentIndex].correctIndex;
    if (index == correct) {
      // correct: +5 with animation
      setState(() {
        totalScore += 5;
        showPlusFive = true;
      });
      _plusCtrl.forward(from: 0.0).whenComplete(() {
        setState(() {
          showPlusFive = false;
        });
      });
    }

    // auto move to next after delay to show feedback
    Future.delayed(const Duration(milliseconds: 900), _nextQuestion);
  }

  void _nextQuestion() {
    if (currentIndex < widget.questions.length - 1) {
      setState(() {
        currentIndex++;
      });
      _startQuestion();
    } else {
      // finish
      questionTimer?.cancel();
      _stopwatch.stop();
      // add to leaderboard (ask for sample name or just random for demo)
      gLeaderboard.insert(0, LeaderboardEntry(name: "You", score: totalScore, time: DateTime.now()));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => QuizResultScreen(score: totalScore, totalPossible: widget.questions.length * 5, timeTaken: _stopwatch.elapsed)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = widget.questions[currentIndex];
    final correct = q.correctIndex;

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.category.title} • Q${currentIndex + 1}/${widget.questions.length}"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(gradient: LinearGradient(colors: [widget.category.color.withOpacity(0.9), Colors.black87], begin: Alignment.topLeft, end: Alignment.bottomRight)),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // top: image (if any)
                    if (q.imageUrl != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(q.imageUrl!, height: 160, width: double.infinity, fit: BoxFit.cover),
                      ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // timer
                        Row(
                          children: [
                            const Icon(Icons.timer, color: Colors.white70),
                            const SizedBox(width: 6),
                            Text("$remainingSeconds s", style: const TextStyle(color: Colors.white70)),
                          ],
                        ),
                        // score
                        Row(children: [
                          const Icon(Icons.star, color: Colors.amber),
                          const SizedBox(width: 6),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: Text("$totalScore", key: ValueKey<int>(totalScore), style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                        ]),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(q.text, style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),

                    // options list
                    ...List.generate(q.options.length, (i) {
                      Color bg;
                      if (answered) {
                        if (i == correct) {
                          bg = Colors.green.shade700;
                        } else if (i == selectedIndex && selectedIndex != correct) {
                          bg = Colors.red.shade700;
                        } else {
                          bg = Colors.white.withOpacity(0.12);
                        }
                      } else {
                        bg = Colors.white.withOpacity(0.12);
                      }

                      return GestureDetector(
                        onTap: () {
                          if (!answered) _selectOption(i);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: bg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white12),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: Colors.white24,
                                child: Text(String.fromCharCode(65 + i), style: const TextStyle(color: Colors.white)),
                              ),
                              const SizedBox(width: 12),
                              Expanded(child: Text(q.options[i], style: const TextStyle(color: Colors.white, fontSize: 16))),
                            ],
                          ),
                        ),
                      );
                    }),

                    const Spacer(),

                    // progress bar
                    LinearProgressIndicator(
                      value: (currentIndex + 1) / widget.questions.length,
                      backgroundColor: Colors.white24,
                      color: Colors.amber,
                      minHeight: 8,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Q ${currentIndex + 1}/${widget.questions.length}", style: const TextStyle(color: Colors.white70)),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.white24),
                          onPressed: answered ? _nextQuestion : null,
                          child: Text(currentIndex < widget.questions.length - 1 ? "Skip" : "Finish"),
                        )
                      ],
                    ),
                  ],
                ),

                // floating +5 animation near score
                if (showPlusFive)
                  Positioned(
                    right: 20,
                    top: 36,
                    child: SlideTransition(
                      position: _plusOffset,
                      child: FadeTransition(
                        opacity: _plusOpacity,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(color: Colors.green.shade400, borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)]),
                          child: const Text("+5", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
