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

  factory UserStatsModel.fromJson(Map<String, dynamic> json) {
    return UserStatsModel(
      totalQuizzesCompleted: json['totalQuizzesCompleted'] ?? 0,
      totalPoints: json['totalPoints'] ?? 0,
      averageScore: (json['averageScore'] ?? 0.0).toDouble(),
      rank: json['rank'] ?? 'Beginner',
      streak: json['streak'] ?? 0,
      achievements: List<String>.from(json['achievements'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalQuizzesCompleted': totalQuizzesCompleted,
      'totalPoints': totalPoints,
      'averageScore': averageScore,
      'rank': rank,
      'streak': streak,
      'achievements': achievements,
    };
  }

  UserStatsModel copyWith({
    int? totalQuizzesCompleted,
    int? totalPoints,
    double? averageScore,
    String? rank,
    int? streak,
    List<String>? achievements,
  }) {
    return UserStatsModel(
      totalQuizzesCompleted: totalQuizzesCompleted ?? this.totalQuizzesCompleted,
      totalPoints: totalPoints ?? this.totalPoints,
      averageScore: averageScore ?? this.averageScore,
      rank: rank ?? this.rank,
      streak: streak ?? this.streak,
      achievements: achievements ?? this.achievements,
    );
  }


}
