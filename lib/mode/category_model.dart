// lib/models/category_model.dart
import 'package:flutter/material.dart';
import 'quiz_model.dart';

class CategoryModel {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  String? type;
  final Color color;
  final List<QuizModel> quizzes; // List of quizzes in this category
  final bool isActive;
  final int totalQuizzes;
  final int completedQuizzes;
  final int totalQuestions; // ADDED: Missing parameter
  final int totalPoints;    // ADDED: Missing parameter
  final DateTime createdAt;
  final DateTime? updatedAt;

  CategoryModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.type,
    required this.color,
    required this.quizzes,
    this.isActive = true,
    required this.totalQuizzes,
    this.completedQuizzes = 0,
    required this.totalQuestions, // ADDED: Missing parameter
    required this.totalPoints,    // ADDED: Missing parameter
    required this.createdAt,
    this.updatedAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      type: json['type'] ?? '',
      color: _parseColor(json['color']) ?? Colors.blue,
      quizzes: (json['quizzes'] as List<dynamic>? ?? [])
          .map((quizJson) => QuizModel.fromJson(quizJson as Map<String, dynamic>))
          .toList(),
      isActive: json['isActive'] ?? true,
      totalQuizzes: json['totalQuizzes'] ?? 0,
      completedQuizzes: json['completedQuizzes'] ?? 0,
      totalQuestions: json['totalQuestions'] ?? 0, // ADDED
      totalPoints: json['totalPoints'] ?? 0,       // ADDED
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'type': type,
      'color': color.value,
      'quizzes': quizzes.map((quiz) => quiz.toJson()).toList(),
      'isActive': isActive,
      'totalQuizzes': totalQuizzes,
      'completedQuizzes': completedQuizzes,
      'totalQuestions': totalQuestions, // ADDED
      'totalPoints': totalPoints,       // ADDED
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  static Color? _parseColor(dynamic colorValue) {
    if (colorValue is Color) return colorValue;
    if (colorValue is int) return Color(colorValue);
    return null;
  }

  CategoryModel copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    Color? color,
    List<QuizModel>? quizzes,
    bool? isActive,
    int? totalQuizzes,
    int? completedQuizzes,
    int? totalQuestions,
    int? totalPoints,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      type: type ?? this.type,
      color: color ?? this.color,
      quizzes: quizzes ?? this.quizzes,
      isActive: isActive ?? this.isActive,
      totalQuizzes: totalQuizzes ?? this.totalQuizzes,
      completedQuizzes: completedQuizzes ?? this.completedQuizzes,
      totalQuestions: totalQuestions ?? this.totalQuestions, // ADDED
      totalPoints: totalPoints ?? this.totalPoints,         // ADDED
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Computed properties
  double get completionPercentage =>
      totalQuizzes > 0 ? (completedQuizzes / totalQuizzes) * 100 : 0.0;

  bool get hasQuizzes => quizzes.isNotEmpty;

  List<QuizModel> get freeQuizzes =>
      quizzes.where((quiz) => quiz.isFree).toList();

  List<QuizModel> get premiumQuizzes =>
      quizzes.where((quiz) => quiz.isPremium).toList();

  List<QuizModel> get completedQuizzesList =>
      quizzes.where((quiz) => quiz.isCompleted).toList();

  List<QuizModel> get activeQuizzes =>
      quizzes.where((quiz) => quiz.isActive).toList();

  // Get quizzes by difficulty
  List<QuizModel> getQuizzesByDifficulty(String difficulty) {
    return quizzes.where((quiz) =>
    quiz.difficulty.toLowerCase() == difficulty.toLowerCase()).toList();
  }

  // Get average rating for category
  double get averageRating {
    if (quizzes.isEmpty) return 0.0;
    double totalRating = quizzes.fold(0.0, (sum, quiz) => sum + quiz.rating);
    return totalRating / quizzes.length;
  }
}
