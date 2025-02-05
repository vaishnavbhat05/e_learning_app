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

      print('Login response: $response');

      if (response['status'] == 0) {
        var userData = response['data'] ?? {};

        await _saveUserData(userData);

        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainPage()),
          );
        }
      } else {
        _showErrorDialog(context, response['message'] ?? 'Unknown error occurred');
      }
    } catch (e) {
      print('Login error: $e');
      _showErrorDialog(context, 'Login failed. Please try again.');
    } finally {
      _setLoading(false);
    }
  }


  Future<void> _saveUserData(Map<String, dynamic> userData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('userName', userData['userName'] ?? '');
    await prefs.setString('email', userData['email'] ?? '');
    await prefs.setString('accessToken', userData['accessToken'] ?? '');
    await prefs.setString('refreshToken', userData['refreshToken'] ?? '');
  }

  void _setLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

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
