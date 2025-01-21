import 'package:e_learning_app/data/api/endpoints.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/api/api_handler.dart';
import '../../../data/model/login.dart';
import '../../main_page.dart';
class LoginProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final ApiHandler apiHandler = ApiHandler();

  Future<void> loginUser(Login model, BuildContext context) async {
    _setLoading(true);

    try {
      final response = await apiHandler.postRequest(Endpoints.login, {
        'email': model.email,
        'password': model.password,
      });

      // Log the full response to debug
      print('Login response: $response');

      // Check the response status
      if (response['status'] == 0) {
        // Handle missing or null values in response data
        var userData = response['data'] ?? {};

        // Save user data and token in local storage
        await _saveUserData(userData);

        // Ensure the context is correct and navigator is being called in the right place
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainPage()),
          );
        }
      } else {
        // Handle error response, show message
        _showErrorDialog(context, response['message'] ?? 'Unknown error occurred');
      }
    } catch (e) {
      // Handle error
      print('Login error: $e');
      _showErrorDialog(context, 'Login failed. Please try again.');
    } finally {
      _setLoading(false);
    }
  }


  // Save user data in local storage
  Future<void> _saveUserData(Map<String, dynamic> userData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('user_name', userData['name'] ?? '');
    await prefs.setString('user_email', userData['email'] ?? '');
    await prefs.setString('access_token', userData['access_token'] ?? '');
    await prefs.setString('refresh_token', userData['refresh_token'] ?? '');
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
