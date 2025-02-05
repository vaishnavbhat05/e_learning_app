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
  List<int> questionIds = [];

  final ApiHandler apiHandler = ApiHandler();

  final Map<int, int> _questionAttempts = {};

  Map<int, int> get questionAttempts => _questionAttempts;

  void setSelectedOption(int questionIndex, int option) {
    if (option == 0) {
      _questionAttempts.remove(questionIndex);
    } else {
      _questionAttempts[questionIndex] = option;
    }
    notifyListeners();
  }


  bool isAttempted(int questionIndex) {
    return _questionAttempts.containsKey(questionIndex);
  }

  void clearSelections() {
    _questionAttempts.clear();
  }


  void resetTestData() {
    questionStatements.clear();
    optionsList.clear();
    questionImages.clear();
    questionIds.clear();
    clearSelections();
    isLoading = true;
    errorMessage = '';
    notifyListeners();
  }

  //SUBMIT ANSWER API//

  Future<bool> submitAnswer(int selectedOption, int questionId, int testId) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');

    if (accessToken == null) {
      print('Access token is null, cannot submit test');
      return false;
    }

    print('Request payload: {"selectedOption": $selectedOption}');

    final url = Uri.parse('http://16.170.246.37:8080/api/v1/questions/$questionId/test/$testId?selectedOption=$selectedOption');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'selectedOption': selectedOption,
          'questionId': questionId,
          'testId': testId,
        }),
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        print('Response Data: $responseData');
        return true;
      }
      else if (response.statusCode == 401) {
        print('Access token expired. Attempting to refresh token...');
        bool refreshed = await refreshAccessToken();

        if (refreshed) {
          return submitAnswer(selectedOption, questionId, testId);
        } else {
          print('Token refresh failed. Logging out user.');
          return false;
        }
      }
      else {
        print('Failed to submit answer. Status code: ${response.statusCode}');
        var errorResponse = json.decode(response.body);
        print('Error Response: $errorResponse');
        return false;
      }
    } catch (e, stackTrace) {
      print('Error during POST request: $e');
      print('Stack Trace: $stackTrace');
      return false;
    }
  }

  Future<bool> refreshAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? refreshToken = prefs.getString('refreshToken');

    if (refreshToken == null) {
      print('Refresh token not found. User must log in again.');
      return false;
    }

    try {
      final response = await http.post(
        Uri.parse('http://16.170.246.37:8080/api/v1/refresh-Token'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refreshToken': refreshToken}),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        String newAccessToken = data['accessToken'];

        await prefs.setString('accessToken', newAccessToken);
        print('Access token refreshed successfully.');
        return true;
      } else {
        print('Failed to refresh token. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error refreshing token: $e');
      return false;
    }
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

      print(response);

      if (response['status'] == 0) {
        final data = response['data'];
        if (data != null) {
          testData = TestQuestions.fromJson(data);
          print('Test Data: $testData');
        } else {
          errorMessage = 'No test data available.';
        }
      } else {
        errorMessage = 'Failed to fetch data. Status code: ${response['statusCode']}';
      }

      if (response['status'] == 0) {
        final questionsData = response['data']['questions'];
        if (questionsData != null) {
          _extractTestData(questionsData);
        } else {
          errorMessage = 'No test data available.';
        }
      }
      else {
        errorMessage = 'Failed to fetch data. Status code: ${response['statusCode']}';
      }
    } catch (e) {
      errorMessage = 'An error occurred: $e';
    } finally {
      _setLoading(false);
      notifyListeners();
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


  void _extractTestData(List<dynamic> questions) {
    questionIds = [];
    questionStatements = [];
    optionsList = [];
    questionImages = [];

    for (var question in questions) {
      questionIds.add(question['id']);
      questionStatements.add(question['questionStatement']);
      optionsList.add(List<String>.from(question['options']));
      questionImages.add(question['questionImageUrl'] ?? '');
    }

    notifyListeners();
  }
}
