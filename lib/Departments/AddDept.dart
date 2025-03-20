import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/Globals.dart';
import 'package:frontend/Model/DeptOnline.dart';
import 'package:frontend/Model/Staff.dart';
import 'package:frontend/creds.dart';
import 'package:frontend/requests/Comms.dart';
import 'package:intl/intl.dart';

class AddDepartment extends StatefulWidget {
  const AddDepartment({Key? key}) : super(key: key);

  @override
  State<AddDepartment> createState() => _AddDepartmentState();
}

class _AddDepartmentState extends State<AddDepartment> {
  int _currentStep = 0;
  // final List<String> _stepTitles = [
  //   'Basic Information',

  // ];

  // Controllers for form fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  // final TextEditingController _designationController = TextEditingController();
  // final TextEditingController _dateController = TextEditingController();

  String? _selectedDeptType;
  String? _selectedHeadOfDept;
  String _description = "";
  // String? _selectedGender;

  late Future<List<DepartmentOnline>> deps;
  late Future<List<StaffModel>> staff;

  Future<List<DepartmentOnline>> getDeps() async {
    final depts = await comms.getRequests(
      endpoint: "online/departments",
      isServer: true,
    );

    if (depts["success"]) {
      List data = depts["rsp"]["data"]["departments"];

      return data.map((dpt) => DepartmentOnline.fromJson(dpt)).toList();
    } else {
      print(depts["rsp"]);
      return []; // Return empty list if request fails
    }
  }

  Future<List<StaffModel>> getstaff() async {
    final depts = await comms.getRequests(endpoint: "api/staff");

    if (depts["success"]) {
      print(depts);
      List data = depts["rsp"]["data"];
      print("this is the value of depts $depts");
      return data.map((dpt) => StaffModel.fromJson(dpt)).toList();
    } else {
      print(depts["rsp"]);
      return []; // Return empty list if request fails
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    // getDeps();
    staff = getstaff();
    deps = getDeps();
    // TODO: implement initState
    super.initState();
  }

  // }

  @override
  Widget build(BuildContext context) {
    // Get screen size
    final screenSize = MediaQuery.of(context).size;

    // Determine container width based on screen size
    double containerWidth = screenSize.width;
    double containerHeight = screenSize.height;

    // For very large screens, cap the width
    if (screenSize.width > 1000) {
      containerWidth = screenSize.width * 0.5;
    } else if (screenSize.width > 900) {
      containerWidth = screenSize.width * 0.75;
    } else {
      containerWidth = screenSize.width * 0.9;
    }

    // Set container height based on screen size
    if (screenSize.height > 900) {
      containerHeight = screenSize.height * 0.45;
    } else {
      containerHeight = screenSize.height * 0.55;
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
            // SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            // _buildStepper(),
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
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                FutureBuilder(
                  future: deps,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text("Error: ${snapshot.error}");
                    }
                    return _buildDropdownField(
                      hintText: "Select Department",
                      value: _selectedDeptType,
                      onChanged: (value) {
                        setState(() {
                          _selectedDeptType = value;
                        });
                      },
                      items: snapshot.data as List<DepartmentOnline>,
                      hintSize: hintSize,
                    );
                  },
                ),

                Visibility(
                  visible: _description != "",
                  child: Container(
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
                              Icons.local_hospital,
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

                _buildFormField(
                  'Location',
                  _buildTextField(
                    controller: _nameController,
                    hintText: 'Department location within the facility',
                    hintSize: hintSize,
                    icon: Icons.location_on_outlined,
                  ),
                  width:
                      isMobileLayout
                          ? constraints.maxWidth
                          : (constraints.maxWidth - 16) / 2,
                  labelSize: labelSize,
                ),
                FutureBuilder(
                  future: staff,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text("Error: ${snapshot.error}");
                    }
                    return _buildDropdownFieldHeadOfDept(
                      hintText: "Select Head of Department",
                      value: _selectedHeadOfDept,
                      onChanged: (value) {
                        setState(() {
                          _selectedHeadOfDept = value;
                        });
                      },
                      items: snapshot.data!,
                      hintSize: hintSize,
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: verticalSpacing),
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
  }) {
    return TextField(
      controller: controller,
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
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        prefixIcon: Icon(icon, color: Colors.blue[700]),
        // Add subtle shadow
        isDense: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
      ),
      style: TextStyle(color: Colors.grey[800], fontSize: hintSize * 1.1),
    );
  }

