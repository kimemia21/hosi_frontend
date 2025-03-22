import 'package:flutter/material.dart';
import 'package:frontend/CustomDropdown.dart';
import 'package:frontend/Globals.dart';
import 'package:frontend/Model/Departments.dart';
import 'package:frontend/creds.dart';
import 'package:frontend/utils/ReqGlobal.dart';
import 'package:intl/intl.dart';

class Addstaff extends StatefulWidget {
  const Addstaff({Key? key}) : super(key: key);

  @override
  State<Addstaff> createState() => _AddstaffState();
}

class _AddstaffState extends State<Addstaff> {
  int _currentStep = 0;

  late Future<List<Department>> _departmentsFuture;
  int? _selectedDeptId;
  String _iconData = "";
  String _deptName = "";
  String? _role;

  // Define form keys for validation
  final _basicInfoFormKey = GlobalKey<FormState>();
  final _officialInfoFormKey = GlobalKey<FormState>();
  final _departmentInfoFormKey = GlobalKey<FormState>();

  // Shared form field properties
  final _borderRadius = BorderRadius.circular(4);

  final List<String> _roles = [
    'Doctor',
    'Nurse',
    'Pharmacist',
    'Lab Technician',
    'Receptionist',
    'Cleaner',
    'Security',
    'Other',
  ];

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
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _licenceNumberController =
      TextEditingController();
  final TextEditingController _idNumberController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  String? _selectedGender;

  String _description = "";

