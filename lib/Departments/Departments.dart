import 'package:flutter/material.dart';
import 'package:frontend/Departments/AddDept.dart';
import 'package:frontend/Globals.dart';
import 'package:frontend/Model/Departments.dart';
import 'package:frontend/creds.dart';
import 'package:frontend/utils/ReqGlobal.dart';

class DepartmentsListPage extends StatefulWidget {
  const DepartmentsListPage({Key? key}) : super(key: key);

  @override
  State<DepartmentsListPage> createState() => _DepartmentsListPageState();
}

class _DepartmentsListPageState extends State<DepartmentsListPage> {
  late Future<List<Department>> departments;

  int departmentCount = 0;

  @override
  void initState() {
    departments = fetchGlobal<Department>(
      getRequests: (endpoint) => comms.getRequests(endpoint: endpoint),
      fromJson: (json) => Department.fromJson(json),
      endpoint: "api/departments",
    );
    super.initState();
  }

  void onDeptAddedCallback() {
    setState(() {
      departments = fetchGlobal<Department>(
        getRequests: (endpoint) => comms.getRequests(endpoint: endpoint),
        fromJson: (json) => Department.fromJson(json),
        endpoint: "api/departments",
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width to determine layout
    final screenWidth = MediaQuery.of(context).size.width;

    // Determine if we're on mobile view
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top bar with view toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: Checkbox(
                            value: false,
                            onChanged: (value) {},
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Grid View',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: isMobile ? 16 : 24),

                FutureBuilder<List<Department>>(
                  future: departments,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final departmentsList = snapshot.data!;

                    return Expanded(
                      child: Column(
                        children: [
                          // Header with title and add button
                          isMobile
                              ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Hospital Departments',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${departmentsList.length} departments available',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        showAlerts(
                                          context,
                                          AddDepartment(
                                            onDeptAddedCallback: (p0) {
                                              if (p0) {
                                                onDeptAddedCallback();
                                              }
                                            },
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.add),
                                      label: const Text('Add new department'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFF6A9969,
                                        ),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                              : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Hospital Departments',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${departmentsList.length} departments available',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                    ],
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      showAlerts(
                                        context,
                                        AddDepartment(
                                          onDeptAddedCallback: (p0) {
                                            if (p0) {
                                              onDeptAddedCallback();
                                            }
                                          },
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.add),
                                    label: const Text('Add new department'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF6A9969),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                          SizedBox(height: isMobile ? 16 : 24),

                          // Search bar
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Search departments...',
                                border: InputBorder.none,
                                icon: Icon(Icons.search, color: Colors.grey),
                              ),
                            ),
                          ),
                          SizedBox(height: isMobile ? 16 : 24),

                          // List/Table view
                          isMobile
                              ? _buildMobileList(departments: departmentsList)
                              : _buildTableList(isTablet, departmentsList),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton:
          isMobile
              ? FloatingActionButton(
                onPressed: () {
                  // Show add department dialog
                  showAlerts(
                    context,
                    AddDepartment(
                      onDeptAddedCallback: (p0) {
                        if (p0) {
                          onDeptAddedCallback();
                        }
                      },
                    ),
                  );
                },
                backgroundColor: const Color(0xFF6A9969),
                child: Icon(Icons.add),
              )
              : null,
    );
  }

  Widget _buildTableList(bool isTablet, List<Department> departments) {
    return Expanded(
      child: Column(
        children: [
          // Table header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                SizedBox(width: 40), // Space for icon
                Expanded(
                  flex: 2,
                  child: Text(
                    'Department',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                ),
                Expanded(
                  flex: isTablet ? 1 : 1,
                  child: Text(
                    'ID',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                ),
                Expanded(
                  flex: isTablet ? 2 : 2,
                  child: Text(
                    'Head Doctor',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                ),
                if (!isTablet)
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Location',
                      style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                    ),
                  ),
                Expanded(
                  flex: isTablet ? 1 : 1,
                  child: Text(
                    'Staff',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'STATUS',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(width: 40), // Space for chevron
              ],
            ),
          ),

          // Department list
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: departments.length,
              itemBuilder: (context, index) {
                final department = departments[index];
                return Container(
                  margin: const EdgeInsets.only(top: 1),
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Department icon
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          _getDepartmentIcon(department.name),
                          color: Colors.blue[700],
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Name and description
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              department.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              department.description,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),

                      // ID
                      Expanded(
                        flex: isTablet ? 1 : 1,
                        child: Text(department.departmentId.toString()),
                      ),

                      // Head Doctor
                      Expanded(
                        flex: isTablet ? 2 : 2,
                        child: Text(department.headOfDept??"null"),
                      ),

                      // Location - Hide on tablet for space
                      if (!isTablet)
                        Expanded(flex: 2, child: Text(department.location)),

                      // Staff count
                      Expanded(
                        flex: isTablet ? 1 : 1,
                        child: Text(
                          department.staffCount.toString(),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      // Status
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            'Inactive',
                            style: TextStyle(color: Colors.red, fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),

                      // Chevron
                      Icon(Icons.chevron_right, color: Colors.grey[400]),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileList({required List<Department> departments}) {
    return Expanded(
      child: ListView.builder(
        itemCount: departments.length,
        itemBuilder: (context, index) {
          final department = departments[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  // Handle department card tap
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    builder:
                        (context) => _buildDepartmentDetailsSheet(department),
                  );
                },
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top section with icon and basic info
                      Row(
                        children: [
                          // Department icon
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.blue[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              _getDepartmentIcon(department.name),
                              color: Colors.blue[700],
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Name and description
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  department.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  department.description,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),

                          // Status badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  // department.isActive
                                  Colors.green[50],
                              // : Colors.red[50],
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              'Active',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                      const Divider(height: 1),
                      const SizedBox(height: 16),

                      // Quick info section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // ID
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Department ID',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                department.departmentId.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),

                          // Staff count
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Staff Count',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                department.staffCount.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),

                          // Established
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Established',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                department.createdAt.toIso8601String(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Head Doctor
                      Row(
                        children: [
                          Icon(Icons.person, color: Colors.blue[700], size: 16),
                          const SizedBox(width: 8),
                          Text(
                            department.headOfDept??"not Avaiable",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Location
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.blue[700],
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            department.location,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDepartmentDetailsSheet(Department department) {
    return Container(
      padding: EdgeInsets.all(24),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getDepartmentIcon(department.name),
                  color: Colors.blue[700],
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      department.name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 4),
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color:
                            // department.isActive
                            Colors.green[50],
                        // : Colors.red[50],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        // department.isActive ? 'Active' :
                        'Inactive',
                        style: TextStyle(
                          color:
                              // department.isActive ?
                              Colors.green,
                          //  : Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Description
          Text(
            'Description',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(department.description, style: TextStyle(fontSize: 14)),
          const SizedBox(height: 24),

          // Details
          Text(
            'Department Details',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // ID
          _buildDetailItem('Department ID', department.departmentId.toString()),
          _buildDetailItem('Head Doctor', department.headOfDept??"not Available"),
          _buildDetailItem('Location', department.location),
          // _buildDetailItem('Contact Number', department.con),
          _buildDetailItem(
            'Established',
            department.createdAt.toIso8601String(),
          ),
          _buildDetailItem('Total Staff', department.staffCount.toString()),

          const SizedBox(height: 24),

          // Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.edit),
                label: Text('Edit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.people),
                label: Text('View Staff'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.calendar_today),
                label: Text('Schedule'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  // Helper method to get appropriate icon for department
  IconData _getDepartmentIcon(String departmentName) {
    switch (departmentName.toLowerCase()) {
      case 'cardiology':
        return Icons.favorite;
      case 'dermatology':
        return Icons.face;
      case 'ophthalmology':
        return Icons.remove_red_eye;
      case 'neurology':
        return Icons.psychology;
      case 'pediatrics':
        return Icons.child_care;
      case 'orthopedics':
        return Icons.accessibility_new;
      case 'psychiatry':
        return Icons.self_improvement;
      case 'radiology':
        return Icons.photo_camera;
      default:
        return Icons.local_hospital;
    }
  }
}
