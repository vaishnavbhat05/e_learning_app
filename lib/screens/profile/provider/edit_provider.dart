import 'dart:convert';
import 'dart:io';
import 'package:e_learning_app/data/api/endpoints.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/api/api_handler.dart';
import '../../../data/model/profile.dart';

class EditProvider with ChangeNotifier {
  bool _isLoading = false;
  Profile? _profile;

  bool get isLoading => _isLoading;
  Profile? get profile => _profile;

  final ApiHandler apiHandler = ApiHandler();

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

      // Add image only if provided
      if (profileImage != null) {
        request.files.add(await http.MultipartFile.fromPath('profileImageUrl', profileImage.path));
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        print(responseData);

        if (responseData['status'] == 0 && responseData['data'] != null) {
          _profile = Profile.fromJson(responseData['data']);
          notifyListeners();
        } else {
          print('Error updating profile: ${responseData['message']}');
        }
      } else {
        print('Failed to update profile: ${response.reasonPhrase}');
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
