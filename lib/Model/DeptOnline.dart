import 'package:flutter/material.dart';

class DepartmentOnline {
  final String name;
  final String description;
  final String iconName;

  DepartmentOnline({
    required this.name,
    required this.description,
    required this.iconName,
  });

  // Convert string to actual IconData
  IconData get iconData {
    return iconMap[iconName] ?? Icons.help_outline;
  }

  // Factory method to create a DepartmentOnline from JSON
  factory DepartmentOnline.fromJson(Map<String, dynamic> json) {
    return DepartmentOnline(
      name: json['name'],
      description: json['description'],
      iconName: json['iconData'], // Store as a string
    );
  }

  // Convert a DepartmentOnline object to JSON format
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'iconData': iconName,
    };
  }
}

// Mapping of string names to actual icons
final Map<String, IconData> iconMap = {
  "Icons.local_hospital": Icons.local_hospital,
  "Icons.medical_services": Icons.medical_services,
  "Icons.healing": Icons.healing,
  "Icons.child_care": Icons.child_care,
  "Icons.pregnant_woman": Icons.pregnant_woman,
  "Icons.favorite": Icons.favorite,
  "Icons.psychology": Icons.psychology,
  "Icons.accessibility": Icons.accessibility,
  "Icons.face": Icons.face,
  "Icons.visibility": Icons.visibility,
  "Icons.hearing": Icons.hearing,
  "Icons.water_drop": Icons.water_drop,
  "Icons.mood": Icons.mood,
  "Icons.biotech": Icons.biotech,
  "Icons.radio": Icons.radio,
  "Icons.bedtime": Icons.bedtime,
  "Icons.fitness_center": Icons.fitness_center,
  "Icons.medication": Icons.medication,
  "Icons.science": Icons.science,
  "Icons.restaurant_menu": Icons.restaurant_menu,
};

