
  import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:frontend/Model/DeptOnline.dart';
import 'package:frontend/creds.dart';

Color primaryColor = Color(0xFF2E5F30);
showAlerts(BuildContext context, Widget wiget) {
  final size = MediaQuery.of(context).size;
  final isSmallScreen = size.width < 600;

  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 16 : size.width * 0.2,
          vertical: 24,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadiusDirectional.circular(20),
          ),
          width: isSmallScreen 
              ? size.width * 0.9 
              : size.width * 0.6,
          height: isSmallScreen 
              ? size.height * 0.8 
              : size.height * 0.75,
          child: wiget,
        ),
      ),
    ),
  );
}




 // Helper function to map icon names to IconData
  IconData getIconData(String iconName) {
    switch (iconName) {
      case 'local_hospital':
        return Icons.local_hospital;
      case 'medical_services':
        return Icons.medical_services;
      case 'healing':
        return Icons.healing;
      case 'child_care':
        return Icons.child_care;
      case 'pregnant_woman':
        return Icons.pregnant_woman;
      case 'favorite':
        return Icons.favorite;
      case 'psychology':
        return Icons.psychology;
      case 'accessibility':
        return Icons.accessibility;
      case 'face':
        return Icons.face;
      case 'visibility':
        return Icons.visibility;
      case 'hearing':
        return Icons.hearing;
      case 'water_drop':
        return Icons.water_drop;
      case 'mood':
        return Icons.mood;
      case 'biotech':
        return Icons.biotech;
      case 'radio':
        return Icons.radio;
      case 'bedtime':
        return Icons.bedtime;
      case 'fitness_center':
        return Icons.fitness_center;
      case 'medication':
        return Icons.medication;
      case 'science':
        return Icons.science;
      case 'restaurant_menu':
        return Icons.restaurant_menu;
      default:
        return Icons.local_hospital;
    }
  }
