// lib/models/question_model.dart
import 'package:flutter/foundation.dart';

enum QuestionType {
  multipleChoice,
  trueFalse,
  imageChoice, // New: Multiple choice with image options
  imageQuestion // New: Question with image
}

class QuestionOption {
  final String id;
  final String text;
  final String? imageUrl;
  final bool isCorrect;

  QuestionOption({
    required this.id,
    required this.text,
    this.imageUrl,
    required this.isCorrect,
  });

  factory QuestionOption.fromJson(Map<String, dynamic> json) {
    return QuestionOption(
      id: json['id'] ?? '',
      text: json['text'] ?? '',
      imageUrl: json['imageUrl'],
      isCorrect: json['isCorrect'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'imageUrl': imageUrl,
      'isCorrect': isCorrect,
    };
  }

  QuestionOption copyWith({
    String? id,
    String? text,
    String? imageUrl,
    bool? isCorrect,
  }) {
    return QuestionOption(
      id: id ?? this.id,
      text: text ?? this.text,
      imageUrl: imageUrl ?? this.imageUrl,
      isCorrect: isCorrect ?? this.isCorrect,
    );
  }

  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;
}

class QuestionModel {
  final String id;
  final String question;
  final QuestionType type;
  final List<QuestionOption> options; // Changed to use QuestionOption class
  final String correctAnswer;
  final String explanation;
  final int points;
  final int timeLimit; // in seconds
  final String? questionImageUrl; // Image for the question itself
  final String? questionVideoUrl; // Video URL for question (YouTube, etc.)
  final String difficulty;
  final List<String> tags;
  final String? hint;
  final bool hasMultipleCorrectAnswers;
  final List<String>? multipleCorrectAnswers;

  QuestionModel({
    required this.id,
    required this.question,
    required this.type,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
    required this.points,
    this.timeLimit = 30,
    this.questionImageUrl,
    this.questionVideoUrl,
    this.difficulty = 'Medium',
    this.tags = const [],
    this.hint,
    this.hasMultipleCorrectAnswers = false,
    this.multipleCorrectAnswers,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'] ?? '',
      question: json['question'] ?? '',
      type: _parseQuestionType(json['type']),
      options: (json['options'] as List<dynamic>? ?? [])
          .map((optionJson) => QuestionOption.fromJson(optionJson))
          .toList(),
      correctAnswer: json['correctAnswer'] ?? '',
      explanation: json['explanation'] ?? '',
      points: json['points'] ?? 10,
      timeLimit: json['timeLimit'] ?? 30,
      questionImageUrl: json['questionImageUrl'],
      questionVideoUrl: json['questionVideoUrl'],
      difficulty: json['difficulty'] ?? 'Medium',
      tags: List<String>.from(json['tags'] ?? []),
      hint: json['hint'],
      hasMultipleCorrectAnswers: json['hasMultipleCorrectAnswers'] ?? false,
      multipleCorrectAnswers: json['multipleCorrectAnswers'] != null
          ? List<String>.from(json['multipleCorrectAnswers'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'type': type.name,
      'options': options.map((option) => option.toJson()).toList(),
      'correctAnswer': correctAnswer,
      'explanation': explanation,
      'points': points,
      'timeLimit': timeLimit,
      'questionImageUrl': questionImageUrl,
      'questionVideoUrl': questionVideoUrl,
      'difficulty': difficulty,
      'tags': tags,
      'hint': hint,
      'hasMultipleCorrectAnswers': hasMultipleCorrectAnswers,
      'multipleCorrectAnswers': multipleCorrectAnswers,
    };
  }

  static QuestionType _parseQuestionType(dynamic type) {
    if (type is String) {
      switch (type.toLowerCase()) {
        case 'multiplechoice':
          return QuestionType.multipleChoice;
        case 'truefalse':
          return QuestionType.trueFalse;
        case 'imagechoice':
          return QuestionType.imageChoice;
        case 'imagequestion':
          return QuestionType.imageQuestion;
        default:
          return QuestionType.multipleChoice;
      }
    }
    return QuestionType.multipleChoice;
  }

  QuestionModel copyWith({
    String? id,
    String? question,
    QuestionType? type,
    List<QuestionOption>? options,
    String? correctAnswer,
    String? explanation,
    int? points,
    int? timeLimit,
    String? questionImageUrl,
    String? questionVideoUrl,
    String? difficulty,
    List<String>? tags,
    String? hint,
    bool? hasMultipleCorrectAnswers,
    List<String>? multipleCorrectAnswers,
  }) {
    return QuestionModel(
      id: id ?? this.id,
      question: question ?? this.question,
      type: type ?? this.type,
      options: options ?? this.options,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      explanation: explanation ?? this.explanation,
      points: points ?? this.points,
      timeLimit: timeLimit ?? this.timeLimit,
      questionImageUrl: questionImageUrl ?? this.questionImageUrl,
      questionVideoUrl: questionVideoUrl ?? this.questionVideoUrl,
      difficulty: difficulty ?? this.difficulty,
      tags: tags ?? this.tags,
      hint: hint ?? this.hint,
      hasMultipleCorrectAnswers: hasMultipleCorrectAnswers ?? this.hasMultipleCorrectAnswers,
      multipleCorrectAnswers: multipleCorrectAnswers ?? this.multipleCorrectAnswers,
    );
  }

  // Computed properties
  bool get isMultipleChoice => type == QuestionType.multipleChoice;
  bool get isTrueFalse => type == QuestionType.trueFalse;
  bool get isImageChoice => type == QuestionType.imageChoice;
  bool get isImageQuestion => type == QuestionType.imageQuestion;

  bool get hasQuestionImage => questionImageUrl != null && questionImageUrl!.isNotEmpty;
  bool get hasQuestionVideo => questionVideoUrl != null && questionVideoUrl!.isNotEmpty;
  bool get hasHint => hint != null && hint!.isNotEmpty;

  List<QuestionOption> get correctOptions =>
      options.where((option) => option.isCorrect).toList();

  List<QuestionOption> get incorrectOptions =>
      options.where((option) => !option.isCorrect).toList();

  bool get hasImageOptions => options.any((option) => option.hasImage);

  int get totalOptions => options.length;

  // Get options with images only
  List<QuestionOption> get imageOptions =>
      options.where((option) => option.hasImage).toList();

  // Get text-only options
  List<QuestionOption> get textOptions =>
      options.where((option) => !option.hasImage).toList();
}
