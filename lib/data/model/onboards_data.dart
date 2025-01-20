import 'dart:core';

class OnBoards {
  final String title, image, text;

  OnBoards({required this.text, required this.image,required this.title});
}

List<OnBoards> onBoardData = [
  OnBoards(
    title: "Learn from Everywhere",
    text: "Learn anytime, anywhere.\nDiscover a world of knowledge at your fingertips.",
    image: "assets/images/image1.jpg",
  ),
  OnBoards(
    title: "User Friendly",
    text: "Explore a wide range of courses.\nEnhance your skills and achieve your goals.",
    image: "assets/images/image2.jpg",
  ),
  OnBoards(
    title: "Study Overview",
    text: "Interactive learning made easy.\nJoin us and master your favorite subjects.",
    image: "assets/images/image3.jpg",
  ),
];
