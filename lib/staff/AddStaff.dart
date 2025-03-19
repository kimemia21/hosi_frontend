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
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width*0.6,
        height: MediaQuery.of(context).size.height*0.65,
        decoration: BoxDecoration(
          borderRadius: BorderRadiusDirectional.circular(20),
          color: Colors.grey.shade100,),
        
        child: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Responsive width based on screen size
              double formWidth =
                  constraints.maxWidth > 800
                      ? 800
                      : constraints.maxWidth * 0.6;
      
              return SizedBox(
                width: formWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    _buildStepper(),
                    const SizedBox(height: 40),
                    _buildCurrentStep(),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStepper() {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isSmallScreen = constraints.maxWidth < 600;

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
                          width: 30,
                          height: 30,
                          // decoration: BoxDecoration(
                          //   shape: BoxShape.circle,
                          //   color: isActive ? primaryColor : Colors.grey.shade300,
                          // ),
                          child: Center(
                            child: Text(
                              '${stepIndex + 1}',
                              style: TextStyle(
                                color: isActive ? primaryColor : Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        if (!isSmallScreen)
                          Text(
                            _stepTitles[stepIndex],
                            style: TextStyle(
                              fontSize: 12,
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
                          fontSize: 10,
                          fontWeight:
                              isActive ? FontWeight.bold : FontWeight.normal,
                          color: isActive ? primaryColor : Colors.grey,
                        ),
                        textAlign: TextAlign.center,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Basic information',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 32),
        LayoutBuilder(
          builder: (context, constraints) {
            bool isSmallScreen = constraints.maxWidth < 600;

            return Wrap(
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
                  ),
                  width:
                      isSmallScreen
                          ? constraints.maxWidth
                          : (constraints.maxWidth - 16) / 2,
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
                  ),
                  width:
                      isSmallScreen
                          ? constraints.maxWidth
                          : (constraints.maxWidth - 16) / 2,
                ),
                _buildFormField(
                  'First name',
                  _buildTextField(
                    controller: _firstNameController,
                    hintText: 'Your first name',
                  ),
                  width:
                      isSmallScreen
                          ? constraints.maxWidth
                          : (constraints.maxWidth - 16) / 2,
                ),
                _buildFormField(
                  'Designation',
                  _buildTextField(
                    controller: _designationController,
                    hintText: 'Your designation',
                  ),
                  width:
                      isSmallScreen
                          ? constraints.maxWidth
                          : (constraints.maxWidth - 16) / 2,
                ),
                _buildFormField(
                  'Last name',
                  _buildTextField(
                    controller: _lastNameController,
                    hintText: 'Your last name',
                  ),
                  width:
                      isSmallScreen
                          ? constraints.maxWidth
                          : (constraints.maxWidth - 16) / 2,
                ),
                _buildFormField(
                  'Date of birth',
                  _buildDateField(
                    controller: _dateController,
                    hintText: 'Select your date of birth',
                  ),
                  width:
                      isSmallScreen
                          ? constraints.maxWidth
                          : (constraints.maxWidth - 16) / 2,
                ),
                _buildFormField(
                  'Email address',
                  _buildTextField(
                    controller: _emailController,
                    hintText: 'Your email address',
                  ),
                  width:
                      isSmallScreen
                          ? constraints.maxWidth
                          : constraints.maxWidth,
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 40),

        Align(
          alignment: Alignment.centerRight,
          child: Container(
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadiusDirectional.circular(4),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: TextButton(
              onPressed: _nextStep,
              child: Text('NEXT STEP', style: TextStyle(color: Colors.white)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Enter Details',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 32),
        // Add form fields for details step
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(onPressed: _previousStep, child: const Text('PREVIOUS')),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadiusDirectional.circular(4),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: TextButton(
                  onPressed: _nextStep,
                  child: Text(
                    'NEXT STEP',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildServicesStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Services',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 32),
        // Add form fields for services step
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(onPressed: _previousStep, child: const Text('PREVIOUS')),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadiusDirectional.circular(4),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: TextButton(
                  onPressed: _nextStep,
                  child: Text(
                    'NEXT STEP',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReviewStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Review and Submit',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 32),
        // Add review summary
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(onPressed: _previousStep, child: const Text('PREVIOUS')),
            ElevatedButton(
              onPressed: () {
                // Submit form logic
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Text('SUBMIT'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFormField(String label, Widget field, {required double width}) {
    return Container(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
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
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 10,
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
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      hint: Text(
        hintText,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 10,
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
      items:
          items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
    );
  }

  Widget _buildDateField({
    required TextEditingController controller,
    required String hintText,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 10,
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
