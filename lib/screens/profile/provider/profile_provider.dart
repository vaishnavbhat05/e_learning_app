import 'dart:convert';
import 'dart:io';

import 'package:e_learning_app/data/api/endpoints.dart';
import 'package:flutter/material.dart';
import 'package:e_learning_app/data/api/api_handler.dart';
import 'package:e_learning_app/data/model/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
class ProfileProvider with ChangeNotifier {
  bool _isLoading = false;
  Profile? _profile;

  bool get isLoading => _isLoading;
  Profile? get profile => _profile;

  void clearProfile() {
    _profile = null;
    notifyListeners(); // Notify to rebuild the UI
  }

  final ApiHandler apiHandler = ApiHandler();


  //PROFILE DETAILS API//

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

  //EDIT PROFILE API//

  Future<void> updateProfile({ String? userName, File? profileImage}) async {
    _setLoading(true);
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      if (accessToken == null) {
        print('Access token is null, cannot update profile');
        return;
      }

      var uri = Uri.parse(Endpoints.edit);

      var request = http.MultipartRequest('PUT', uri);
      request.headers['Authorization'] = 'Bearer $accessToken';

      // Add username only if changed
      if (userName != null && userName.isNotEmpty) {
        request.fields['userName'] = userName;
      }

      if (profileImage != null) {
        request.files.add(await http.MultipartFile.fromPath('file', profileImage.path));
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);

        if (responseData['status'] == 0 && responseData['data'] != null) {
          _profile = Profile.fromJson(responseData['data']);
          notifyListeners();
        } else {
          print('Error updating profile: ${responseData['message']}');
        }
      } else {
        print('Failed to update profile: ${response.body}');
      }
    } catch (e) {
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

