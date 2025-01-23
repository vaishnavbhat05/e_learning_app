import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/api/api_handler.dart'; // Import the ApiHandler class
import '../../../data/api/endpoints.dart';
import '../../../data/model/test.dart'; // Make sure your TestModel class is properly defined

class LessonTestProvider extends ChangeNotifier {
  List<TestModel> _tests = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<TestModel> get tests => _tests;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchTests(int lessonId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final apiHandler = ApiHandler();

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      if (accessToken == null) {
        _errorMessage = 'Access token is missing. Please log in again.';
        _isLoading = false;
        notifyListeners();
        return;
      }


      final responseBody = await apiHandler.getRequest(
        Endpoints.getTestsForLesson(lessonId),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (responseBody != null && responseBody['status'] == 0) {
        List<dynamic> testList = responseBody['data'];

        _tests = testList.map((test) => TestModel.fromJson(test)).toList();
      } else {
        _errorMessage = responseBody['message'] ?? 'Failed to load tests. Please try again.';
      }
    } catch (error) {
      _errorMessage = 'Error: $error';
    }

    _isLoading = false;
    notifyListeners();
  }
}
