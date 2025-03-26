import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:frontend/Model/DeptOnline.dart';
import 'package:frontend/creds.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Color primaryColor = Color(0xFF2E5F30);
showAlerts(BuildContext context, Widget wiget) {
  final size = MediaQuery.of(context).size;
  final isSmallScreen = size.width < 600;

  showDialog(
    context: context,
    barrierDismissible: true,
    builder:
        (context) => BackdropFilter(
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
              width: isSmallScreen ? size.width * 0.9 : size.width * 0.6,
              height: isSmallScreen ? size.height * 0.8 : size.height * 0.75,
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

processingWidget(
  String txt, [
  double fontsize = 14,
  Color fontcolor = Colors.green,
]) => Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    SpinKitPulse(color: fontcolor),
    Text(
      txt,
      style: TextStyle(
        color: fontcolor,
        fontSize: fontsize,
        fontWeight: FontWeight.w600,
      ),
    ),
    SpinKitPulse(color: fontcolor),
  ],
);

void showSuccessSnackBar(BuildContext context, String title, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.green[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.green.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.local_hospital, color: Colors.green[700]),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.green[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: TextStyle(color: Colors.green[600], fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
      duration: const Duration(seconds: 4),
    ),
  );
}

Widget errorWidget({required String errorMessage}) {
  return Container(
    padding: EdgeInsets.all(12),
    margin: EdgeInsets.only(bottom: 16),
    decoration: BoxDecoration(
      color: Colors.red.withOpacity(0.1),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.red),
    ),
    child: Row(
      children: [
        Icon(Icons.error, color: Colors.red),
        SizedBox(width: 8),
        Expanded(
          child: Text(errorMessage, style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}

// Hospital Color Palette
class HospitalColorPalette {
  // Primary Colors
  static const Color primary = Color(0xFF1A5F7A); // Deep Medical Blue
  static const Color primaryLight = Color(0xFF2C86FF); // Soft Sky Blue
  static const Color background = Color(0xFFF5F5F5); // Light Gray Background
  static const Color accent = Color(0xFF20B2AA); // Teal Accent

  // Text Colors
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF708090);

  // Status Colors
  static const Color success = Color(0xFF28A745);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFDC3545);
}
