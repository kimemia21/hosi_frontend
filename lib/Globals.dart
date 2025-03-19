
  import 'dart:ui';

import 'package:flutter/material.dart';

Color primaryColor = Color(0xFF2E5F30);

showAlerts(BuildContext context, Widget wiget) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder:
        (context) => BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 24,
            ),
            child: wiget,
          ),
        ),
  );
}