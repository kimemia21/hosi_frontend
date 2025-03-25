import 'package:flutter/material.dart';
import 'package:frontend/Globals.dart';
import 'package:frontend/Model/Staff.dart';
import 'package:frontend/creds.dart';
import 'package:frontend/staff/AddStaff.dart';
import 'package:frontend/utils/ReqGlobal.dart';

class StaffPage extends StatefulWidget {
  const StaffPage({Key? key}) : super(key: key);

  @override
  State<StaffPage> createState() => _StaffPageState();
}

class _StaffPageState extends State<StaffPage> {
  late Future<List<StaffModel>> staff;

  @override
  void initState() {
    super.initState();
    staff = fetchGlobal<StaffModel>(
      getRequests: (endpoint) => comms.getRequests(endpoint: endpoint),
      fromJson: (json) => StaffModel.fromJson(json),
      endpoint: "api/staff",
    );
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
                // Top bar with cover checkbox
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
                          'Cover',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: isMobile ? 16 : 24),

                // Header with title and add button
                isMobile
                    ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title and count
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'List of doctors',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '345 available doctors',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Add button - full width on mobile
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              showAlerts(
                                context,
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadiusDirectional.circular(20),
                                  ),
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  height:
                                      MediaQuery.of(context).size.height * 0.75,
                                  child: Addstaff(
                                    callback: (p0) {
                                      if (p0) {
                                        setState(() {
                                          staff = fetchGlobal<StaffModel>(
                                            getRequests:
                                                (endpoint) => comms.getRequests(
                                                  endpoint: endpoint,
                                                ),
                                            fromJson:
                                                (json) =>
                                                    StaffModel.fromJson(json),
                                            endpoint: "api/staff",
                                          );
                                        });
                                      }
                                    },
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('Add new staff'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6A9969),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'List of Staff',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '345 available doctors',
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
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadiusDirectional.circular(20),
                                ),

                                width: MediaQuery.of(context).size.width * 0.6,
                                height:
                                    MediaQuery.of(context).size.height * 0.75,
                                child: Addstaff(
                                  callback: (p0) {
                                    if (p0) {
                                      setState(() {
                                        staff = fetchGlobal<StaffModel>(
                                          getRequests:
                                              (endpoint) => comms.getRequests(
                                                endpoint: endpoint,
                                              ),
                                          fromJson:
                                              (json) =>
                                                  StaffModel.fromJson(json),
                                          endpoint: "api/staff",
                                        );
                                      });
                                    }
                                  },
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Add new Staff'),
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

                // For mobile: Implement a card-based layout
                // For tablet/desktop: Keep the table layout
                isMobile ? _buildMobileList() : _buildTableList(isTablet),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTableList(bool isTablet) {
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
                SizedBox(width: 40), // Space for avatar
                Expanded(
                  flex: 2,
                  child: Text(
                    'Name',
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
                    'Email',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                ),
                if (!isTablet)
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Phone number',
                      style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                    ),
                  ),
                Expanded(
                  flex: isTablet ? 1 : 2,
                  child: Text(
                    'Date added',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'STATUS',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                ),
                SizedBox(width: 40), // Space for chevron
              ],
            ),
          ),

          // Doctor list with FutureBuilder
          Expanded(
            child: FutureBuilder<List<StaffModel>>(
              future: staff,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No staff members found'));
                }

                final staffList = snapshot.data!;
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: staffList.length,
                  itemBuilder: (context, index) {
                    final staff = staffList[index];
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
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.blue[100],
                            child: Text(
                              staff.firstName.substring(0, 1),
                              style: const TextStyle(color: Colors.blue),
                            ),
                          ),
                          const SizedBox(width: 12),

                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  staff.staffId.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  staff.specialization,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Expanded(
                            flex: isTablet ? 1 : 1,
                            child: Text(staff.staffId.toString()),
                          ),
                          Expanded(
                            flex: isTablet ? 2 : 2,
                            child: Text(staff.email),
                          ),

                          if (!isTablet)
                            Expanded(flex: 2, child: Text(staff.phone)),

                          Expanded(
                            flex: isTablet ? 1 : 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(staff.createdAt.toString()),
                                Text(
                                  staff.createdAt.toString(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Expanded(
                            flex: 1,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green[50],
                                // : Colors.red[50],
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                // staff.isApproved ?
                                'Approved',
                                //  : 'Declined',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),

                          Icon(Icons.chevron_right, color: Colors.grey[400]),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileList() {
    return Expanded(
      child: FutureBuilder<List<StaffModel>>(
        future: staff,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No staff members found'));
          }

          final staffList = snapshot.data!;
          return ListView.builder(
            itemCount: staffList.length,
            itemBuilder: (context, index) {
              final staff = staffList[index];
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
                      // Handle staff card tap
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: Colors.blue[100],
                                child: Text(
                                  staff.firstName.substring(0, 1),
                                  style: const TextStyle(color: Colors.blue),
                                ),
                              ),
                              const SizedBox(width: 12),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${staff.firstName} ${staff.lastName}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      staff.specialization,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green[50],
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Text(
                                  'Active',
                                  style: TextStyle(
                                    color: Colors.green,
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

                          Column(
                            children: [
                              _buildInfoRow('ID', staff.staffId.toString()),
                              const SizedBox(height: 8),
                              _buildInfoRow('Email', staff.email),
                              const SizedBox(height: 8),
                              _buildInfoRow('Phone', staff.phone),
                              const SizedBox(height: 8),
                              _buildInfoRow(
                                'Date Added',
                                staff.createdAt.toString().split(' ')[0],
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
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
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
    );
  }
}
