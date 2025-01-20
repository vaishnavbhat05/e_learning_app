import 'package:e_learning_app/screens/profile/profile_screen.dart';
import 'package:e_learning_app/screens/subjects/subject_screen.dart';
import 'package:flutter/material.dart';
import 'home/home_screen.dart';

class MainPage extends StatefulWidget {
  int? id;
  int? index;
  MainPage({super.key, this.id, this.index});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;
  final screens = [
    const HomeScreen(),
    SubjectsScreen(),
    const ProfileScreen()
  ];

  @override
  void initState() {
    currentIndex = widget.index ?? 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: Container(
        height: 80, // Adjust the height of the BottomNavigationBar
        decoration: const BoxDecoration(
          color: Colors.white, // Background color of the bar
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          onTap: (index) => setState(() => currentIndex = index),
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: false, // Hide labels for selected items
          showUnselectedLabels: false, // Hide labels for unselected items
          iconSize: 32, // Increase the size of icons
          selectedIconTheme:
              const IconThemeData(size: 36), // Further customize selected icons
          unselectedIconTheme:
              const IconThemeData(size: 28), // Customize unselected icons
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined,size: 35,), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.menu_book_outlined,size: 35,), label: 'Course'),
            BottomNavigationBarItem(icon: Icon(Icons.person_2_outlined,size: 35,), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
