import 'package:e_learning_app/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/data/model/onboards_data.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    _markOnboardingComplete();
  }

  _markOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isOnboarded', true);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[200],
          actions: currentPage < onBoardData.length - 1
              ? [
            GestureDetector(
              onTap: () {
                // Skip button logic
                _markOnboardingComplete(); // Mark onboarding as completed
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginScreen(),
                  ),
                      (route) => false, // Remove all routes until HomeScreen
                );
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 40),
                child: Text(
                  "Skip",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ]
              : null,
        ),
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 680,
              color: Colors.white,
              child: PageView.builder(
                itemCount: onBoardData.length,
                onPageChanged: (value) {
                  setState(() {
                    currentPage = value;
                  });
                },
                controller: _pageController,
                itemBuilder: (context, index) {
                  return onBoardingItems(size, index);
                },
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...List.generate(
                    onBoardData.length,
                        (index) => indicatorForSlider(index: index),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      if (currentPage == onBoardData.length - 1) // Show text only on the last page
                        const Padding(
                          padding: EdgeInsets.only(right: 16.0),
                          child: Text(
                            "Get Started",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      GestureDetector(
                        onTap: () {
                          if (currentPage == onBoardData.length - 1) {
                            _markOnboardingComplete(); // Mark onboarding as completed
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LoginScreen(),
                              ),
                                  (route) => false,
                            );
                          } else {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.ease,
                            );
                          }
                        },
                        child: Container(
                          height: 90,
                          width: 90,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.arrow_right_alt_outlined,
                              size: 60,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  AnimatedContainer indicatorForSlider({int? index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      width: currentPage == index ? 40 : 10,
      height: 10,
      margin: const EdgeInsets.only(right: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color:
        currentPage == index ? Colors.blue : Colors.black.withOpacity(0.2),
      ),
    );
  }
  Column onBoardingItems(Size size, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Image.asset(
          onBoardData[index].image,
          fit: BoxFit.cover, // Ensures the image fills its container
          width: double.infinity, // Ensures it spans the width of the screen
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 20), // Small spacing between image and text
              Text(
                onBoardData[index].title,
                style: const TextStyle(
                  fontSize: 28,
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                onBoardData[index].text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15.5,
                  color: Colors.black38,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

}
