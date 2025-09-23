// lib/models/user_stats_model.dart

class UserStatsModel {
  final int totalQuizzesCompleted;
  final int totalPoints;
  final double averageScore;
  final String rank;
  final int streak;
  final List<String> achievements;

  UserStatsModel({
    required this.totalQuizzesCompleted,
    required this.totalPoints,
    required this.averageScore,
    required this.rank,
    required this.streak,
    required this.achievements,
  });

}
