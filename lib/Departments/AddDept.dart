import 'dart:math';
import 'package:flutter/material.dart';
import 'package:frontend/CustomDropdown.dart';
import 'package:frontend/Globals.dart';
import 'package:frontend/Model/DeptOnline.dart';
import 'package:frontend/Model/Staff.dart';
import 'package:frontend/creds.dart';
import 'package:frontend/requests/Comms.dart';

class AddDepartment extends StatefulWidget {
  const AddDepartment({Key? key}) : super(key: key);

  @override
  State<AddDepartment> createState() => _AddDepartmentState();
}

class _AddDepartmentState extends State<AddDepartment> {
  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Loading state
  bool _isLoading = false;
  String? _errorMessage;
  bool _isSuccess = false;

  // Controllers for form fields
  final TextEditingController _locationController = TextEditingController();

  // Form data
  String? _selectedDeptType;
  String? _selectedHeadOfDept;
  String _description = "";
  String _iconData = "";
  int _selectedHeadId = 0;

  // Data caching
  List<DepartmentOnline>? _cachedDepartments;
  List<StaffModel>? _cachedStaff;

  // Memoized futures to prevent unnecessary API calls
  late Future<List<DepartmentOnline>> _departmentsFuture;
  late Future<List<StaffModel>> _staffFuture;

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _departmentsFuture = _fetchDepartments();
    _staffFuture = _fetchStaff();
  }

  // Optimized departments fetch with caching
  Future<List<DepartmentOnline>> _fetchDepartments() async {
    if (_cachedDepartments != null) {
      return _cachedDepartments!;
    }

    try {
      final depts = await comms.getRequests(
        endpoint: "online/departments",
        isServer: true,
      );

      if (depts["success"]) {
        List data = depts["rsp"]["data"]["departments"];
        _cachedDepartments =
            data.map((dpt) => DepartmentOnline.fromJson(dpt)).toList();
        return _cachedDepartments!;
      } else {
        debugPrint("Error fetching departments: ${depts["rsp"]}");
        return [];
      }
    } catch (e) {
      debugPrint("Exception fetching departments: $e");
      return [];
    }
  }

  // Optimized staff fetch with caching
  Future<List<StaffModel>> _fetchStaff() async {
    if (_cachedStaff != null) {
      return _cachedStaff!;
    }

    try {
      final staffData = await comms.getRequests(endpoint: "api/staff");

      if (staffData["success"]) {
        List data = staffData["rsp"]["data"];
        _cachedStaff = data.map((staff) => StaffModel.fromJson(staff)).toList();
        return _cachedStaff!;
      } else {
        debugPrint("Error fetching staff: ${staffData["rsp"]}");
        return [];
      }
    } catch (e) {
      debugPrint("Exception fetching staff: $e");
      return [];
    }
  }

  Future<void> _submitForm() async {
    // Reset states
    setState(() {
      _errorMessage = null;
      _isSuccess = false;
      _isLoading = true;
    });

    // Validate form first
    if (!_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Please complete all required fields correctly.";
      });
      return;
    }

    // Validate required fields
    if (_selectedDeptType == null || 
        _description.isEmpty || 
        _locationController.text.trim().isEmpty || 
        _selectedHeadOfDept == null || 
        _iconData.isEmpty || 
        _selectedHeadId == 0) {
      setState(() {
        _isLoading = false;
        _errorMessage = "All fields are required. Please complete the form.";
      });
      return;
    }

    try {
      final requestData = {
        "name": _selectedDeptType,
        "description": _description,
        "location": _locationController.text.trim(),
        "head_of_dept": _selectedHeadOfDept,
        "iconData": _iconData,
        "staff_id": _selectedHeadId,
      };

      final response = await comms.postRequest(
        endpoint: "api/departments",
        data: requestData,
      );

      if (response["success"]) {
        _handleSuccessfulSubmission();
      } else {
        _handleFailedSubmission(response["message"]);
      }
    } catch (e) {
      _handleError(e);
    }
  }

  void _handleSuccessfulSubmission() {
    setState(() {
      _isSuccess = true;
      _isLoading = false;
      _resetForm();
    });
  }

  void _handleFailedSubmission(String? message) {
    setState(() {
      _isLoading = false;
      _errorMessage = "Failed to create department: ${message ?? 'Unknown error'}";
    });
  }

  void _handleError(Object error) {
    setState(() {
      _isLoading = false;
      _errorMessage = "An error occurred: $error";
    });
    debugPrint("Error creating department: $error");
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _locationController.clear();
    setState(() {
      _selectedDeptType = null;
      _selectedHeadOfDept = null;
      _description = "";
      _iconData = "";
      _selectedHeadId = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    // Responsive sizing
    double containerWidth = screenSize.width;
    if (screenSize.width > 1000) {
      containerWidth = screenSize.width * 0.5;
    } else if (screenSize.width > 900) {
      containerWidth = screenSize.width * 0.75;
    } else {
      containerWidth = screenSize.width * 0.9;
    }

    double containerHeight =
        screenSize.height > 900
            ? screenSize.height * 0.45
            : screenSize.height * 0.55;

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
            child: Form(key: _formKey, child: _buildFormContent(context)),
          ),
        ),
      ),
    );
  }

  Widget _buildFormContent(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    double formWidth = screenWidth;

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
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
            _buildBasicInformationStep(),
          ],
        ),
      ),
    );
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
              'Department information',
              style: TextStyle(
                fontSize: headingSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: verticalSpacing),

            // Status messages
            if (_isSuccess)
              Container(
                padding: EdgeInsets.all(12),
                margin: EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Department created successfully!',
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                  ],
                ),
              ),

            if (_errorMessage != null)
              Container(
                padding: EdgeInsets.all(12),
                margin: EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error, color: Colors.red),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),

            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                // Department dropdown with validation
                FutureBuilder<List<DepartmentOnline>>(
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

                    return _buildFormField(
                      'Department Type',
                      _buildDepartmentDropdown(
                        hintText: "Select Department",
                        value: _selectedDeptType,
                        onChanged: (value) {
                          setState(() {
                            _selectedDeptType = value;
                          });
                        },
                        items: snapshot.data ?? [],
                        hintSize: hintSize,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a department';
                          }
                          return null;
                        },
                      ),
                      width: constraints.maxWidth,
                      labelSize: labelSize,
                    );
                  },
                ),

                // Description preview
                Visibility(
                  visible: _description.isNotEmpty,
                  child: Container(
                    width: constraints.maxWidth,
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
                                  ? _getIconData(_iconData.split('.').last)
                                  : Icons.local_hospital,
                              color: Colors.blue[700],
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              _selectedDeptType ?? "Department",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: hintSize * 1.2,
                                color: Colors.blue[700],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          _description,
                          style: TextStyle(
                            fontSize: hintSize,
                            color: Colors.grey[600],
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Location field with validation
                _buildFormField(
                  'Location',
                  _buildTextField(
                    controller: _locationController,
                    hintText: 'Department location within the facility',
                    hintSize: hintSize,
                    icon: Icons.location_on_outlined,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a location';
                      }
                      if (value.length < 3) {
                        return 'Location must be at least 3 characters';
                      }
                      return null;
                    },
                  ),
                  width:
                      isMobileLayout
                          ? constraints.maxWidth
                          : (constraints.maxWidth - 16) / 2,
                  labelSize: labelSize,
                ),

                // Head of department dropdown with validation
                FutureBuilder<List<StaffModel>>(
                  future: _staffFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox(
                        height: 56,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    if (snapshot.hasError) {
                      return Text("Error loading staff: ${snapshot.error}");
                    }

                    return _buildFormField(
                      'Head of Department',
                      _buildHeadOfDeptDropdown(
                        hintText: "Select Head of Department",
                        value: _selectedHeadOfDept,
                        onChanged: (value) {
                          setState(() {
                            _selectedHeadOfDept = value;
                          });
                        },
                        items: snapshot.data ?? [],
                        hintSize: hintSize,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a head of department';
                          }
                          return null;
                        },
                      ),
                      width:
                          isMobileLayout
                              ? constraints.maxWidth
                              : (constraints.maxWidth - 16) / 2,
                      labelSize: labelSize,
                    );
                  },
                ),
              ],
            ),

            SizedBox(height: verticalSpacing),

            // Submit button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  foregroundColor: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  shadowColor: Colors.blue.withOpacity(0.5),
                ),
                child:
                    _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.local_hospital, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Create Department',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
              ),
            ),
          ],
        );
      },
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
      margin: const EdgeInsets.only(bottom: 16),
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
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: hintSize,
          color: Colors.grey[600],
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.blue.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.blue.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.blue.shade400, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        prefixIcon: Icon(icon, color: Colors.blue[700]),
        isDense: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
      ),
      style: TextStyle(color: Colors.grey[800], fontSize: hintSize * 1.1),
    );
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

  Widget _buildHeadOfDeptDropdown({
    required String hintText,
    required String? value,
    required Function(String?) onChanged,
    required List<StaffModel> items,
    required double hintSize,
    String? Function(String?)? validator,
    double? maxWidth,
    }) {
    return CustomDropdown<StaffModel>(
      hintText: hintText,
      value: value,
      onChanged: (newValue, selectedItem) {
        if (selectedItem != null) {
          setState(() {
            _selectedHeadId = selectedItem.staffId;
          });
        }
        onChanged(newValue);
      },
      items: items,
      getLabel: (item) => "${item.firstName} ${item.lastName}",
      getSearchableTerms:
          (item) => [
            item.firstName,
            item.lastName,
            item.specialization,
            item.role,
          ],
      validator: validator,
      buildListItem: (
        BuildContext context,
        StaffModel staff,
        bool isSelected,
        bool isSmallScreen,
      ) {
        final titleFontSize = isSmallScreen ? 14.0 : 16.0;
        final descFontSize = isSmallScreen ? 10.0 : 12.0;

        return Row(
          children: [
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${staff.firstName} ${staff.lastName}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: titleFontSize,
                                color: Theme.of(context).primaryColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              staff.role,
                              style: TextStyle(
                                fontSize: descFontSize,
                                color: Colors.grey[600],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Theme.of(
                              context,
                            ).primaryColor.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.medical_services,
                              size: 12,
                              color: Theme.of(context).primaryColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              staff.specialization,
                              style: TextStyle(
                                fontSize: descFontSize,
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (!isSmallScreen || MediaQuery.of(context).size.width > 350)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        children: [
                          Icon(Icons.badge, size: 12, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            "License: ${staff.licenseNumber}",
                            style: TextStyle(
                              fontSize: descFontSize,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(Icons.email, size: 12, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              staff.email,
                              style: TextStyle(
                                fontSize: descFontSize,
                                color: Colors.grey[600],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
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

  // Helper function to map icon names to IconData
  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'local_hospital':
        return Icons.local_hospital;
      case 'medical_services':
        return Icons.medical_services;
      case 'healing':
        return Icons.healing;
      case 'child_care':
        return Icons.child_care;
      case 'pregnant_woman':
        return Icons.pregnant_woman;
      case 'favorite':
        return Icons.favorite;
      case 'psychology':
        return Icons.psychology;
      case 'accessibility':
        return Icons.accessibility;
      case 'face':
        return Icons.face;
      case 'visibility':
        return Icons.visibility;
      case 'hearing':
        return Icons.hearing;
      case 'water_drop':
        return Icons.water_drop;
      case 'mood':
        return Icons.mood;
      case 'biotech':
        return Icons.biotech;
      case 'radio':
        return Icons.radio;
      case 'bedtime':
        return Icons.bedtime;
      case 'fitness_center':
        return Icons.fitness_center;
      case 'medication':
        return Icons.medication;
      case 'science':
        return Icons.science;
      case 'restaurant_menu':
        return Icons.restaurant_menu;
      default:
        return Icons.local_hospital;
    }
  }
}
