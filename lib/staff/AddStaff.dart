import 'package:flutter/material.dart';
import 'package:frontend/Globals.dart';
import 'package:intl/intl.dart';

class Addstaff extends StatefulWidget {
  const Addstaff({Key? key}) : super(key: key);

  @override
  State<Addstaff> createState() => _AddstaffState();
}

class _AddstaffState extends State<Addstaff> {
  int _currentStep = 0;
  final List<String> _stepTitles = [
    'Basic Information',
    'Enter Details',
    'Select Services',
    'Review and Submit',
  ];

  // Controllers for form fields
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  String? _selectedUserType;
  String? _selectedGender;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _designationController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _stepTitles.length - 1) {
      setState(() {
        _currentStep += 1;
      });
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep -= 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size
    final screenSize = MediaQuery.of(context).size;
    
    // Determine container width based on screen size
    double containerWidth = screenSize.width;
    double containerHeight = screenSize.height;
    
    // For very large screens, cap the width
    if (screenSize.width > 1000) {
      containerWidth = screenSize.width * 0.74;
    } else if (screenSize.width > 900) {
      containerWidth = screenSize.width * 0.75;
    } else {
      containerWidth = screenSize.width * 0.9;
    }
    
    // Set container height based on screen size
    if (screenSize.height > 900) {
      containerHeight = screenSize.height * 0.75;
    } else {
      containerHeight = screenSize.height * 0.85;
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: containerWidth,
            constraints: BoxConstraints(
              minHeight: containerHeight,
            ),
            margin: EdgeInsets.symmetric(
              vertical: screenSize.height * 0.05,
              horizontal: screenSize.width * 0.02,
            ),
            padding: EdgeInsets.all(screenSize.width > 600 ? 24.0 : 16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey.shade100,
            ),
            child: _buildFormContent(context),
          ),
        ),
      ),
    );
  }

  Widget _buildFormContent(BuildContext context) {
    // Form content width determined by screen size
    final screenWidth = MediaQuery.of(context).size.width;
    double formWidth = screenWidth;
    
    // Adjust based on screen size
    if (screenWidth > 1400) {
      formWidth = 1000;
    } else if (screenWidth > 900) {
      formWidth = screenWidth * 0.7;
    } else {
      formWidth = screenWidth * 0.9;
    }

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: formWidth,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            _buildStepper(),
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
            _buildCurrentStep(),
          ],
        ),
      ),
    );
  }

  Widget _buildStepper() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Determine if this is a small, medium, or large screen
        bool isSmallScreen = constraints.maxWidth < 600;
        bool isMediumScreen = constraints.maxWidth >= 600 && constraints.maxWidth < 960;
        bool isLargeScreen = constraints.maxWidth >= 960;
        
        // Adjust font sizes based on screen size
        double titleFontSize = isSmallScreen ? 10 : (isMediumScreen ? 12 : 14);
        double stepIndicatorSize = isSmallScreen ? 24 : (isMediumScreen ? 28 : 30);
        
        return Column(
          children: [
            Row(
              children: List.generate(_stepTitles.length * 2 - 1, (index) {
                // For even indices, show step circles
                if (index % 2 == 0) {
                  int stepIndex = index ~/ 2;
                  bool isActive = stepIndex <= _currentStep;

                  return Expanded(
                    flex: isSmallScreen ? 2 : 1,
                    child: Column(
                      children: [
                        Container(
                          width: stepIndicatorSize,
                          height: stepIndicatorSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isActive ? primaryColor : Colors.grey.shade300,
                          ),
                          child: Center(
                            child: Text(
                              '${stepIndex + 1}',
                              style: TextStyle(
                                color: isActive ? Colors.white : Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: isSmallScreen ? 12 : 14,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        if (!isSmallScreen)
                          Text(
                            _stepTitles[stepIndex],
                            style: TextStyle(
                              fontSize: titleFontSize,
                              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                              color: isActive ? primaryColor : Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                      ],
                    ),
                  );
                }
                // For odd indices, show connecting lines
                else {
                  int lineIndex = index ~/ 2;
                  bool isActive = lineIndex < _currentStep;

                  return Expanded(
                    flex: isSmallScreen ? 1 : 2,
                    child: Container(
                      height: 2,
                      color: isActive ? primaryColor : Colors.grey.shade300,
                    ),
                  );
                }
              }),
            ),
            // For small screens, show step titles in a second row
            if (isSmallScreen)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: List.generate(_stepTitles.length, (index) {
                    bool isActive = index <= _currentStep;
                    return Expanded(
                      child: Text(
                        _stepTitles[index],
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                          color: isActive ? primaryColor : Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildBasicInformationStep();
      case 1:
        return _buildDetailsStep();
      case 2:
        return _buildServicesStep();
      case 3:
        return _buildReviewStep();
      default:
        return Container();
    }
  }

  Widget _buildBasicInformationStep() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive sizing
        bool isSmallScreen = constraints.maxWidth < 600;
        bool isMobileLayout = constraints.maxWidth < 768;
        double headingSize = isSmallScreen ? 20.0 : 24.0;
        double labelSize = isSmallScreen ? 12.0 : 14.0;
        double hintSize = isSmallScreen ? 10.0 : 12.0;
        double verticalSpacing = isSmallScreen ? 24.0 : 32.0;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Basic information',
              style: TextStyle(fontSize: headingSize, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: verticalSpacing),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildFormField(
                  'User type',
                  _buildDropdownField(
                    hintText: 'Select user type',
                    value: _selectedUserType,
                    onChanged: (value) {
                      setState(() {
                        _selectedUserType = value;
                      });
                    },
                    items: ['Patient', 'Doctor', 'Administrator'],
                    hintSize: hintSize,
                  ),
                  width: isMobileLayout ? constraints.maxWidth : (constraints.maxWidth - 16) / 2,
                  labelSize: labelSize,
                ),
                _buildFormField(
                  'Gender',
                  _buildDropdownField(
                    hintText: 'Select gender',
                    value: _selectedGender,
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value;
                      });
                    },
                    items: ['Male', 'Female', 'Other'],
                    hintSize: hintSize,
                  ),
                  width: isMobileLayout ? constraints.maxWidth : (constraints.maxWidth - 16) / 2,
                  labelSize: labelSize,
                ),
                _buildFormField(
                  'First name',
                  _buildTextField(
                    controller: _firstNameController,
                    hintText: 'Your first name',
                    hintSize: hintSize,
                  ),
                  width: isMobileLayout ? constraints.maxWidth : (constraints.maxWidth - 16) / 2,
                  labelSize: labelSize,
                ),
                _buildFormField(
                  'Designation',
                  _buildTextField(
                    controller: _designationController,
                    hintText: 'Your designation',
                    hintSize: hintSize,
                  ),
                  width: isMobileLayout ? constraints.maxWidth : (constraints.maxWidth - 16) / 2,
                  labelSize: labelSize,
                ),
                _buildFormField(
                  'Last name',
                  _buildTextField(
                    controller: _lastNameController,
                    hintText: 'Your last name',
                    hintSize: hintSize,
                  ),
                  width: isMobileLayout ? constraints.maxWidth : (constraints.maxWidth - 16) / 2,
                  labelSize: labelSize,
                ),
                _buildFormField(
                  'Date of birth',
                  _buildDateField(
                    controller: _dateController,
                    hintText: 'Select your date of birth',
                    hintSize: hintSize,
                  ),
                  width: isMobileLayout ? constraints.maxWidth : (constraints.maxWidth - 16) / 2,
                  labelSize: labelSize,
                ),
                _buildFormField(
                  'Email address',
                  _buildTextField(
                    controller: _emailController,
                    hintText: 'Your email address',
                    hintSize: hintSize,
                  ),
                  width: constraints.maxWidth,
                  labelSize: labelSize,
                ),
              ],
            ),
            SizedBox(height: verticalSpacing),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: _nextStep,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 12 : 16,
                    vertical: isSmallScreen ? 8 : 12,
                  ),
                  textStyle: TextStyle(
                    fontSize: isSmallScreen ? 12 : 14,
                  ),
                ),
                child: const Text('NEXT STEP'),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailsStep() {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isSmallScreen = constraints.maxWidth < 600;
        double headingSize = isSmallScreen ? 20.0 : 24.0;
        double verticalSpacing = isSmallScreen ? 24.0 : 32.0;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter Details',
              style: TextStyle(fontSize: headingSize, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: verticalSpacing),
            // Add form fields for details step
            SizedBox(height: verticalSpacing),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: _previousStep,
                  child: Text('PREVIOUS', style: TextStyle(fontSize: isSmallScreen ? 12 : 14)),
                ),
                ElevatedButton(
                  onPressed: _nextStep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 12 : 16,
                      vertical: isSmallScreen ? 8 : 12,
                    ),
                    textStyle: TextStyle(
                      fontSize: isSmallScreen ? 12 : 14,
                    ),
                  ),
                  child: const Text('NEXT STEP'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildServicesStep() {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isSmallScreen = constraints.maxWidth < 600;
        double headingSize = isSmallScreen ? 20.0 : 24.0;
        double verticalSpacing = isSmallScreen ? 24.0 : 32.0;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Services',
              style: TextStyle(fontSize: headingSize, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: verticalSpacing),
            // Add form fields for services step
            SizedBox(height: verticalSpacing),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: _previousStep,
                  child: Text('PREVIOUS', style: TextStyle(fontSize: isSmallScreen ? 12 : 14)),
                ),
                ElevatedButton(
                  onPressed: _nextStep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 12 : 16,
                      vertical: isSmallScreen ? 8 : 12,
                    ),
                    textStyle: TextStyle(
                      fontSize: isSmallScreen ? 12 : 14,
                    ),
                  ),
                  child: const Text('NEXT STEP'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildReviewStep() {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isSmallScreen = constraints.maxWidth < 600;
        double headingSize = isSmallScreen ? 20.0 : 24.0;
        double verticalSpacing = isSmallScreen ? 24.0 : 32.0;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Review and Submit',
              style: TextStyle(fontSize: headingSize, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: verticalSpacing),
            // Add review summary
            SizedBox(height: verticalSpacing),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: _previousStep,
                  child: Text('PREVIOUS', style: TextStyle(fontSize: isSmallScreen ? 12 : 14)),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Submit form logic
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 16 : 24,
                      vertical: isSmallScreen ? 10 : 12,
                    ),
                    textStyle: TextStyle(
                      fontSize: isSmallScreen ? 12 : 14,
                    ),
                  ),
                  child: const Text('SUBMIT'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildFormField(String label, Widget field, {required double width, required double labelSize}) {
    return Container(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: labelSize, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          field,
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required double hintSize,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: hintSize,
          color: Colors.grey,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 16,
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String hintText,
    required String? value,
    required Function(String?) onChanged,
    required List<String> items,
    required double hintSize,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      hint: Text(
        hintText,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: hintSize,
          color: Colors.grey,
        ),
      ),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 16,
        ),
      ),
      onChanged: onChanged,
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(value: value, child: Text(value));
      }).toList(),
      isExpanded: true, // Ensures the dropdown takes full width
    );
  }

  Widget _buildDateField({
    required TextEditingController controller,
    required String hintText,
    required double hintSize,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: hintSize,
          color: Colors.grey,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 16,
        ),
        suffixIcon: Icon(Icons.calendar_today, size: 20),
      ),
      readOnly: true,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );

        if (pickedDate != null) {
          controller.text = DateFormat('MM/dd/yyyy').format(pickedDate);
        }
      },
    );
  }
}