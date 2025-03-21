
  import 'dart:ui';

import 'package:flutter/material.dart';

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


