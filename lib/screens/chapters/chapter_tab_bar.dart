import 'package:flutter/material.dart';

class ChapterTabBar extends StatefulWidget {
  const ChapterTabBar({super.key});

  @override
  _ChapterTabBarState createState() => _ChapterTabBarState();
}

class _ChapterTabBarState extends State<ChapterTabBar> {
  int _selectedIndex = 0; // To keep track of the selected tab

  Widget _buildTab(String label, int index) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index; // Update selected tab
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12), // Adjust padding for tab size
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center, // Center the text inside the tab
            children: [
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.blue : Colors.grey.shade500, // Blue text for selected tab
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 50,
        width: 400, // Ensure it takes full width or adjust as needed
        decoration: BoxDecoration(
          color: Colors.white, // Background color for the container
          borderRadius: BorderRadius.circular(30), // Rounded corners for the whole container
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, // Center the tabs horizontally
          children: [
            _buildTab('ALL', 0),
            const VerticalDivider(
              color: Colors.grey, // Divider color
              width: 60, // Width of the divider
              thickness: 0.3, // Divider thickness
            ),
            _buildTab('STUDYING', 1),
            const VerticalDivider(
              color: Colors.grey, // Divider color
              width: 60, // Width of the divider
              thickness: 0.5, // Divider thickness
            ),
            _buildTab('LIKED', 2),
          ],
        ),
      ),
    );
  }
}
