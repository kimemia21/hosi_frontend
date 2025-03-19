import 'package:flutter/material.dart';
import 'package:frontend/Homepage/NavBar.dart';
import 'package:frontend/staff/AddStaff.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Green Navigation Bar',
      theme: ThemeData(
        primaryColor: const Color(0xFF2E5F30), // Dark green color from image
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E5F30),
          primary: const Color(0xFF2E5F30),
        ),
      ),
      home: 
      //  Addstaff(),
     const AppNavBar(),
      debugShowCheckedModeBanner: false,
    );
  }
}
