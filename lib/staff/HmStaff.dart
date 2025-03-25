import 'package:flutter/material.dart';
import 'package:frontend/staff/StaffPage.dart';

class StaffNavBar extends StatefulWidget {
  const StaffNavBar({super.key});

  @override
  State<StaffNavBar> createState() => _StaffNavBarState();
}

class _StaffNavBarState extends State<StaffNavBar> {
  int _selectedIndex = 0;
  final List<String> _menuItems = ['Doctor', 'Administration', 'Accounts'];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsetsDirectional.all(10),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children:
                  _menuItems.asMap().entries.map((entry) {
                    int idx = entry.key;
                    String title = entry.value;
                    bool isSelected = _selectedIndex == idx;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIndex = idx;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 14,
                        ),
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? Colors.green.shade50
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color:
                                isSelected
                                    ? Colors.green.shade800
                                    : Colors.grey.shade400,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
            Expanded(child: StaffPage()),
          ],
        ),
      ),
    );
  }
}
