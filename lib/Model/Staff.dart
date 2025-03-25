class StaffModel {
  final int staffId;
  final String firstName;
  final String lastName;
  final String role;
  final int departmentId;
  final String specialization;
  final String? licenseNumber;  // Made nullable
  final String phone;
  final String email;
  final DateTime hireDate;
  final DateTime updatedAt;
  final DateTime createdAt;
  final int idNumber;  // Added field
  final String? gender;  // Added nullable field

  StaffModel({
    required this.staffId,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.departmentId,
    required this.specialization,
    this.licenseNumber,  // Made optional
    required this.phone,
    required this.email,
    required this.hireDate,
    required this.createdAt,
    required this.updatedAt,
    required this.idNumber,
    this.gender,
  });

  factory StaffModel.fromJson(Map<String, dynamic> json) {
    return StaffModel(
      staffId: json['staff_id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      role: json['role'],
      departmentId: json['department_id'],
      specialization: json['specialization'],
      licenseNumber: json['license_number'],
      phone: json['phone'],
      email: json['email'],
      hireDate: DateTime.parse(json['hire_date']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      idNumber: json['id_number'],
      gender: json['gender'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'staff_id': staffId,
      'first_name': firstName,
      'last_name': lastName,
      'role': role,
      'department_id': departmentId,
      'specialization': specialization,
      'license_number': licenseNumber,
      'phone': phone,
      'email': email,
      'hire_date': hireDate.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'id_number': idNumber,
      'gender': gender,
    };
  }
}