  @override
  void initState() {
    super.initState();
    _departmentsFuture = fetchGlobal<Department>(
      getRequests: (endpoint) => comms.getRequests(endpoint: endpoint),
      fromJson: (json) => Department.fromJson(json),
      endpoint: "api/departments",
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _licenceNumberController.dispose();
    _idNumberController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _nextStep() {
    // Validate current step before proceeding
    if (_validateCurrentStep()) {
      if (_currentStep < _stepTitles.length - 1) {
        setState(() {
          _currentStep += 1;
        });
      }
    }
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _basicInfoFormKey.currentState?.validate() ?? false;
      case 1:
        return _officialInfoFormKey.currentState?.validate() ?? false;
      case 2:
        return _departmentInfoFormKey.currentState?.validate() ?? false;
      default:
        return true;
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
    required List<Department> items,
    required double hintSize,
    String? Function(String?)? validator,
  }) {
    return CustomDropdown<Department>(
      hintText: hintText,
      value: value,
      onChanged: (newValue, selectedItem) {
        if (selectedItem != null) {
          setState(() {
            _selectedDeptId = selectedItem.departmentId;
            _description = selectedItem.description;
            // _deptName = selectedItem.name;
            _iconData = selectedItem.iconData;
          });
        }
        onChanged(newValue);
      },
      items: items,
      getLabel: (item) => item.name,
      getSearchableTerms: (item) => [item.name, item.description],
      validator: validator,
      buildListItem: _buildDepartmentListItem,
    );
  }

  Widget _buildDepartmentListItem(
    BuildContext context,
    Department dept,
    bool isSelected,
    bool isSmallScreen,
  ) {
    final IconData iconData = getIconData(dept.iconData.split('.').last);
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
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    // Determine container width based on screen size
    double containerWidth = screenSize.width;
    double containerHeight = screenSize.height;

    // For very large screens, cap the width
    containerWidth =
        screenSize.width > 1000
            ? screenSize.width * 0.74
            : screenSize.width > 900
            ? screenSize.width * 0.75
            : screenSize.width * 0.9;

    // Set container height based on screen size
    containerHeight =
        screenSize.height > 900
            ? screenSize.height * 0.75
            : screenSize.height * 0.85;

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
    double formWidth =
        screenWidth > 1400
            ? 1000
            : screenWidth > 900
            ? screenWidth * 0.7
            : screenWidth * 0.9;

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

        return Form(
          key: _basicInfoFormKey,
          child: Column(
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
                    _buildValidatedTextField(
                      controller: _firstNameController,
                      hintText: 'First name',
                      hintSize: sizes.hintSize,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'First name is required';
                        }
                        return null;
                      },
                    ),
                    width:
                        isMobileLayout
                            ? constraints.maxWidth
                            : (constraints.maxWidth - 16) / 2,
                    labelSize: sizes.labelSize,
                  ),
                  _buildFormField(
                    'Last name',
                    _buildValidatedTextField(
                      controller: _lastNameController,
                      hintText: 'Last name',
                      hintSize: sizes.hintSize,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Last name is required';
                        }
                        return null;
                      },
                    ),
                    width:
                        isMobileLayout
                            ? constraints.maxWidth
                            : (constraints.maxWidth - 16) / 2,
                    labelSize: sizes.labelSize,
                  ),
                  _buildFormField(
                    'Gender',
                    _buildValidatedDropdownField(
                      hintText: 'Select gender',
                      value: _selectedGender,
                      onChanged: (value) {
                        setState(() {
                          _selectedGender = value;
                        });
                      },
                      items: ['Male', 'Female'],
                      hintSize: sizes.hintSize,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Gender is required';
                        }
                        return null;
                      },
                    ),
                    width:
                        isMobileLayout
                            ? constraints.maxWidth
                            : (constraints.maxWidth - 16) / 2,
                    labelSize: sizes.labelSize,
                  ),
                  _buildFormField(
                    'Date of birth',
                    _buildValidatedDateField(
                      controller: _dateController,
                      hintText: 'Select date of birth',
                      hintSize: sizes.hintSize,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Date of birth is required';
                        }
                        return null;
                      },
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
          ),
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

        return Form(
          key: _officialInfoFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStepHeading('Official info', sizes.headingSize),
              SizedBox(height: sizes.verticalSpacing),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _buildFormField(
                    'Licence Number (optional)',
                    _buildValidatedTextField(
                      controller: _licenceNumberController,
                      hintText: 'Licence Number',
                      hintSize: sizes.hintSize,
                      validator: (value) => null, // Optional field
                    ),
                    width:
                        isMobileLayout
                            ? constraints.maxWidth
                            : (constraints.maxWidth - 16) / 2,
                    labelSize: sizes.labelSize,
                  ),
                  _buildFormField(
                    'ID number',
                    _buildValidatedTextField(
                      controller: _idNumberController,
                      hintText: 'ID number',
                      hintSize: sizes.hintSize,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'ID number is required';
                        }
                        return null;
                      },
                    ),
                    width:
                        isMobileLayout
                            ? constraints.maxWidth
                            : (constraints.maxWidth - 16) / 2,
                    labelSize: sizes.labelSize,
                  ),
                  _buildFormField(
                    'Phone number',
                    _buildValidatedTextField(
                      controller: _phoneController,
                      hintText: 'Phone Number',
                      hintSize: sizes.hintSize,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Phone number is required';
                        }
                        return null;
                      },
                    ),
                    width:
                        isMobileLayout
                            ? constraints.maxWidth
                            : (constraints.maxWidth - 16) / 2,
                    labelSize: sizes.labelSize,
                  ),
                  _buildFormField(
                    'Email address',
                    _buildValidatedTextField(
                      controller: _emailController,
                      hintText: 'Email address',
                      hintSize: sizes.hintSize,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email address is required';
                        }
                        if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(value)) {
                          return 'Enter a valid email address';
                        }
                        return null;
                      },
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
          ),
        );
      },
    );
  }

  Widget _buildServicesStep() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Get responsive sizes
        final ResponsiveSizes sizes = getResponsiveSizes(constraints.maxWidth);
        final bool isMobileLayout = constraints.maxWidth < 768;

        return Form(
          key: _departmentInfoFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStepHeading('Departments info', sizes.headingSize),
              SizedBox(height: sizes.verticalSpacing),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  FutureBuilder<List<Department>>(
                    future: _departmentsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox(
                          height: 56,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      if (snapshot.hasError) {
                        return Text(
                          "Error loading departments: ${snapshot.error}",
                        );
                      }

                      return Column(
                        children: [
                          _buildFormField(
                            'Department',
                            _buildDepartmentDropdown(
                              hintText: "Select Department",
                              value: _deptName,
                              onChanged: (value) {
                                setState(() {
                                  _deptName = value!;
                                });
                              },
                              items: snapshot.data ?? [],
                              hintSize: sizes.hintSize,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a department';
                                }
                                return null;
                              },
                            ),
                            width: constraints.maxWidth,
                            labelSize: sizes.labelSize,
                          ),
                          SizedBox(height: 16),
                          _buildDepartmentInfoCard(constraints.maxWidth),
                        ],
                      );
                    },
                  ),

                  _buildFormField(
                    'Staff Role',
                    _buildValidatedDropdownField(
                      hintText: "Role",
                      value: _role,
                      onChanged: (value) {
                        setState(() {
                          _role = value;
                        });
                      },
                      items: _roles,
                      hintSize: sizes.hintSize,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Staff role is required';
                        }
                        return null;
                      },
                    ),
                    width:
                        isMobileLayout
                            ? constraints.maxWidth
                            : constraints.maxWidth,
                    labelSize: sizes.labelSize,
                  ),
                ],
              ),
              SizedBox(height: sizes.verticalSpacing),
              _buildNavigationButtons(previousVisible: true, sizes: sizes),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDepartmentInfoCard(double width) {
    return Visibility(
      visible: _description.isNotEmpty,
      child: Container(
        width: width,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blue.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _iconData.isNotEmpty
                      ? getIconData(_iconData.split('.').last)
                      : Icons.local_hospital,
                  color: Colors.blue[700],
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  _deptName.isNotEmpty ? _deptName : "Department",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.blue[700],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              _description,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
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

            // Review Card
            Container(
              width: constraints.maxWidth,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Personal Info Section
                  _buildReviewSection("Personal Information", Icons.person, [
                    ReviewField(
                      "Name",
                      "${_firstNameController.text} ${_lastNameController.text}",
                    ),
                    ReviewField("Gender", _selectedGender ?? "Not provided"),
                    ReviewField("Date of Birth", _dateController.text),
                  ]),

                  Divider(height: 32, thickness: 1),

                  // Official Info Section
                  _buildReviewSection("Official Information", Icons.badge, [
                    ReviewField("ID Number", _idNumberController.text),
                    ReviewField(
                      "License Number",
                      _licenceNumberController.text.isEmpty
                          ? "Not provided"
                          : _licenceNumberController.text,
                    ),
                    ReviewField("Phone Number", _phoneController.text),
                    ReviewField("Email", _emailController.text),
                  ]),

                  Divider(height: 32, thickness: 1),

                  // Department Info Section
                  _buildReviewSection(
                    "Department Information",
                    _iconData.isNotEmpty
                        ? getIconData(_iconData.split('.').last)
                        : Icons.local_hospital,
                    [
                      ReviewField(
                        "Department",
                        _deptName.isEmpty ? "Not selected" : _deptName,
                      ),
                      ReviewField("Role", _role ?? "Not selected"),
                    ],
                  ),
                ],
              ),
            ),

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
                  onPressed: _submitForm,
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

  Widget _buildReviewSection(
    String title,
    IconData icon,
    List<ReviewField> fields,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: primaryColor, size: 20),
            SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        ...fields
            .map(
              (field) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 120,
                      child: Text(
                        "${field.label}:",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        field.value,
                        style: TextStyle(fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ],
    );
  }

  void _submitForm() async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      final Map<String, dynamic> staffData = {
        "first_name": _firstNameController.text,
        "last_name": _lastNameController.text,
        "role": _role,
        "department_id": _selectedDeptId!,
        "specialization": _role,
        "id_number": _idNumberController.text,
        "licenseNumber": _licenceNumberController.text,
        "phone": _phoneController.text,
        "email": _emailController.text,
        "hire_date": DateTime.now().toIso8601String(),
      };

      final response = await comms.postRequest(endpoint: "api/staff", data: staffData);
      
      // Close loading dialog
      Navigator.pop(context);

      if (response["success"]) {
        // Show success dialog
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Success'),
              content: const Text('Staff member added successfully'),
              icon: const Icon(Icons.check_circle, color: Colors.green, size: 48),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                    Navigator.of(context).pop(); // Return to previous screen
                  },
                ),
              ],
            );
          },
        );
      } else {
        // Show error dialog
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: Text(response["message"] ?? 'Failed to add staff member'),
              icon: const Icon(Icons.error, color: Colors.red, size: 48),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      // Close loading dialog
      Navigator.pop(context);
      
      // Show error dialog
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('An error occurred: $e'),
            icon: const Icon(Icons.error, color: Colors.red, size: 48),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        },
      );
    }
  }

  // Helper widgets
  Widget _buildStepHeading(String title, double headingSize) {
    return Text(
      title,
      style: TextStyle(
        fontSize: headingSize,
        fontWeight: FontWeight.bold,
        color: primaryColor,
      ),
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

  // Form fields with validation
  Widget _buildValidatedTextField({
    required TextEditingController controller,
    required String hintText,
    required double hintSize,
    required String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: _getInputDecoration(hintText, hintSize),
      validator: validator,
    );
  }

  Widget _buildValidatedDateField({
    required TextEditingController controller,
    required String hintText,
    required double hintSize,
    required String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: _getInputDecoration(hintText, hintSize),
      validator: validator,
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1920),
          lastDate: DateTime.now(),
        );
        if (picked != null) {
          setState(() {
            controller.text = DateFormat('dd/MM/yyyy').format(picked);
          });
        }
      },
    );
  }

  Widget _buildValidatedDropdownField({
    required String hintText,
    required String? value,
    required Function(String?) onChanged,
    required List<String> items,
    required double hintSize,
    required String? Function(String?)? validator,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: _getInputDecoration(hintText, hintSize),
      items:
          items.map((String item) {
            return DropdownMenuItem<String>(value: item, child: Text(item));
          }).toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }

  InputDecoration _getInputDecoration(String hintText, double hintSize) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(fontSize: hintSize),
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: _borderRadius,
        borderSide: BorderSide(color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: _borderRadius,
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: _borderRadius,
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: _borderRadius,
        borderSide: BorderSide(color: Colors.red),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }
}

