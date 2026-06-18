import 'package:flutter/material.dart';

class WasteTypeModel {
  final String id;
  final String name;
  final double pointsPerKg;
  final IconData icon; // flutter icon
  final String description;
  final String color; // hex color

  const WasteTypeModel({
    required this.id,
    required this.name,
    required this.pointsPerKg,
    required this.icon,
    required this.description,
    required this.color,
  });
}
