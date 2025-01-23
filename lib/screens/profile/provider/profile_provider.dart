import 'package:e_learning_app/data/api/endpoints.dart';
import 'package:flutter/material.dart';
import 'package:e_learning_app/data/api/api_handler.dart';
import 'package:e_learning_app/data/model/profile.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import this for token storage
class ProfileProvider with ChangeNotifier {
  bool _isLoading = false;
  Profile? _profile;

  bool get isLoading => _isLoading;
  Profile? get profile => _profile;


  final ApiHandler apiHandler = ApiHandler();

  Future<void> fetchProfile(int userId) async {
    _setLoading(true);
    try {
      // Get the access token from SharedPreferences (or any storage method)
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken'); // Assuming 'accessToken' key

      if (accessToken == null) {
        print('Access token is null, cannot fetch profile');
        return;
      }

      // Set the Authorization header with the token
      final response = await apiHandler.getRequest(
        Endpoints.profile,
        headers: {
          'Authorization': 'Bearer $accessToken', // Add Authorization header
        },
      );

      // Check if response is valid and contains 'data'
      if (response != null && response['status'] == 0 && response['data'] != null) {
        _profile = Profile.fromJson(response['data']);
        notifyListeners();
      } else {
        // Handle API error (if any)
        print('Error fetching profile or response is null');
      }
    } catch (e) {
      // Handle error
      print('Error: $e');
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

}

