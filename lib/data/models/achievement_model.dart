import 'package:flutter/material.dart';

class AchievementModel {
  final String id;
  final String name;
  final String description;
  final IconData icon; // flutter icon
  final int requiredCount; // e.g., deposits needed
  final String type; // 'deposit_count' | 'waste_kg' | 'points_earned'
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final String color; // hex

  AchievementModel({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.requiredCount,
    required this.type,
    this.isUnlocked = false,
    this.unlockedAt,
    required this.color,
  });
}

class LeaderboardEntry {
  final String userId;
  final String userName;
  final String? avatarUrl;
  final int totalPoints;
  final double totalWasteKg;
  final int rank;
  final String? institution;

  LeaderboardEntry({
    required this.userId,
    required this.userName,
    this.avatarUrl,
    required this.totalPoints,
    required this.totalWasteKg,
    required this.rank,
    this.institution,
  });
}
