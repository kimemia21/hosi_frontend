import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:frontend/Authentication/Signup.dart';
import 'package:frontend/Globals.dart';
import 'package:frontend/creds.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool isLoading = false;
  String _errorMesssage="";

  void _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        isLoading = true;
      });
      
      Map<String, dynamic> data = {
        "username": _usernameController.text,
        "password": _passwordController.text,
      };
      final response = await comms.postRequest(
        endpoint: "api/auth/login",
        data: data,
      );
      print(response);
      if (response["success"]) {
      
        setState(() {
          isLoading = false;
          _errorMesssage = "";
        });
        print(response);
      } 
      else {
        setState(() {
          isLoading = false;
          _errorMesssage = response["rsp"];
        });

        print(response);
      }
      // Implement actual login logic here
     
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HospitalColorPalette.background,
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Determine screen type
          bool isWideScreen = constraints.maxWidth > 1200;
          bool isMediumScreen =
              constraints.maxWidth > 800 && constraints.maxWidth <= 1200;
          bool isSmallScreen = constraints.maxWidth <= 800;

          return Center(
            child: SingleChildScrollView(
              child: Container(
                width:
                    isWideScreen
                        ? 900
                        : isMediumScreen
                        ? constraints.maxWidth * 0.9
                        : constraints.maxWidth * 0.95,
                constraints: BoxConstraints(
                  maxHeight:
                      isWideScreen
                          ? constraints.maxHeight * 0.85
                          : isMediumScreen
                          ? constraints.maxHeight * 0.9
                          : double.infinity,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: HospitalColorPalette.primary.withOpacity(0.1),
                      blurRadius: 15,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child:
                    isWideScreen
                        ? _buildWideScreenLayout()
                        : _buildResponsiveLayout(isSmallScreen),
              ),
            ),
          ).animate().fadeIn(duration: 600.ms);
        },
      ),
    );
  }

  Widget _buildResponsiveLayout(bool isSmallScreen) {
    return Padding(
      padding: EdgeInsets.all(isSmallScreen ? 20.0 : 40.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Logo
          Image.asset('images/logo.png', height: 120, fit: BoxFit.contain),
          const SizedBox(height: 20),

          // App Name
          Text(
            "HOSI Health System",
            style: GoogleFonts.poppins(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: HospitalColorPalette.primary,
              letterSpacing: 1.1,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          // Login Form
          _buildLoginForm(),
        ],
      ),
    );
  }

  Widget _buildWideScreenLayout() {
    return Row(
      children: [
        // Left Side: Hospital Information
        Expanded(
          flex: 6,
          child: Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: HospitalColorPalette.primary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25),
                bottomLeft: Radius.circular(25),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "HOSI Health System",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 30),
                Image.asset(
                  'images/logo.png',
                  height: 100,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 30),
                _buildHospitalDescription(),
              ],
            ),
          ),
        ),

        // Right Side: Login Form
        Expanded(flex: 6, child: _buildLoginForm()),
      ],
    );
  }

  Widget _buildHospitalDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Our Hospital Management System",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 15),
        _buildDescriptionItem(
          "Holistic Care",
          "Comprehensive healthcare solutions for modern medical environments.",
        ),
        _buildDescriptionItem(
          "Efficient Management",
          "Streamline operations, reduce administrative overhead, and improve patient care.",
        ),
        _buildDescriptionItem(
          "Secure Access",
          "Advanced security protocols to protect sensitive medical information.",
        ),
      ],
    );
  }

  Widget _buildDescriptionItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.medical_services_outlined,
            color: HospitalColorPalette.accent,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _errorMesssage != ""
                ? errorWidget(errorMessage: _errorMesssage!)
                : Container(),

            Text(
              "Welcome Back",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: HospitalColorPalette.textSecondary,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Login to access your hospital dashboard",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: HospitalColorPalette.textSecondary,
              ),
            ),
            const SizedBox(height: 30),
            _buildEmailField(),
            const SizedBox(height: 20),
            _buildPasswordField(),
            const SizedBox(height: 30),
            isLoading ? processingWidget("Logging in...", 14, HospitalColorPalette.primary) 
            : _buildLoginButton(),
            const SizedBox(height: 20),
            _buildSignUpRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _usernameController,
      style: GoogleFonts.poppins(),
      decoration: _inputDecoration("Username", Icons.email_outlined),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your Username';
        }

        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: !_isPasswordVisible,
      style: GoogleFonts.poppins(),
      decoration: _inputDecoration(
        "Password",
        Icons.lock_outline,
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: HospitalColorPalette.textSecondary,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: _login,
      style: ElevatedButton.styleFrom(
        backgroundColor: HospitalColorPalette.primary,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 3,
      ),
      child: Text(
        "Login",
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  Widget _buildSignUpRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: GoogleFonts.poppins(color: HospitalColorPalette.textSecondary),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignUpPage()),
            );
            // Implement sign up navigation
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Sign Up functionality not implemented',
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
                backgroundColor: HospitalColorPalette.warning,
              ),
            );
          },
          child: Text(
            "Sign Up",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: HospitalColorPalette.primary,
            ),
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(
    String label,
    IconData icon, {
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: HospitalColorPalette.textSecondary,
      ),
      prefixIcon: Icon(icon, color: HospitalColorPalette.primary),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: HospitalColorPalette.background,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(
          color: HospitalColorPalette.primaryLight.withOpacity(0.3),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: HospitalColorPalette.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: HospitalColorPalette.error),
      ),
    );
  }
}
