
import 'package:flutter/material.dart';

class Course {
  String name;
  String teacher;
  int credits;
  String grade;
  IconData icon;
  Color color;
  bool isFavorite;

  Course({
    required this.name,
    required this.teacher,
    required this.credits,
    required this.grade,
    required this.icon,
    required this.color,
    this.isFavorite = false,
  });

  static const Map<String, double> gradeValues = {
    'A': 4.0,
    'A-': 3.67,
    'B+': 3.33,
    'B': 3.0,
    'B-': 2.67,
    'C+': 2.33,
    'C': 2.0,
    'C-': 1.67,
    'D+': 1.33,
    'D': 1.0,
    'F': 0.0,
  };

  double get gradePoint => gradeValues[grade] ?? 0.0;
}
