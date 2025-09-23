
import 'package:flutter/material.dart';

import '../main.dart';
import '../models/quiz_models.dart';
import 'home_screen.dart';

class QuizResultScreen extends StatelessWidget {
  final int score;
  final int totalPossible;
  final Duration timeTaken;

  const QuizResultScreen({super.key, required this.score, required this.totalPossible, required this.timeTaken});

  @override
  Widget build(BuildContext context) {
    final percent = (score / totalPossible * 100).round();
    final rank = _calculateRank(score);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF141E30), Color(0xFF243B55)], begin: Alignment.topLeft, end: Alignment.bottomRight)),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("Quiz Completed", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                CircleAvatar(radius: 52, backgroundColor: Colors.white24, child: Text("$percent%", style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold))),
                const SizedBox(height: 18),
                Text("Score: $score / $totalPossible", style: const TextStyle(color: Colors.white70)),
                const SizedBox(height: 6),
                Text("Rank: $rank", style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text("Time: ${_formatDuration(timeTaken)}", style: const TextStyle(color: Colors.white70)),
                const SizedBox(height: 20),
                Card(
                  color: Colors.white10,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(children: [
                      const Text("Summary", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text("Correct: ${score / 5}", style: const TextStyle(color: Colors.white70)),
                      Text("Points per correct: 5", style: const TextStyle(color: Colors.white70)),
                    ]),
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const HomeScreen()), (route) => false);
                  },
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14), backgroundColor: Colors.greenAccent[700]),
                  child: const Text("Back to Home", style: TextStyle(fontWeight: FontWeight.bold)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes;
    final secs = d.inSeconds % 60;
    return "${minutes}m ${secs}s";
  }

  String _calculateRank(int score) {
    // simple rank logic vs leaderboard
    final all = List<LeaderboardEntry>.from(gLeaderboard)..add(LeaderboardEntry(name: "You", score: score, time: DateTime.now()));
    all.sort((a, b) => b.score.compareTo(a.score));
    final idx = all.indexWhere((e) => e.score == score);
    if (idx == 0) return "1st";
    if (idx == 1) return "2nd";
    if (idx == 2) return "3rd";
    return "${idx + 1}th";
  }
}