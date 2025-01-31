import 'package:e_learning_app/data/model/test_questions.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/api/api_handler.dart';
import '../../../data/api/endpoints.dart';
import '../../../data/model/test_result.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class TestScreenProvider extends ChangeNotifier {
  TestResult? testResult;
  TestQuestions? testData;
  bool isLoading = true;
  String errorMessage = '';

  List<String> questionStatements = [];
  List<List<String>> optionsList = [];
  List<String> questionImages = [];

  final ApiHandler apiHandler = ApiHandler();


  //SUBMIT ANSWER API//

  Future<void> submitAnswer(int selectedOption, int questionId, int testId) async {
    isLoading = true;
    notifyListeners();

    // Get the access token from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');

    if (accessToken == null) {
      print('Access token is null, cannot submit test');
      isLoading = false;
      notifyListeners();
      return;
    }


    print('Request payload: {"selectedOption": $selectedOption}');

    final url = Uri.parse('http://16.170.246.37:8080/api/v1/questions/$questionId/test/$testId');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'selectedOption': selectedOption,
        }),
      );

      // Check if the response is successful
      if (response.statusCode == 200) {
        print('Test submitted successfully');
        // Handle success response here, for example, parse the response body
        var responseData = json.decode(response.body);
        print('Response: $responseData');
      } else {
        print('Failed to submit answer. Status code: ${response.statusCode}');
        // Handle error response here
        var errorResponse = json.decode(response.body);
        print('Error response: $errorResponse');
      }
    } catch (e) {
      print('Error during POST request: $e');
      // Handle any errors that might occur during the request
    }

    isLoading = false;
    notifyListeners();
  }



  // SUBMIT TEST API//


  Future<void> submitTest(int testId, bool isTimeout) async {
    final accessToken = await _getAccessToken();
    if (accessToken == null) {
      errorMessage = 'Access token is missing. Please log in again.';
      notifyListeners();
      return;
    }

    final String apiUrl = '/tests/$testId/submit?isTimeout=$isTimeout';

    isLoading = true;
    notifyListeners();

    try {
      final response = await ApiHandler().postRequest(
        apiUrl,
        {},
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      print(response);
      if (response['status'] == 0) {
        testResult = TestResult.fromJson(response['data']);
      } else {
        errorMessage = 'Failed to fetch test result. Status code: ${response['statusCode']}';
      }
    } catch (e) {
      errorMessage = 'An error occurred while fetching the test result: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }


  // ALL TESTS API //


  Future<void> fetchTestData(int testId) async {
    _setLoading(true);
    notifyListeners();

    final accessToken = await _getAccessToken();
    if (accessToken == null) {
      errorMessage = 'Access token is missing. Please log in again.';
      _setLoading(false);
      return;
    }

    try {
      final response = await ApiHandler().getRequest(
        Endpoints.getTestsQuestions(testId),
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      print('AccessToken:$accessToken');


      if (response['status'] == 0) {
        final data = response['data']; // The entire data object
        if (data != null) {
          testData = TestQuestions.fromJson(data); // Map response data to TestQuestions model
          print('Test Data: $testData');
        } else {
          errorMessage = 'No test data available.';
        }
      } else {
        errorMessage = 'Failed to fetch data. Status code: ${response['statusCode']}';
      }

      if (response['status'] == 0) {
        final data = response['data']['questions'];  // Directly access 'questions' field
        if (data != null) {
          _extractTestData(data);  // Extract data into separate variables
        } else {
          errorMessage = 'No test data available.';
        }
      } else {
        errorMessage = 'Failed to fetch data. Status code: ${response['statusCode']}';
      }
    } catch (e) {
      errorMessage = 'An error occurred: $e';
    } finally {
      _setLoading(false);
    }
  }



  Future<String?> _getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }


  void _extractTestData(List<dynamic> data) {
    questionStatements.clear();
    optionsList.clear();
    questionImages.clear();

    for (var question in data) {
      questionStatements.add(question['questionStatement']);
      optionsList.add(List<String>.from(question['options']));  // Create a new list for options
      questionImages.add(question['questionImageUrl']);
    }

    notifyListeners();
  }

}
