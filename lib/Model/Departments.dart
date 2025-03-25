class Department {
  final int departmentId;
  final String name;
  final String description;
  final String location;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String iconData;
  final String? headOfDept;
  final int? staffId;
  int staffCount; // Mutable since it changes

  Department({
    required this.departmentId,
    required this.name,
    required this.description,
    required this.location,
    required this.createdAt,
    required this.updatedAt,
    required this.iconData,
    required this.headOfDept,
    required this.staffId,
    required this.staffCount,
  });

  // Factory constructor to create an instance from JSON
  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      departmentId: json['department_id'],
      name: json['name'],
      description: json['description'],
      location: json['location'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      iconData: json['iconData'], 
      headOfDept: json['head_of_dept'],
      staffId: json['staff_id'],
      staffCount: json['staff_count'],
    );
  }

  // Convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'department_id': departmentId,
      'name': name,
      'description': description,
      'location': location,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'iconData': iconData,
      'head_of_dept': headOfDept,
      'staff_id': staffId,
      'staff_count': staffCount,
    };
  }
}
