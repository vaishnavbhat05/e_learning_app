import 'package:e_learning_app/screens/chapters/provider/chapter_provider.dart';
import 'package:e_learning_app/screens/home/provider/home_provider.dart';
import 'package:e_learning_app/screens/login/login_screen.dart';
import 'package:e_learning_app/screens/login/provider/login_provider.dart';
import 'package:e_learning_app/screens/profile/provider/profile_provider.dart';
import 'package:e_learning_app/screens/profile/provider/result_details_provider.dart';
import 'package:e_learning_app/screens/subjects/provider/subject_provider.dart';
import 'package:e_learning_app/screens/tests/provider/test_screen_provider.dart';
import 'package:e_learning_app/screens/verify_account/provider/verify_account_provider.dart';
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
        ChangeNotifierProvider(create: (_) => SubjectProvider()),
        ChangeNotifierProvider(create: (_) => TestScreenProvider()),
        ChangeNotifierProvider(create: (_) => ResultProvider()),
        ChangeNotifierProvider(create: (_) => ChapterProvider()),
        ChangeNotifierProvider(create: (context) => HomeProvider()),
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
      home: const LoginScreen(),
      // home: MainPage(),
    );
  }
}
