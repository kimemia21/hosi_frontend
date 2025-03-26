import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:frontend/Authentication/LoginPage.dart';
import 'package:frontend/Globals.dart';
import 'package:frontend/creds.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  String? _errorMessage;

  bool isLoading = false;
  // Centralized text controllers
  final Map<String, TextEditingController> _controllers = {
    'username': TextEditingController(),
    'staffId': TextEditingController(),
    'password': TextEditingController(),
    'confirmPassword': TextEditingController(),
  };

  // Visibility states for password fields
  final Map<String, bool> _passwordVisibility = {
    'password': false,
    'confirmPassword': false,
  };

  void _togglePasswordVisibility(String field) {
    setState(() {
      _passwordVisibility[field] = !_passwordVisibility[field]!;
    });
  }

  void _signUp() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        isLoading = true;
      });

      // Create a map of the form data from controllers
      Map<String, dynamic> formData = {
        'username': _controllers['username']!.text,
        'staffId': int.parse(_controllers['staffId']!.text),
        'password': _controllers['password']!.text,
      };

      final response = await comms.postRequest(
        data: formData,
        endpoint: "api/auth/register",
      );
      if (response["success"]) {
        setState(() {
          isLoading = false;
          _errorMessage = null;
        });
        showSuccessSnackBar(context, "Account Creation", response["rsp"]);

        print("successfully added");
      } else {
        print(response["rsp"]);
        setState(() {
          isLoading = false;
          _errorMessage = response["rsp"];
        });
      }

      print(formData); // For testing

    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HospitalColorPalette.background,
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Define responsive breakpoints
          bool isWideScreen = constraints.maxWidth > 1200;
          bool isMediumScreen =
              constraints.maxWidth > 800 && constraints.maxWidth <= 1200;
          bool isTabletScreen =
              constraints.maxWidth > 600 && constraints.maxWidth <= 800;
          bool isSmallScreen = constraints.maxWidth <= 600;

          return Center(
            child: SingleChildScrollView(
              child: Container(
                width: _calculateContainerWidth(
                  constraints,
                  isWideScreen,
                  isMediumScreen,
                  isTabletScreen,
                  isSmallScreen,
                ),
                constraints: BoxConstraints(
                  maxHeight: _calculateContainerHeight(
                    constraints,
                    isWideScreen,
                    isMediumScreen,
                    isTabletScreen,
                    isSmallScreen,
                  ),
                ),
                decoration: _buildContainerDecoration(),
                child:
                    isWideScreen
                        ? _buildWideScreenLayout()
                        : isMediumScreen
                        ? _buildMediumScreenLayout()
                        : isTabletScreen
                        ? _buildTabletLayout()
                        : _buildMobileLayout(),
              ),
            ),
          ).animate().fadeIn(duration: 600.ms);
        },
      ),
    );
  }

  double _calculateContainerWidth(
    BoxConstraints constraints,
    bool isWideScreen,
    bool isMediumScreen,
    bool isTabletScreen,
    bool isSmallScreen,
  ) {
    if (isWideScreen) return 900;
    if (isMediumScreen) return constraints.maxWidth * 0.9;
    if (isTabletScreen) return constraints.maxWidth * 0.95;
    return constraints.maxWidth;
  }

  double _calculateContainerHeight(
    BoxConstraints constraints,
    bool isWideScreen,
    bool isMediumScreen,
    bool isTabletScreen,
    bool isSmallScreen,
  ) {
    if (isWideScreen) return constraints.maxHeight * 0.85;
    if (isMediumScreen) return constraints.maxHeight * 0.9;
    if (isTabletScreen) return constraints.maxHeight * 0.95;
    return double.infinity;
  }

  BoxDecoration _buildContainerDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(25),
      boxShadow: [
        BoxShadow(
          color: HospitalColorPalette.primary.withOpacity(0.1),
          blurRadius: 15,
          spreadRadius: 5,
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLogo(isMobile: true),
          const SizedBox(height: 20),
          _buildSignUpForm(isMobile: true),
        ],
      ),
    );
  }

  Widget _buildTabletLayout() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.55,
      padding: const EdgeInsets.all(30.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLogo(isTablet: true),
          const SizedBox(height: 30),
          _buildSignUpForm(isTablet: true),
        ],
      ),
    );
  }

  Widget _buildMediumScreenLayout() {
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

        // Right Side: SignUp Form
        Expanded(flex: 6, child: _buildSignUpForm()),
      ],
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

        // Right Side: SignUp Form
        Expanded(flex: 6, child: _buildSignUpForm()),
      ],
    );
  }

  Widget _buildLogo({
    bool isTablet = false,
    bool isMedium = false,
    bool isMobile = false,
  }) {
    double logoHeight =
        isTablet
            ? 150
            : isMedium
            ? 140
            : isMobile
            ? 120
            : 160;

    return Column(
      children: [
        Image.asset('images/logo.png', height: logoHeight, fit: BoxFit.contain),
        const SizedBox(height: 20),
        Text(
          "HOSI Health System",
          style: GoogleFonts.poppins(
            fontSize:
                isTablet
                    ? 24
                    : isMedium
                    ? 22
                    : isMobile
                    ? 20
                    : 26,
            fontWeight: FontWeight.w700,
            color: HospitalColorPalette.primary,
            letterSpacing: 1.1,
          ),
          textAlign: TextAlign.center,
        ),
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

  Widget _buildSignUpForm({bool isTablet = false, bool isMobile = false}) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal:
            isTablet
                ? 20
                : isMobile
                ? 10
                : 30,
        vertical:
            isTablet
                ? 15
                : isMobile
                ? 10
                : 20,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _errorMessage != null
                ? Container(child: errorWidget(errorMessage: _errorMessage!))
                : Container(),
            Text(
              "Create an Account",
              style: GoogleFonts.poppins(
                fontSize:
                    isTablet
                        ? 14
                        : isMobile
                        ? 12
                        : 16,
                fontWeight: FontWeight.w400,
                color: HospitalColorPalette.textSecondary,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Sign up to access your hospital dashboard",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize:
                    isTablet
                        ? 12
                        : isMobile
                        ? 10
                        : 12,
                fontWeight: FontWeight.w400,
                color: HospitalColorPalette.textSecondary,
              ),
            ),
            const SizedBox(height: 30),
            _buildTextField(
              label: 'username',
              icon: Icons.person_outlined,
              controller: _controllers['username']!,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              label: 'Staff id',
              icon: Icons.edit_document,
              controller: _controllers['staffId']!,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your staff id';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            _buildTextField(
              label: 'password',
              icon: Icons.lock_outline,
              controller: _controllers['password']!,
              isPassword: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            _buildTextField(
              label: 'confirmPassword',
              icon: Icons.lock_outline,
              controller: _controllers['confirmPassword']!,
              isPassword: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your password';
                }
                if (value != _controllers["password"]!.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            const SizedBox(height: 30),
            isLoading
                ? processingWidget(
                  "Creating Account",
                  14,
                  HospitalColorPalette.primary,
                )
                : _buildSignUpButton(isTablet: isTablet, isMobile: isMobile),

            const SizedBox(height: 20),
            _buildLoginRow(isTablet: isTablet, isMobile: isMobile),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    bool isPassword = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? !_passwordVisibility[label]! : false,
      style: GoogleFonts.poppins(),
      decoration: _inputDecoration(
        label,
        icon,
        suffixIcon:
            isPassword
                ? IconButton(
                  icon: Icon(
                    _passwordVisibility[label]!
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: HospitalColorPalette.textSecondary,
                  ),
                  onPressed: () => _togglePasswordVisibility(label),
                )
                : null,
      ),
      validator: validator ?? _defaultValidator,
    );
  }

  String? _defaultValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter $value';
    }
    return null;
  }

  Widget _buildSignUpButton({bool isTablet = false, bool isMobile = false}) {
    return ElevatedButton(
      onPressed: _signUp,
      style: ElevatedButton.styleFrom(
        backgroundColor: HospitalColorPalette.primary,
        minimumSize: Size(
          double.infinity,
          isTablet
              ? 40
              : isMobile
              ? 35
              : 50,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 3,
      ),
      child: Text(
        "Sign Up",
        style: GoogleFonts.poppins(
          fontSize:
              isTablet
                  ? 14
                  : isMobile
                  ? 12
                  : 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  Widget _buildLoginRow({bool isTablet = false, bool isMobile = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account? ",
          style: GoogleFonts.poppins(
            color: HospitalColorPalette.textSecondary,
            fontSize:
                isTablet
                    ? 12
                    : isMobile
                    ? 10
                    : 14,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
          child: Text(
            "Login",
            style: GoogleFonts.poppins(
              fontSize:
                  isTablet
                      ? 12
                      : isMobile
                      ? 10
                      : 14,
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
