import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/api/api_handler.dart';
import '../../../data/api/endpoints.dart';
import '../../../data/model/verification.dart';
import '../../login/login_screen.dart';

class VerifyAccountProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final ApiHandler apiHandler = ApiHandler();

  Future<void> verifyAccount(String verificationCode, BuildContext context) async {
    _setLoading(true);

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
      final response = await apiHandler.postRequest(
        Endpoints.verifyAccount(verificationCode),
        verifyAccountModel.toJson(),
      );

      if (response['status'] == 0) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else {
        _showErrorDialog(context, response['message'] ?? 'Unknown error occurred');
      }
    } catch (e) {
      _showErrorDialog(context, 'Verification failed. Please try again.');
    } finally {
      _setLoading(false);
    }
  }
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
