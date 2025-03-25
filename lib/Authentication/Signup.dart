import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _termsAccepted = false;

  // Modern input decoration method (similar to login page)
  InputDecoration _modernInputDecoration({
    required String labelText, 
    IconData? prefixIcon, 
    IconData? suffixIcon,
    VoidCallback? onSuffixIconPressed
  }) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: GoogleFonts.poppins(
        color: Colors.grey.shade600,
        fontSize: 14,
      ),
      prefixIcon: prefixIcon != null 
        ? Icon(prefixIcon, color: Colors.blue.shade300) 
        : null,
      suffixIcon: suffixIcon != null
        ? IconButton(
            icon: Icon(suffixIcon, color: Colors.blue.shade300),
            onPressed: onSuffixIconPressed,
          )
        : null,
      filled: true,
      fillColor: Colors.grey.shade100,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(
          color: Colors.grey.shade300,
          width: 1.5,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(
          color: Colors.blue.shade300,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(
          color: Colors.red.shade300,
          width: 1.5,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(
          color: Colors.red.shade300,
          width: 2,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20, 
        vertical: 16
      ),
    );
  }

  void _signUp() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_passwordController.text != _confirmPasswordController.text) {
        // Show error that passwords don't match
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Passwords do not match',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: Colors.red.shade400,
          ),
        );
        return;
      }

      if (!_termsAccepted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Please accept the Terms and Conditions',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: Colors.red.shade400,
          ),
        );
        return;
      }

      // Implement signup logic here
      print('Signup successful');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isWideScreen = constraints.maxWidth > 1000;
          bool isMediumScreen = constraints.maxWidth > 600 && constraints.maxWidth <= 1000;
          bool isSmallScreen = constraints.maxWidth <= 600;

          return Container(
            color: const Color(0xFFF0F4FF),
            child: Center(
              child: SingleChildScrollView(
                child: Container(
                  width: isWideScreen ? 1000 : 
                          isMediumScreen ? 800 : 
                          constraints.maxWidth * 0.95,
                  height: isWideScreen ? 700 : 
                           isMediumScreen ? 600 : 
                           constraints.maxHeight * 0.95,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 15,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: isWideScreen 
                    ? _buildWideScreenLayout() 
                    : _buildNarrowScreenLayout(),
                ).animate()
                  .fadeIn(duration: 600.ms)
                  .shimmer(delay: 400.ms, duration: 1000.ms),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWideScreenLayout() {
    return Row(
      children: [
        // Left Side - Welcome Section
        Expanded(
          flex: 1,
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFFE6F1FF),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'CREATE ACCOUNT',
                    style: GoogleFonts.poppins(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ).animate().slideX(begin: -0.5, end: 0),
                  const SizedBox(height: 10),
                  Text(
                    'Join our community and start your journey',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ).animate().slideX(begin: -0.5, end: 0, delay: 200.ms),
                  const SizedBox(height: 30),
                  Center(
                    child: Image.asset(
                      'images/signup.png',
                      height: 250,
                      fit: BoxFit.contain,
                    ).animate()
                      .scale(begin: Offset(0.5, 0.5))
                      .shake(delay: 500.ms),
                  ),
                ],
              ),
            ),
          ),
        ),
        
        // Right Side - Signup Form
        Expanded(
          flex: 1,
          child: _buildSignupForm(),
        ),
      ],
    );
  }

  Widget _buildNarrowScreenLayout() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            color: const Color(0xFFE6F1FF),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              children: [
                Text(
                  'CREATE ACCOUNT',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ).animate().slideY(begin: -0.5, end: 0),
                const SizedBox(height: 10),
                Text(
                  'Join our community and start your journey',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ).animate().slideY(begin: -0.5, end: 0, delay: 200.ms),
              ],
            ),
          ),
          _buildSignupForm(),
        ],
      ),
    );
  }

  Widget _buildSignupForm() {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Full Name Input
            TextFormField(
              controller: _nameController,
              decoration: _modernInputDecoration(
                labelText: 'Full Name',
                prefixIcon: Icons.person_outline,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your full name';
                }
                return null;
              },
            ).animate().slideX(begin: 0.5, end: 0),
            
            const SizedBox(height: 20),
            
            // Email Input
            TextFormField(
              controller: _emailController,
              decoration: _modernInputDecoration(
                labelText: 'Email Address',
                prefixIcon: Icons.email_outlined,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                // Basic email validation
                final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                if (!emailRegex.hasMatch(value)) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ).animate().slideX(begin: 0.5, end: 0, delay: 100.ms),
            
            const SizedBox(height: 20),
            
            // Password Input
            TextFormField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              decoration: _modernInputDecoration(
                labelText: 'Password',
                prefixIcon: Icons.lock_outline,
                suffixIcon: _isPasswordVisible 
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
                onSuffixIconPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                }
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a password';
                }
                if (value.length < 8) {
                  return 'Password must be at least 8 characters long';
                }
                return null;
              },
            ).animate().slideX(begin: 0.5, end: 0, delay: 200.ms),
            
            const SizedBox(height: 20),
            
            // Confirm Password Input
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: !_isConfirmPasswordVisible,
              decoration: _modernInputDecoration(
                labelText: 'Confirm Password',
                prefixIcon: Icons.lock_outline,
                suffixIcon: _isConfirmPasswordVisible 
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
                onSuffixIconPressed: () {
                  setState(() {
                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                  });
                }
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your password';
                }
                return null;
              },
            ).animate().slideX(begin: 0.5, end: 0, delay: 300.ms),
            
            const SizedBox(height: 20),
            
            // Terms and Conditions Checkbox
            Row(
              children: [
                Checkbox(
                  value: _termsAccepted,
                  onChanged: (bool? value) {
                    setState(() {
                      _termsAccepted = value ?? false;
                    });
                  },
                  activeColor: Colors.blue.shade400,
                ),
                Expanded(
                  child: Text(
                    'I agree to the Terms and Conditions',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
              ],
            ).animate().fadeIn(delay: 400.ms),
            
            const SizedBox(height: 30),
            
            // Signup Button
            ElevatedButton(
              onPressed: _signUp,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade400,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
                shadowColor: Colors.blue.shade200,
              ),
              child: Text(
                'Sign Up',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ).animate()
              .scale(begin: const Offset(0.5, 0.5))
              .shake(delay: 400.ms),
            
            const SizedBox(height: 20),
            
            // Login Link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account? ',
                  style: GoogleFonts.poppins(
                    color: Colors.grey.shade700,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to login page
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Log In',
                    style: GoogleFonts.poppins(
                      color: Colors.blue.shade400,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ).animate().fadeIn(delay: 600.ms),
          ],
        ),
      ),
    );
  }
}