enum ScreenSize { small, medium, large }

extension ScreenSizeExtension on ScreenSize {
  double get titleFontSize {
    switch (this) {
      case ScreenSize.small:
        return 12.0;
      case ScreenSize.medium:
        return 14.0;
      case ScreenSize.large:
        return 16.0;
    }
  }

  double get stepIndicatorSize {
    switch (this) {
      case ScreenSize.small:
        return 28.0;
      case ScreenSize.medium:
        return 32.0;
      case ScreenSize.large:
        return 36.0;
    }
  }
}

ScreenSize getScreenSize(double width) {
  if (width < 480) return ScreenSize.small;
  if (width < 768) return ScreenSize.medium;
  return ScreenSize.large;
}

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

ResponsiveSizes getResponsiveSizes(double width) {
  final bool isSmallScreen = width < 600;

  return ResponsiveSizes(
    headingSize:
        isSmallScreen
            ? 18.0
            : width < 900
            ? 20.0
            : 24.0,
    labelSize: isSmallScreen ? 14.0 : 16.0,
    hintSize: isSmallScreen ? 13.0 : 14.0,
    verticalSpacing: isSmallScreen ? 20.0 : 24.0,
    isSmallScreen: isSmallScreen,
  );
}

class ReviewField {
  final String label;
  final String value;

  ReviewField(this.label, this.value);
}
