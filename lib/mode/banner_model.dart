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

}
