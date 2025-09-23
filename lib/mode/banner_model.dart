// lib/models/premium_banner_model.dart
import 'package:flutter/material.dart';

class PremiumBannerModel {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final String type;
  final Color primaryColor;
  final Color secondaryColor;
  final int questions;
  final int points;
  final String duration;
  final String difficulty;
  final String category;
  final String price;
  final double rating;
  final int enrolledUsers;
  final String imageUrl;

  PremiumBannerModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.type,
    required this.primaryColor,
    required this.secondaryColor,
    required this.questions,
    required this.points,
    required this.duration,
    required this.difficulty,
    required this.category,
    required this.price,
    required this.rating,
    required this.enrolledUsers,
    required this.imageUrl,
  });

  factory PremiumBannerModel.fromJson(Map<String, dynamic> json) {
    return PremiumBannerModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      description: json['description'] ?? '',
      type: json['type'] ?? '',
      primaryColor: _parseColor(json['primaryColor']) ?? Colors.blue,
      secondaryColor: _parseColor(json['secondaryColor']) ?? Colors.blueAccent,
      questions: json['questions'] ?? 0,
      points: json['points'] ?? 0,
      duration: json['duration'] ?? '',
      difficulty: json['difficulty'] ?? '',
      category: json['category'] ?? '',
      price: json['price'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      enrolledUsers: json['enrolledUsers'] ?? 0,
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'type': type,
      'primaryColor': primaryColor.value,
      'secondaryColor': secondaryColor.value,
      'questions': questions,
      'points': points,
      'duration': duration,
      'difficulty': difficulty,
      'category': category,
      'price': price,
      'rating': rating,
      'enrolledUsers': enrolledUsers,
      'imageUrl': imageUrl,
    };
  }

  static Color? _parseColor(dynamic colorValue) {
    if (colorValue is Color) return colorValue;
    if (colorValue is int) return Color(colorValue);
    return null;
  }

  PremiumBannerModel copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? description,
    String? type,
    Color? primaryColor,
    Color? secondaryColor,
    int? questions,
    int? points,
    String? duration,
    String? difficulty,
    String? category,
    String? price,
    double? rating,
    int? enrolledUsers,
    String? imageUrl,
  }) {
    return PremiumBannerModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      description: description ?? this.description,
      type: type ?? this.type,
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      questions: questions ?? this.questions,
      points: points ?? this.points,
      duration: duration ?? this.duration,
      difficulty: difficulty ?? this.difficulty,
      category: category ?? this.category,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      enrolledUsers: enrolledUsers ?? this.enrolledUsers,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
