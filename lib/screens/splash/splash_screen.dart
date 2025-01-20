import 'dart:async';
import 'package:e_learning_app/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../onboards/on_board_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..forward();

    _checkOnboardingStatus();
  }

  _checkOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    bool isOnboarded = prefs.getBool('isOnboarded') ?? false;
    Future.delayed(const Duration(seconds: 3), () {
      if (isOnboarded) {
        // Navigate to HomeScreen if onboarding is already completed
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else {
        // Otherwise, navigate to Onboarding screen

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnBoardingScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blue,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                'assets/icons/book_open.svg',
                width: 120,
                height: 120,
              ),
              Text(
                "i-Learn",
                style: GoogleFonts.patrickHand(
                  fontSize: 40,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  letterSpacing: 5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
