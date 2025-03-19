import 'package:flutter/material.dart';

// Define the custom clipper for the outward curved tab
class OutwardCurvedTabClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final width = size.width;
    final height = size.height;
    final curveDepth = 15.0; // Adjust this value to control curve size
    
    // Start from top-left
    path.moveTo(0, 0);
    
    // Draw line to top-right
    path.lineTo(width, 0);
    
    // Draw line to bottom-right before the curve
    path.lineTo(width, height - curveDepth);
    
    // Draw bottom-right outward curve
    path.quadraticBezierTo(
      width + curveDepth/2, height, // control point
      width - curveDepth, height + curveDepth // end point
    );
    
    // Draw line to bottom-left (just before the curve)
    path.lineTo(curveDepth, height + curveDepth);
    
    // Draw bottom-left outward curve
    path.quadraticBezierTo(
      -curveDepth/2, height, // control point
      0, height - curveDepth // end point
    );
    
    // Close the path by returning to starting point
    path.close();
    
    return path;
  }
  
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}


class OutwardCurvedTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  
  const OutwardCurvedTab({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: ClipPath(
          clipper: OutwardCurvedTabClipper(),
          child: Container(
            width: 80,
            height: 40,
            color: isSelected ? Colors.white : const Color(0xFF2E5F30),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected ? const Color(0xFF2E5F30) : Colors.white,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}