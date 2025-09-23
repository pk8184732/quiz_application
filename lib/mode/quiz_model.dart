// lib/models/quiz_model.dart
import 'package:flutter/material.dart';
import 'question_model.dart';

class QuizModel {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final String type;
  final Color color;
  final String duration;
  final String difficulty;
  final String category;
  final double rating;
  final int attempts;
  final String? price;
  final String imageUrl;
  final List<String> tags;
  final bool isCompleted;
  final int bestScore;
  final String? lastAttempt;
  final List<QuestionModel> questions; // Added questions list
  final int passingScore;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;

  QuizModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.type,
    required this.color,
    required this.duration,
    required this.difficulty,
    required this.category,
    required this.rating,
    required this.attempts,
    this.price,
    required this.imageUrl,
    required this.tags,
    required this.isCompleted,
    required this.bestScore,
    this.lastAttempt,
    required this.questions,
    this.passingScore = 60,
    this.isActive = true,
    required this.createdAt,
    this.updatedAt,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      description: json['description'] ?? '',
      type: json['type'] ?? '',
      color: _parseColor(json['color']) ?? Colors.blue,
      duration: json['duration'] ?? '',
      difficulty: json['difficulty'] ?? '',
      category: json['category'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      attempts: json['attempts'] ?? 0,
      price: json['price'],
      imageUrl: json['imageUrl'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      isCompleted: json['isCompleted'] ?? false,
      bestScore: json['bestScore'] ?? 0,
      lastAttempt: json['lastAttempt'],
      questions: (json['questions'] as List<dynamic>? ?? [])
          .map((questionJson) => QuestionModel.fromJson(questionJson))
          .toList(),
      passingScore: json['passingScore'] ?? 60,
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'type': type,
      'color': color.value,
      'duration': duration,
      'difficulty': difficulty,
      'category': category,
      'rating': rating,
      'attempts': attempts,
      'price': price,
      'imageUrl': imageUrl,
      'tags': tags,
      'isCompleted': isCompleted,
      'bestScore': bestScore,
      'lastAttempt': lastAttempt,
      'questions': questions.map((question) => question.toJson()).toList(),
      'passingScore': passingScore,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  static Color? _parseColor(dynamic colorValue) {
    if (colorValue is Color) return colorValue;
    if (colorValue is int) return Color(colorValue);
    return null;
  }

  QuizModel copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? description,
    String? type,
    Color? color,
    String? duration,
    String? difficulty,
    String? category,
    double? rating,
    int? attempts,
    String? price,
    String? imageUrl,
    List<String>? tags,
    bool? isCompleted,
    int? bestScore,
    String? lastAttempt,
    List<QuestionModel>? questions,
    int? passingScore,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return QuizModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      description: description ?? this.description,
      type: type ?? this.type,
      color: color ?? this.color,
      duration: duration ?? this.duration,
      difficulty: difficulty ?? this.difficulty,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      attempts: attempts ?? this.attempts,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      tags: tags ?? this.tags,
      isCompleted: isCompleted ?? this.isCompleted,
      bestScore: bestScore ?? this.bestScore,
      lastAttempt: lastAttempt ?? this.lastAttempt,
      questions: questions ?? this.questions,
      passingScore: passingScore ?? this.passingScore,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Computed properties
  bool get isPremium => type == "PREMIUM";
  bool get isFree => type == "FREE";
  int get totalQuestions => questions.length;
  int get totalPoints => questions.fold(0, (sum, question) => sum + question.points);
  int get estimatedDurationInMinutes => totalQuestions * 2; // 2 minutes per question
  bool get hasQuestions => questions.isNotEmpty;

  // Get questions by difficulty
  List<QuestionModel> getQuestionsByDifficulty(String difficulty) {
    return questions.where((q) => q.difficulty.toLowerCase() == difficulty.toLowerCase()).toList();
  }

  // Get questions by type
  List<QuestionModel> getQuestionsByType(QuestionType type) {
    return questions.where((q) => q.type == type).toList();
  }
}
