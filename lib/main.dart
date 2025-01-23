import 'package:e_learning_app/screens/forgot_password/forgot_password_screen.dart';
import 'package:e_learning_app/screens/lessons/provider/lesson_test_provider.dart';
import 'package:e_learning_app/screens/login/login_screen.dart';
import 'package:e_learning_app/screens/login/provider/login_provider.dart';
import 'package:e_learning_app/screens/main_page.dart';
import 'package:e_learning_app/screens/profile/provider/profile_provider.dart';
import 'package:e_learning_app/screens/subjects/provider/subject_provider.dart';
import 'package:e_learning_app/screens/tests/provider/TimeProvider.dart';
import 'package:e_learning_app/screens/tests/result_screen.dart';
import 'package:e_learning_app/screens/verify_account/provider/verify_account_provider.dart';
import 'package:e_learning_app/services/push_notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/register/provider/register_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  // await PushNotificationService().initialize();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RegisterProvider()),
        ChangeNotifierProvider(create: (_) => VerifyAccountProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (context) => TimerProvider()),
        ChangeNotifierProvider(create: (_) => LessonTestProvider()),
        ChangeNotifierProvider(create: (_) => SubjectProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: const LoginScreen(),
      home: MainPage(),
    );
  }
}
