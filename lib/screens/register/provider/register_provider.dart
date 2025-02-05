import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/model/register.dart';
import '../../../data/api/api_handler.dart';
import '../../../data/api/endpoints.dart';
import '../../verify_account/verify_account_screen.dart';

class RegisterProvider with ChangeNotifier {

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> registerUser(Register model, BuildContext context) async {
    _setLoading(true);

    ApiHandler apiHandler = ApiHandler();

    try {
      final response = await apiHandler.postRequest(
        Endpoints.sendRegOtp,
        {
          'userName': model.userName,
          'email': model.email,
          'password': model.password,
        },
      );

      print("API Response: $response");

      if (response['status'] == 0) {
        await _saveUserData(model);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => VerifyAccountScreen(
            password: model.password,
            userName: model.userName,
            email:model.email,
          ),),
        );
      } else {
        _showErrorDialog(context, response['message'] ?? 'Unknown error occurred');
      }
    } catch (e) {
      print("Error during registration: $e");
      _showErrorDialog(context, "An error occurred while registering. Please try again.");
    } finally {
      _setLoading(false);
    }
  }


  Future<void> _saveUserData(Register model) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', model.userName);
    await prefs.setString('email', model.email);
    await prefs.setString('password', model.password);
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
