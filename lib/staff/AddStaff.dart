import 'package:flutter/material.dart';
import 'package:frontend/Globals.dart';
import 'package:frontend/creds.dart';
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
    'Official info',
    'Department info',
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


   Widget _buildDepartmentDropdown({
    required String hintText,
    required String? value,
    required Function(String?) onChanged,
    required List<DepartmentOnline> items,
    required double hintSize,
    String? Function(String?)? validator,
    double? maxWidth,
   }) {
    return CustomDropdown<DepartmentOnline>(
      hintText: hintText,
      value: value,
      onChanged: (newValue, selectedItem) {
        if (selectedItem != null) {
          setState(() {
            _description = selectedItem.description;
            _iconData = selectedItem.iconName;
          });
        }
        onChanged(newValue);
      },
      items: items,
      getLabel: (item) => item.name,
      getSearchableTerms: (item) => [item.name, item.description],
      validator: validator,
      buildListItem: (
        BuildContext context,
        DepartmentOnline dept,
        bool isSelected,
        bool isSmallScreen,
      ) {
        final IconData iconData = _getIconData(dept.iconName.split('.').last);
        final titleFontSize = isSmallScreen ? 14.0 : 16.0;
        final descFontSize = isSmallScreen ? 10.0 : 12.0;

        return Row(
          children: [
            Icon(
              iconData,
              size: isSmallScreen ? 20 : 24,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    dept.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: titleFontSize,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (!isSmallScreen || MediaQuery.of(context).size.width > 350)
                    Column(
                      children: [
                        const SizedBox(height: 2),
                        Text(
                          dept.description,
                          style: TextStyle(
                            fontSize: descFontSize,
                            color: Colors.grey[600],
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: isSmallScreen ? 1 : 2,
                        ),
                      ],
                    ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check,
                color: Theme.of(context).primaryColor,
                size: isSmallScreen ? 20 : 24,
              ),
          ],
        );
      },
    );
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
            constraints: BoxConstraints(minHeight: containerHeight),
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
        constraints: BoxConstraints(maxWidth: formWidth),
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
        // Determine screen size
        final ScreenSize screenSize = getScreenSize(constraints.maxWidth);

        // Adjust font sizes based on screen size
        double titleFontSize = screenSize.titleFontSize;
        double stepIndicatorSize = screenSize.stepIndicatorSize;
        bool isSmallScreen = screenSize == ScreenSize.small;

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
                            color:
                                isActive ? primaryColor : Colors.grey.shade300,
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
                              fontWeight:
                                  isActive
                                      ? FontWeight.bold
                                      : FontWeight.normal,
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
                          fontWeight:
                              isActive ? FontWeight.bold : FontWeight.normal,
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
        // Get responsive sizes
        final ResponsiveSizes sizes = getResponsiveSizes(constraints.maxWidth);
        final bool isMobileLayout = constraints.maxWidth < 768;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStepHeading('Basic information', sizes.headingSize),
            SizedBox(height: sizes.verticalSpacing),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildFormField(
                  'First name',
                  _buildTextField(
                    controller: _firstNameController,
                    hintText: ' first name',
                    hintSize: sizes.hintSize,
                  ),
                  width:
                      isMobileLayout
                          ? constraints.maxWidth
                          : (constraints.maxWidth - 16) / 2,
                  labelSize: sizes.labelSize,
                ),
                _buildFormField(
                  'Last name',
                  _buildTextField(
                    controller: _lastNameController,
                    hintText: ' last name',
                    hintSize: sizes.hintSize,
                  ),
                  width:
                      isMobileLayout
                          ? constraints.maxWidth
                          : (constraints.maxWidth - 16) / 2,
                  labelSize: sizes.labelSize,
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
                    items: ['Male', 'Female'],
                    hintSize: sizes.hintSize,
                  ),
                  width:
                      isMobileLayout
                          ? constraints.maxWidth
                          : (constraints.maxWidth - 16) / 2,
                  labelSize: sizes.labelSize,
                ),

                _buildFormField(
                  'Date of birth',
                  _buildDateField(
                    controller: _dateController,
                    hintText: 'Select date of birth',
                    hintSize: sizes.hintSize,
                  ),
                  width:
                      isMobileLayout
                          ? constraints.maxWidth
                          : (constraints.maxWidth - 16) / 2,
                  labelSize: sizes.labelSize,
                ),
              ],
            ),
            SizedBox(height: sizes.verticalSpacing),
            _buildNavigationButtons(previousVisible: false, sizes: sizes),
          ],
        );
      },
    );
  }

  Widget _buildDetailsStep() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Get responsive sizes
        final ResponsiveSizes sizes = getResponsiveSizes(constraints.maxWidth);
        final bool isMobileLayout = constraints.maxWidth < 768;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStepHeading('Official info', sizes.headingSize),
            SizedBox(height: sizes.verticalSpacing),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildFormField(
                  'Licence Number(optional)',
                  _buildTextField(
                    controller: _firstNameController,
                    hintText: 'Licence Number',
                    hintSize: sizes.hintSize,
                  ),
                  width:
                      isMobileLayout
                          ? constraints.maxWidth
                          : (constraints.maxWidth - 16) / 2,
                  labelSize: sizes.labelSize,
                ),
                _buildFormField(
                  'ID number',
                  _buildTextField(
                    controller: _lastNameController,
                    hintText: 'ID number',
                    hintSize: sizes.hintSize,
                  ),
                  width:
                      isMobileLayout
                          ? constraints.maxWidth
                          : (constraints.maxWidth - 16) / 2,
                  labelSize: sizes.labelSize,
                ),
                _buildFormField(
                  'Phone number',
                  _buildTextField(
                    controller: _firstNameController,
                    hintText: 'Phone Number',
                    hintSize: sizes.hintSize,
                  ),
                  width:
                      isMobileLayout
                          ? constraints.maxWidth
                          : (constraints.maxWidth - 16) / 2,
                  labelSize: sizes.labelSize,
                ),
                _buildFormField(
                  'email adress',
                  _buildTextField(
                    controller: _designationController,
                    hintText: 'email adress',
                    hintSize: sizes.hintSize,
                  ),
                  width:
                      isMobileLayout
                          ? constraints.maxWidth
                          : (constraints.maxWidth - 16) / 2,
                  labelSize: sizes.labelSize,
                ),
              ],
            ),
            SizedBox(height: sizes.verticalSpacing),
            _buildNavigationButtons(previousVisible: true, sizes: sizes),
          ],
        );
      },
    );
  }

  Widget _buildServicesStep() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final ResponsiveSizes sizes = getResponsiveSizes(constraints.maxWidth);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStepHeading('Select Services', sizes.headingSize),
            SizedBox(height: sizes.verticalSpacing),


            // FutureBuilder<List<DepartmentOnline>>(
            //       future: _departmentsFuture,
            //       builder: (context, snapshot) {
            //         if (snapshot.connectionState == ConnectionState.waiting) {
            //           return const SizedBox(
            //             height: 56,
            //             child: Center(child: CircularProgressIndicator()),
            //           );
            //         }

            //         if (snapshot.hasError) {
            //           return Text(
            //             "Error loading departments: ${snapshot.error}",
            //           );
            //         }

            //         return _buildFormField(
            //           'Department Type',
            //           _buildDepartmentDropdown(
            //             hintText: "Select Department",
            //             value: _selectedDeptType,
            //             onChanged: (value) {
            //               setState(() {
            //                 _selectedDeptType = value;
            //               });
            //             },
            //             items: snapshot.data ?? [],
            //             hintSize: hintSize,
            //             validator: (value) {
            //               if (value == null || value.isEmpty) {
            //                 return 'Please select a department';
            //               }
            //               return null;
            //             },
            //           ),
            //           width: constraints.maxWidth,
            //           labelSize: labelSize,
            //         );
            //       },
            //     ),


            
            // Add form fields for services step
            SizedBox(height: sizes.verticalSpacing),
            _buildNavigationButtons(previousVisible: true, sizes: sizes),
          ],
        );
      },
    );
  }

  Widget _buildReviewStep() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final ResponsiveSizes sizes = getResponsiveSizes(constraints.maxWidth);
        final bool isSmallScreen = constraints.maxWidth < 600;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStepHeading('Review and Submit', sizes.headingSize),
            SizedBox(height: sizes.verticalSpacing),
            // Add review summary
            SizedBox(height: sizes.verticalSpacing),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: _previousStep,
                  child: Text(
                    'PREVIOUS',
                    style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Submit form logic
                  },
                  style: _getButtonStyle(
                    isSmallScreen,
                    isPrimary: true,
                    isSubmit: true,
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

  // Helper widgets
  Widget _buildStepHeading(String title, double headingSize) {
    return Text(
      title,
      style: TextStyle(fontSize: headingSize, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildNavigationButtons({
    required bool previousVisible,
    required ResponsiveSizes sizes,
  }) {
    final bool isSmallScreen = sizes.isSmallScreen;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (previousVisible)
          TextButton(
            onPressed: _previousStep,
            child: Text(
              'PREVIOUS',
              style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
            ),
          )
        else
          const SizedBox.shrink(),
        ElevatedButton(
          onPressed: _nextStep,
          style: _getButtonStyle(isSmallScreen),
          child: const Text('NEXT STEP'),
        ),
      ],
    );
  }

  ButtonStyle _getButtonStyle(
    bool isSmallScreen, {
    bool isPrimary = true,
    bool isSubmit = false,
  }) {
    return ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? (isSubmit ? 16 : 12) : (isSubmit ? 24 : 16),
        vertical: isSmallScreen ? (isSubmit ? 10 : 8) : 12,
      ),
      textStyle: TextStyle(fontSize: isSmallScreen ? 12 : 14),
    );
  }

  Widget _buildFormField(
    String label,
    Widget field, {
    required double width,
    required double labelSize,
  }) {
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
      decoration: _getInputDecoration(hintText, hintSize),
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
      decoration: _getInputDecoration(hintText, hintSize, isDropdown: true),
      onChanged: onChanged,
      items:
          items.map<DropdownMenuItem<String>>((String value) {
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
      decoration: _getInputDecoration(
        hintText,
        hintSize,
        suffixIcon: const Icon(Icons.calendar_today, size: 20),
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

  // Common input decoration
  InputDecoration _getInputDecoration(
    String hintText,
    double hintSize, {
    Widget? suffixIcon,
    bool isDropdown = false,
  }) {
    return InputDecoration(
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      suffixIcon: suffixIcon,
    );
  }
}

// Helper classes for responsive sizing
enum ScreenSize { small, medium, large }

class ResponsiveSizes {
  final double headingSize;
  final double labelSize;
  final double hintSize;
  final double verticalSpacing;
  final bool isSmallScreen;

  ResponsiveSizes({
    required this.headingSize,
    required this.labelSize,
    required this.hintSize,
    required this.verticalSpacing,
    required this.isSmallScreen,
  });
}

ScreenSize getScreenSize(double width) {
  if (width < 600) return ScreenSize.small;
  if (width < 960) return ScreenSize.medium;
  return ScreenSize.large;
}

ResponsiveSizes getResponsiveSizes(double width) {
  final bool isSmallScreen = width < 600;

  return ResponsiveSizes(
    headingSize: isSmallScreen ? 20.0 : 24.0,
    labelSize: isSmallScreen ? 12.0 : 14.0,
    hintSize: isSmallScreen ? 10.0 : 12.0,
    verticalSpacing: isSmallScreen ? 24.0 : 32.0,
    isSmallScreen: isSmallScreen,
  );
}

extension ScreenSizeExtension on ScreenSize {
  double get titleFontSize {
    switch (this) {
      case ScreenSize.small:
        return 10;
      case ScreenSize.medium:
        return 12;
      case ScreenSize.large:
        return 14;
    }
  }

  double get stepIndicatorSize {
    switch (this) {
      case ScreenSize.small:
        return 24;
      case ScreenSize.medium:
        return 28;
      case ScreenSize.large:
        return 30;
    }
  }
}
