import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import the package
import '../../../data/api/api_handler.dart'; // Import the API handler
import '../../../data/api/endpoints.dart'; // Import Endpoints class
import '../../../data/model/verification.dart'; // Import the Verification model
import '../../login/login_screen.dart'; // Import the login screen

class VerifyAccountProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Create an instance of ApiHandler
  final ApiHandler apiHandler = ApiHandler();

  Future<void> verifyAccount(String verificationCode, BuildContext context) async {
    _setLoading(true);

    // Retrieve user data from local storage
    final userData = await _getUserData();

    if (userData == null) {
      _showErrorDialog(context, 'No user data found');
      return;
    }

    final verifyAccountModel = VerifyAccount(
      userName: userData['userName']!,
      email: userData['email']!,
      password: userData['password']!,
      otp: verificationCode,
    );

    try {
      // Use the endpoint from the Endpoints class
      final response = await apiHandler.postRequest(
        Endpoints.verifyAccount(verificationCode), // Use the endpoint from the Endpoints class
        verifyAccountModel.toJson(),
      );

      if (response['status'] == 0) {
        // If successful, navigate to the login screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else {
        // If there's an error, show the error message from the API
        _showErrorDialog(context, response['message'] ?? 'Unknown error occurred');
      }
    } catch (e) {
      // Show a generic error message if the request fails
      _showErrorDialog(context, 'Verification failed. Please try again.');
    } finally {
      _setLoading(false);
    }
  }

  // Retrieve user data from shared preferences
  Future<Map<String, String>?> _getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userName = prefs.getString('userName');
    final email = prefs.getString('email');
    final password = prefs.getString('password');

    if (userName != null && email != null && password != null) {
      return {
        'userName': userName,
        'email': email,
        'password': password,
      };
    } else {
      return null;
    }
  }

  // Set loading state
  void _setLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  // Show error dialog
  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
