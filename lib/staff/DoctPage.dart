import 'package:flutter/material.dart';
import 'package:frontend/Globals.dart';
import 'package:frontend/staff/AddStaff.dart';

class Doctor {
  final String name;
  final String specialty;
  final String id;
  final String email;
  final String phone;
  final String date;
  final String time;
  final bool isApproved;
  final String avatarAsset;

  Doctor({
    required this.name,
    required this.specialty,
    required this.id,
    required this.email,
    required this.phone,
    required this.date,
    required this.time,
    required this.isApproved,
    required this.avatarAsset,
  });
}

class DoctorsListPage extends StatefulWidget {
  const DoctorsListPage({Key? key}) : super(key: key);

  @override
  State<DoctorsListPage> createState() => _DoctorsListPageState();
}

class _DoctorsListPageState extends State<DoctorsListPage> {
  final List<Doctor> doctors = [
    Doctor(
      name: 'Brooklyn Simmons',
      specialty: 'Dermatologists',
      id: '87364523',
      email: 'brooklyns@mail.com',
      phone: '(603) 555-0123',
      date: '21/12/2022',
      time: '10:40 PM',
      isApproved: true,
      avatarAsset: 'assets/avatar1.png',
    ),
    Doctor(
      name: 'Kristin Watson',
      specialty: 'Infectious disease',
      id: '93874563',
      email: 'kristinw@mail.com',
      phone: '(219) 555-0114',
      date: '22/12/2022',
      time: '05:20 PM',
      isApproved: false,
      avatarAsset: 'assets/avatar2.png',
    ),
    Doctor(
      name: 'Jacob Jones',
      specialty: 'Ophthalmologists',
      id: '23847569',
      email: 'jacbj@mail.com',
      phone: '(319) 555-0115',
      date: '23/12/2022',
      time: '12:40 PM',
      isApproved: true,
      avatarAsset: 'assets/avatar3.png',
    ),
    Doctor(
      name: 'Cody Fisher',
      specialty: 'Cardiologists',
      id: '39485632',
      email: 'codyf@mail.com',
      phone: '(229) 555-0109',
      date: '24/12/2022',
      time: '03:00 PM',
      isApproved: true,
      avatarAsset: 'assets/avatar4.png',
    ),
    Doctor(
      name: 'Brooklyn Simmons',
      specialty: 'Dermatologists',
      id: '87364523',
      email: 'brooklyns@mail.com',
      phone: '(603) 555-0123',
      date: '21/12/2022',
      time: '10:40 PM',
      isApproved: true,
      avatarAsset: 'assets/avatar1.png',
    ),
    Doctor(
      name: 'Kristin Watson',
      specialty: 'Infectious disease',
      id: '93874563',
      email: 'kristinw@mail.com',
      phone: '(219) 555-0114',
      date: '22/12/2022',
      time: '05:20 PM',
      isApproved: false,
      avatarAsset: 'assets/avatar2.png',
    ),
    Doctor(
      name: 'Jacob Jones',
      specialty: 'Ophthalmologists',
      id: '23847569',
      email: 'jacbj@mail.com',
      phone: '(319) 555-0115',
      date: '23/12/2022',
      time: '12:40 PM',
      isApproved: true,
      avatarAsset: 'assets/avatar3.png',
    ),
    Doctor(
      name: 'Cody Fisher',
      specialty: 'Cardiologists',
      id: '39485632',
      email: 'codyf@mail.com',
      phone: '(229) 555-0109',
      date: '24/12/2022',
      time: '03:00 PM',
      isApproved: true,
      avatarAsset: 'assets/avatar4.png',
    ),
  ];

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
                                  child: Addstaff(),
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
                                child: Addstaff(),
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

          // Doctor list
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: doctors.length,
              itemBuilder: (context, index) {
                final doctor = doctors[index];
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
                      // Avatar placeholder
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.blue[100],
                        child: Text(
                          doctor.name.substring(0, 1),
                          style: const TextStyle(color: Colors.blue),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Name and specialty
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              doctor.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              doctor.specialty,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ID
                      Expanded(flex: isTablet ? 1 : 1, child: Text(doctor.id)),

                      // Email
                      Expanded(
                        flex: isTablet ? 2 : 2,
                        child: Text(doctor.email),
                      ),

                      // Phone - Hide on tablet for space
                      if (!isTablet)
                        Expanded(flex: 2, child: Text(doctor.phone)),

                      // Date and time
                      Expanded(
                        flex: isTablet ? 1 : 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(doctor.date),
                            Text(
                              doctor.time,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
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
                            color:
                                doctor.isApproved
                                    ? Colors.green[50]
                                    : Colors.red[50],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            doctor.isApproved ? 'Approved' : 'Declined',
                            style: TextStyle(
                              color:
                                  doctor.isApproved ? Colors.green : Colors.red,
                              fontSize: 12,
                            ),
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

  Widget _buildMobileList() {
    return Expanded(
      child: ListView.builder(
        itemCount: doctors.length,
        itemBuilder: (context, index) {
          final doctor = doctors[index];
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
                  // Handle doctor card tap
                },
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top section with avatar and basic info
                      Row(
                        children: [
                          // Avatar
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.blue[100],
                            child: Text(
                              doctor.name.substring(0, 1),
                              style: const TextStyle(color: Colors.blue),
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Name and specialty
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  doctor.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  doctor.specialty,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
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
                                  doctor.isApproved
                                      ? Colors.green[50]
                                      : Colors.red[50],
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              doctor.isApproved ? 'Approved' : 'Declined',
                              style: TextStyle(
                                color:
                                    doctor.isApproved
                                        ? Colors.green
                                        : Colors.red,
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

                      // Details grid
                      Column(
                        children: [
                          // ID
                          _buildInfoRow('ID', doctor.id),
                          const SizedBox(height: 8),

                          // Email
                          _buildInfoRow('Email', doctor.email),
                          const SizedBox(height: 8),

                          // Phone
                          _buildInfoRow('Phone', doctor.phone),
                          const SizedBox(height: 8),

                          // Date added
                          _buildInfoRow(
                            'Date',
                            '${doctor.date} - ${doctor.time}',
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
