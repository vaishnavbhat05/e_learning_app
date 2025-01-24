import 'package:e_learning_app/screens/subjects/provider/subject_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_learning_app/screens/profile/profile_screen.dart';
import 'package:e_learning_app/screens/profile/provider/profile_provider.dart';
import 'package:e_learning_app/screens/subjects/subject_screen.dart';
import 'home/home_screen.dart'; // Import the SubjectProvider

class MainPage extends StatefulWidget {
  final int? id;
  final int? index;
  MainPage({super.key, this.id, this.index});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;
  final screens = [
    const HomeScreen(),
    SubjectsScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    currentIndex = widget.index ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: Container(
        height: 80,
        decoration: const BoxDecoration(
          color: Colors.white,
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
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });

            if (index == 1) {
              // Trigger subject data fetch when HomeScreen is selected
              final subjectProvider = Provider.of<SubjectProvider>(context, listen: false);
              subjectProvider.fetchSubjects();
            }

            if (index == 2) {
              // Trigger profile data fetch when ProfileScreen is selected
              final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
              profileProvider.fetchProfile(widget.id ?? 0); // Assuming the user ID is passed
            }
          },
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          iconSize: 32,
          selectedIconTheme: const IconThemeData(size: 36),
          unselectedIconTheme: const IconThemeData(size: 28),
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined, size: 35), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.copy_rounded, size: 35), label: 'Course'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_2_outlined, size: 35), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
