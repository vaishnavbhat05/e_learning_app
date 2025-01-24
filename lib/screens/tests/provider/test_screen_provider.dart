import 'dart:convert';
import 'package:e_learning_app/data/model/test_questions.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/api/api_handler.dart';
import '../../../data/api/endpoints.dart';

class TestScreenProvider extends ChangeNotifier {
  late TestQuestions testData; // Ensure TestModel is your model class
  bool isLoading = true;
  String errorMessage = '';

  Future<void> fetchTestData(int testId) async {
    isLoading = true;
    notifyListeners();

    final apiHandler = ApiHandler();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token'); // Use the correct key

    if (accessToken == null) {
      errorMessage = 'Access token is missing. Please log in again.';
      isLoading = false;
      notifyListeners();
      return;
    }

    try {
      final response = await apiHandler.getRequest(
        Endpoints.getTestsQuestions(testId),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      // Log the entire response to check for any errors
      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final data = json.decode(response.body);
          if (data['data'] != null) {
            testData = TestQuestions.fromJson(data['data']); // Ensure the response format matches the model
            isLoading = false;
            notifyListeners();
          } else {
            errorMessage = 'No data found in the response.';
            isLoading = false;
            notifyListeners();
          }
        } catch (e) {
          errorMessage = 'Error parsing data: $e';
          isLoading = false;
          notifyListeners();
        }
      } else {
        errorMessage = 'Error fetching data: ${response.statusCode} - ${response.reasonPhrase}';
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      errorMessage = 'Request failed: $e';
      isLoading = false;
      notifyListeners();
    }
  }

}
