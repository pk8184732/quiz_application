class UserStatsModel {
  final String name;
  final int totalQuizzesCompleted;
  final int totalPoints;
  final double averageScore;
  final String rank;
  final int streak;
  final List<String> achievements;

  UserStatsModel({
    required this.name,
    required this.totalQuizzesCompleted,
    required this.totalPoints,
    required this.averageScore,
    required this.rank,
    required this.streak,
    required this.achievements,
  });

  // Copy with method
  UserStatsModel copyWith({
    String? name,
    int? totalQuizzesCompleted,
    int? totalPoints,
    double? averageScore,
    String? rank,
    int? streak,
    List<String>? achievements,
  }) {
    return UserStatsModel(
      name: name ?? this.name,
      totalQuizzesCompleted: totalQuizzesCompleted ?? this.totalQuizzesCompleted,
      totalPoints: totalPoints ?? this.totalPoints,
      averageScore: averageScore ?? this.averageScore,
      rank: rank ?? this.rank,
      streak: streak ?? this.streak,
      achievements: achievements ?? this.achievements,
    );
  }

  // Convert to Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'totalQuizzesCompleted': totalQuizzesCompleted,
      'totalPoints': totalPoints,
      'averageScore': averageScore,
      'rank': rank,
      'streak': streak,
      'achievements': achievements,
    };
  }

  // Create from Map
  factory UserStatsModel.fromMap(Map<String, dynamic> map) {
    return UserStatsModel(
      name: map['name'] ?? '',
      totalQuizzesCompleted: map['totalQuizzesCompleted'] ?? 0,
      totalPoints: map['totalPoints'] ?? 0,
      averageScore: (map['averageScore'] ?? 0).toDouble(),
      rank: map['rank'] ?? '',
      streak: map['streak'] ?? 0,
      achievements: List<String>.from(map['achievements'] ?? []),
    );
  }
}
