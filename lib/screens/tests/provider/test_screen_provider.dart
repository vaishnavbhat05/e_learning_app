import 'package:e_learning_app/data/model/test_questions.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/api/api_handler.dart';
import '../../../data/api/endpoints.dart';
import '../../../data/model/test_result.dart';

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

  Future<void> submitAnswer(int questionId, int testId, int selectedOption) async {
    isLoading = true;
    notifyListeners();

    // try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      if (accessToken == null) {
        print('Access token is null, cannot submit test');
        isLoading = false;
        notifyListeners();
        return;
      }

      final response = await apiHandler.postRequest(
        '/questions/$questionId/test/$testId',
        {
          'selectedOption': selectedOption,
        },
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      print(response);
      if (response != null && response['status'] == 0) {
        print('Test submitted successfully for question $questionId and test $testId.');
      } else {
        print('Failed to submit test: ${response?['message']}');
      }
    // } catch (e) {
    //   print('Error submitting test: $e');}
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
