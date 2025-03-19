
import 'package:flutter/material.dart';
import 'package:frontend/staff/HmStaff.dart';

class AppNavBar extends StatefulWidget {
  const AppNavBar({super.key});

  @override
  State<AppNavBar> createState() => _AppNavBarState();
}

class _AppNavBarState extends State<AppNavBar> {
  int _selectedIndex = 0;

  Color primaryColor = Color(0xFF2E5F30);
  final List<String> _menuItems = [
    'Staff',
    'Patients',
    'Hospitals',
    'Notice',
    'Help Center',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      color: Colors.grey.shade600,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
              Container(
                decoration: BoxDecoration(
                borderRadius: BorderRadiusDirectional.only(
                  topStart: Radius.circular(20),
                  topEnd: Radius.circular(20),
                ),
                color: const Color(0xFF2E5F30),
                ),
                height: 70,
                child: Row(
                children: [
                  Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 600;

                    if (isWide) {
                      return Row(
                      children: [
                        Image.asset(
                        "images/red-heart-icon.png",
                        fit: BoxFit.contain,
                        height: 30,
                        width: 40,
                        ),
                        const SizedBox(width: 8), // Reduced spacing
                        for (int i = 0; i < _menuItems.length; i++)
                        Container(
                          height: 40, // Reduced height
                          margin: EdgeInsets.symmetric(
                          horizontal: 4, // Reduced horizontal margin
                          vertical: 8,
                          ),
                          decoration: BoxDecoration(
                          borderRadius: BorderRadiusDirectional.circular(5),
                          color: _selectedIndex == i ? Colors.white : primaryColor,
                          ),
                          child: TextButton(
                          onPressed: () {
                            setState(() {
                            _selectedIndex = i;
                            });
                          },
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 8)), // Reduced padding
                            foregroundColor: MaterialStateProperty.resolveWith(
                            (states) => _selectedIndex == i ? Colors.white : primaryColor,
                            ),
                          ),
                          child: Text(
                            _menuItems[i],
                            style: TextStyle(
                            color: _selectedIndex == i ? primaryColor : Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold
                            ),
                          ),
                          ),
                        ),
                      ],
                      );
                    } else {
                      // Mobile view code remains the same
                      return Row(
                      children: [
                        const SizedBox(width: 16),
                        PopupMenuButton<int>(
                        icon: const Icon(
                          Icons.menu,
                          color: Colors.white,
                        ),
                        onSelected: (int index) {
                          setState(() {
                          _selectedIndex = index;
                          });
                        },
                        itemBuilder: (context) {
                          return _menuItems.asMap().entries.map((entry) {
                          return PopupMenuItem<int>(
                            value: entry.key,
                            child: Text(entry.value),
                          );
                          }).toList();
                        },
                        ),
                        const SizedBox(width: 8),
                        Text(
                        _menuItems[_selectedIndex],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        ),
                     
                      ],
                      );
                    }
                    },
                  ),
                  ),
                  Container(
                  margin: const EdgeInsets.only(right: 16),
                  child: Row(
                    children: [
                    IconButton(
                      icon: const Icon(Icons.search, color: Colors.white),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(
                      Icons.notifications_outlined,
                      color: Colors.white,
                      ),
                      onPressed: () {},
                    ),
                    const CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.white,
                      child: Text('M'),
                    ),
                    ],
                  ),
                  ),
                ],
                ),
              ),
              StaffNavBar(),
              ],
        ),
      ),
    );
  }
}
