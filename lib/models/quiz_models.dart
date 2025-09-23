
import 'dart:ui';

class QuizCategory {
  final String id;
  final String title;
  final String imageUrl;
  final bool isPaid;
  final Color color;

  QuizCategory({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.isPaid,
    required this.color,
  });
}

class Question {
  final String text;
  final List<String> options;
  final int correctIndex;
  final String? imageUrl;
  final int timeSeconds;

  Question({
    required this.text,
    required this.options,
    required this.correctIndex,
    this.imageUrl,
    this.timeSeconds = 15, // default per-question time
  });
}

class LeaderboardEntry {
  final String name;
  final int score;
  final DateTime time;

  LeaderboardEntry({required this.name, required this.score, required this.time});
}

List<LeaderboardEntry> gLeaderboard = [
  LeaderboardEntry(name: 'Alice', score: 95, time: DateTime.now().subtract(const Duration(days: 1))),
  LeaderboardEntry(name: 'Bob', score: 85, time: DateTime.now().subtract(const Duration(days: 2))),
  LeaderboardEntry(name: 'Carol', score: 70, time: DateTime.now().subtract(const Duration(days: 3))),
];