  Widget _buildDropdownFieldHeadOfDept({
    required String hintText,
    required String? value,
    required Function(String?) onChanged,
    required List<StaffModel> items,
    required double hintSize,
    double? maxWidth,
  }) {
    // Create a state management controller for the search
    final TextEditingController searchController = TextEditingController();
    final ValueNotifier<List<StaffModel>> filteredItems =
        ValueNotifier<List<StaffModel>>(items);
    final ValueNotifier<bool> isSearching = ValueNotifier<bool>(false);

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return LayoutBuilder(
          builder: (context, constraints) {
            // Determine if we're on a small screen
            final isSmallScreen = constraints.maxWidth < 600;

            // Adjust sizes based on screen size
            final double iconSize = isSmallScreen ? 20 : 24;
            final double titleFontSize = isSmallScreen ? 14 : 16;
            final double descFontSize = isSmallScreen ? 10 : 12;
            final double horizontalPadding = isSmallScreen ? 8 : 12;
            final double verticalPadding = isSmallScreen ? 12 : 16;

            // Search function
            void performSearch(String query) {
              if (query.isEmpty) {
                filteredItems.value = items;
              } else {
                filteredItems.value =
                    items.where((staff) {
                      return staff.firstName.toLowerCase().contains(
                            query.toLowerCase(),
                          ) ||
                          staff.specialization.toLowerCase().contains(
                            query.toLowerCase(),
                          );
                    }).toList();
              }
            }

            return Container(
              constraints: BoxConstraints(
                maxWidth: maxWidth ?? double.infinity,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Custom dropdown with search
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        // Selected value or hint display with search icon
                        InkWell(
                          onTap: () {
                            setState(() {
                              isSearching.value = !isSearching.value;
                              if (!isSearching.value) {
                                searchController.clear();
                                filteredItems.value = items;
                              }
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding,
                              vertical: verticalPadding,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child:
                                      isSearching.value
                                          ? TextField(
                                            controller: searchController,
                                            decoration: InputDecoration(
                                              hintText: "Search Staff by First name...",
                                              border: InputBorder.none,
                                              isDense: true,
                                              contentPadding: EdgeInsets.zero,
                                            ),
                                            style: TextStyle(
                                              fontSize: titleFontSize,
                                            ),
                                            onChanged: performSearch,
                                            autofocus: true,
                                          )
                                          : Text(
                                            value ?? hintText,
                                            style: TextStyle(
                                              fontWeight:
                                                  value == null
                                                      ? FontWeight.w400
                                                      : FontWeight.w600,
                                              fontSize:
                                                  hintSize *
                                                  (isSmallScreen ? 0.9 : 1.0),
                                              color:
                                                  value == null
                                                      ? Colors.grey
                                                      : Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge
                                                          ?.color,
                                            ),
                                          ),
                                ),
                                Icon(
                                  isSearching.value
                                      ? Icons.close
                                      : Icons.search,
                                  color: Theme.of(context).primaryColor,
                                  size: iconSize,
                                ),
                                SizedBox(width: 8),
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Dropdown items
                        ValueListenableBuilder<bool>(
                          valueListenable: isSearching,
                          builder: (context, isSearchingValue, child) {
                            return isSearchingValue || value != null
                                ? ValueListenableBuilder<List<StaffModel>>(
                                  valueListenable: filteredItems,
                                  builder: (context, filteredItemsList, child) {
                                    return AnimatedContainer(
                                      duration: Duration(milliseconds: 200),
                                      height:
                                          isSearchingValue
                                              ? min(
                                                300,
                                                filteredItemsList.length * 60.0,
                                              )
                                              : 0,
                                      constraints: BoxConstraints(
                                        maxHeight:
                                            MediaQuery.of(context).size.height *
                                            0.4,
                                      ),
                                      child: ListView.builder(
                                        padding: EdgeInsets.zero,
                                        shrinkWrap: true,
                                        itemCount: filteredItemsList.length,
                                        itemBuilder: (context, index) {
                                          final dept = filteredItemsList[index];
                                          // Parse the icon from the string format

                                          return InkWell(
                                            onTap: () {
                                              onChanged(dept.firstName);
                                              setState(() {
                                                // _selectedDeptType = dept.name;
                                                // _description = dept.description;
                                                isSearching.value = false;
                                                searchController.clear();
                                              });
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  top: BorderSide(
                                                    color: Colors.grey.shade200,
                                                  ),
                                                ),
                                                color:
                                                    value == dept.firstName
                                                        ? Theme.of(context)
                                                            .primaryColor
                                                            .withOpacity(0.1)
                                                        : Colors.transparent,
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                horizontal: horizontalPadding,
                                                vertical: verticalPadding / 2,
                                              ),
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width: horizontalPadding,
                                                  ),
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
                                                                    "${dept.firstName} ${dept.lastName}",
                                                                    style: TextStyle(
                                                                      fontWeight: FontWeight.bold,
                                                                      fontSize: titleFontSize,
                                                                      color: Theme.of(context).primaryColor,
                                                                    ),
                                                                    overflow: TextOverflow.ellipsis,
                                                                  ),
                                                                  SizedBox(height: 2),
                                                                  Text(
                                                                    dept.role,
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
                                                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                              decoration: BoxDecoration(
                                                                color: Theme.of(context).primaryColor.withOpacity(0.1),
                                                                borderRadius: BorderRadius.circular(12),
                                                                border: Border.all(
                                                                  color: Theme.of(context).primaryColor.withOpacity(0.3),
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
                                                                  SizedBox(width: 4),
                                                                  Text(
                                                                    dept.specialization,
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
                                                        if (!isSmallScreen || constraints.maxWidth > 350)
                                                          Padding(
                                                            padding: EdgeInsets.only(top: 4),
                                                            child: Row(
                                                              children: [
                                                                Icon(
                                                                  Icons.badge,
                                                                  size: 12,
                                                                  color: Colors.grey[600],
                                                                ),
                                                                SizedBox(width: 4),
                                                                Text(
                                                                  "License: ${dept.licenseNumber}",
                                                                  style: TextStyle(
                                                                    fontSize: descFontSize,
                                                                    color: Colors.grey[600],
                                                                  ),
                                                                ),
                                                                SizedBox(width: 12),
                                                                Icon(
                                                                  Icons.email,
                                                                  size: 12,
                                                                  color: Colors.grey[600],
                                                                ),
                                                                SizedBox(width: 4),
                                                                Expanded(
                                                                  child: Text(
                                                                    dept.email,
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
                                                  if (value == dept.firstName)
                                                    Icon(
                                                      Icons.check,
                                                      color:
                                                          Theme.of(
                                                            context,
                                                          ).primaryColor,
                                                      size: iconSize,
                                                    ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                )
                                : SizedBox.shrink();
                          },
                        ),
                      ],
                    ),
                  ),
                  // Display "No results found" when search returns empty
                  ValueListenableBuilder<List<StaffModel>>(
                    valueListenable: filteredItems,
                    builder: (context, filteredItemsList, child) {
                      return ValueListenableBuilder<bool>(
                        valueListenable: isSearching,
                        builder: (context, isSearchingValue, child) {
                          if (isSearchingValue &&
                              filteredItemsList.isEmpty &&
                              searchController.text.isNotEmpty) {
                            return Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: Text(
                                "No Staff found matching '${searchController.text}'",
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: descFontSize,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            );
                          }
                          return SizedBox.shrink();
                        },
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDropdownField({
    required String hintText,
    required String? value,
    required Function(String?) onChanged,
    required List<DepartmentOnline> items,
    required double hintSize,
    double? maxWidth,
  }) {
    // Create a state management controller for the search
    final TextEditingController searchController = TextEditingController();
    final ValueNotifier<List<DepartmentOnline>> filteredItems =
        ValueNotifier<List<DepartmentOnline>>(items);
    final ValueNotifier<bool> isSearching = ValueNotifier<bool>(false);

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return LayoutBuilder(
          builder: (context, constraints) {
            // Determine if we're on a small screen
            final isSmallScreen = constraints.maxWidth < 600;

            // Adjust sizes based on screen size
            final double iconSize = isSmallScreen ? 20 : 24;
            final double titleFontSize = isSmallScreen ? 14 : 16;
            final double descFontSize = isSmallScreen ? 10 : 12;
            final double horizontalPadding = isSmallScreen ? 8 : 12;
            final double verticalPadding = isSmallScreen ? 12 : 16;

            // Search function
            void performSearch(String query) {
              if (query.isEmpty) {
                filteredItems.value = items;
              } else {
                filteredItems.value =
                    items.where((dept) {
                      return dept.name.toLowerCase().contains(
                            query.toLowerCase(),
                          ) ||
                          dept.description.toLowerCase().contains(
                            query.toLowerCase(),
                          );
                    }).toList();
              }
            }

            return Container(
              constraints: BoxConstraints(
                maxWidth: maxWidth ?? double.infinity,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Custom dropdown with search
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        // Selected value or hint display with search icon
                        InkWell(
                          onTap: () {
                            setState(() {
                              isSearching.value = !isSearching.value;
                              if (!isSearching.value) {
                                searchController.clear();
                                filteredItems.value = items;
                              }
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding,
                              vertical: verticalPadding,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child:
                                      isSearching.value
                                          ? TextField(
                                            controller: searchController,
                                            decoration: InputDecoration(
                                              hintText: "Search departments...",
                                              border: InputBorder.none,
                                              isDense: true,
                                              contentPadding: EdgeInsets.zero,
                                            ),
                                            style: TextStyle(
                                              fontSize: titleFontSize,
                                            ),
                                            onChanged: performSearch,
                                            autofocus: true,
                                          )
                                          : Text(
                                            value ?? hintText,
                                            style: TextStyle(
                                              fontWeight:
                                                  value == null
                                                      ? FontWeight.w400
                                                      : FontWeight.w600,
                                              fontSize:
                                                  hintSize *
                                                  (isSmallScreen ? 0.9 : 1.0),
                                              color:
                                                  value == null
                                                      ? Colors.grey
                                                      : Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge
                                                          ?.color,
                                            ),
                                          ),
                                ),
                                Icon(
                                  isSearching.value
                                      ? Icons.close
                                      : Icons.search,
                                  color: Theme.of(context).primaryColor,
                                  size: iconSize,
                                ),
                                SizedBox(width: 8),
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Dropdown items
                        ValueListenableBuilder<bool>(
                          valueListenable: isSearching,
                          builder: (context, isSearchingValue, child) {
                            return isSearchingValue || value != null
                                ? ValueListenableBuilder<
                                  List<DepartmentOnline>
                                >(
                                  valueListenable: filteredItems,
                                  builder: (context, filteredItemsList, child) {
                                    return AnimatedContainer(
                                      duration: Duration(milliseconds: 200),
                                      height:
                                          isSearchingValue
                                              ? min(
                                                300,
                                                filteredItemsList.length * 60.0,
                                              )
                                              : 0,
                                      constraints: BoxConstraints(
                                        maxHeight:
                                            MediaQuery.of(context).size.height *
                                            0.4,
                                      ),
                                      child: ListView.builder(
                                        padding: EdgeInsets.zero,
                                        shrinkWrap: true,
                                        itemCount: filteredItemsList.length,
                                        itemBuilder: (context, index) {
                                          final dept = filteredItemsList[index];
                                          // Parse the icon from the string format
                                          IconData iconData;
                                          try {
                                            // Assuming dept.iconName is in format "Icons.name"
                                            final iconName =
                                                dept.iconName.split('.').last;
                                            iconData = _getIconData(iconName);
                                          } catch (e) {
                                            iconData = Icons.local_hospital;
                                          }

                                          return InkWell(
                                            onTap: () {
                                              onChanged(dept.name);
                                              setState(() {
                                                _selectedDeptType = dept.name;
                                                _description = dept.description;
                                                isSearching.value = false;
                                                searchController.clear();
                                              });
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  top: BorderSide(
                                                    color: Colors.grey.shade200,
                                                  ),
                                                ),
                                                color:
                                                    value == dept.name
                                                        ? Theme.of(context)
                                                            .primaryColor
                                                            .withOpacity(0.1)
                                                        : Colors.transparent,
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                horizontal: horizontalPadding,
                                                vertical: verticalPadding / 2,
                                              ),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    iconData,
                                                    size: iconSize,
                                                    color:
                                                        Theme.of(
                                                          context,
                                                        ).primaryColor,
                                                  ),
                                                  SizedBox(
                                                    width: horizontalPadding,
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                          dept.name,
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize:
                                                                titleFontSize,
                                                            color:
                                                                Theme.of(
                                                                      context,
                                                                    )
                                                                    .textTheme
                                                                    .bodyLarge
                                                                    ?.color,
                                                          ),
                                                          overflow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                        ),
                                                        if (!isSmallScreen ||
                                                            constraints
                                                                    .maxWidth >
                                                                350)
                                                          Column(
                                                            children: [
                                                              SizedBox(
                                                                height: 2,
                                                              ),
                                                              Text(
                                                                dept.description,
                                                                style: TextStyle(
                                                                  fontSize:
                                                                      descFontSize,
                                                                  color:
                                                                      Colors
                                                                          .grey[600],
                                                                ),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines:
                                                                    isSmallScreen
                                                                        ? 1
                                                                        : 2,
                                                              ),
                                                            ],
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                                  if (value == dept.name)
                                                    Icon(
                                                      Icons.check,
                                                      color:
                                                          Theme.of(
                                                            context,
                                                          ).primaryColor,
                                                      size: iconSize,
                                                    ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                )
                                : SizedBox.shrink();
                          },
                        ),
                      ],
                    ),
                  ),
                  // Display "No results found" when search returns empty
                  ValueListenableBuilder<List<DepartmentOnline>>(
                    valueListenable: filteredItems,
                    builder: (context, filteredItemsList, child) {
                      return ValueListenableBuilder<bool>(
                        valueListenable: isSearching,
                        builder: (context, isSearchingValue, child) {
                          if (isSearchingValue &&
                              filteredItemsList.isEmpty &&
                              searchController.text.isNotEmpty) {
                            return Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: Text(
                                "No departments found matching '${searchController.text}'",
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: descFontSize,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            );
                          }
                          return SizedBox.shrink();
                        },
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Helper function to map icon names to IconData
  IconData _getIconData(String iconName) {
    // This is just a placeholder implementation
    // You should create a proper mapping between string names and IconData
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
        return Icons.local_hospital; // Default fallback
    }
  }

  // Usage example:
  // Place this in your build method
  //
  // _buildDropdownField(
  //   hintText: "Select Department",
  //   value: selectedDepartment,
  //   onChanged: (String? newValue) {
  //     setState(() {
  //       selectedDepartment = newValue;
  //     });
  //   },
  //   items: departments,
  //   hintSize: 16.0,
  // ),

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
