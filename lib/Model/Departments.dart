import 'package:flutter/material.dart';

class Department {
  final int departmentId;
  final String name;
  final String description;
  final String location;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String iconData;
  final String? headOfDept;
  final String? staffId;

  Department({
    required this.departmentId,
    required this.name,
    required this.description,
    required this.location,
    required this.createdAt,
    required this.updatedAt,
    required this.iconData,
    this.headOfDept,
    this.staffId,
  });

  // Factory method to create a Department from JSON
  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      departmentId: json['department_id'],
      name: json['name'],
      description: json['description'],
      location: json['location'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      iconData: json['iconData'],
      headOfDept: json['head_of_dept'],
      staffId: json['staff_id'],
    );
  }

  // Method to convert a Department instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'department_id': departmentId,
      'name': name,
      'description': description,
      'location': location,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'iconData': iconData,
      'head_of_dept': headOfDept,
      'staff_id': staffId,
    };
  }
}
