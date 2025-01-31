import 'package:e_learning_app/data/api/endpoints.dart';
import 'package:e_learning_app/data/model/result_details.dart';
import 'package:flutter/material.dart';

import 'package:e_learning_app/data/api/api_handler.dart'; // Assuming your ApiHandler is in this location
// Assuming you have a model class for the result data

import 'package:shared_preferences/shared_preferences.dart'; // For token storage

class ResultProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  List<ResultDetails>? _results;

  bool get isLoading => _isLoading;

  List<ResultDetails>? get results => _results;

  final ApiHandler apiHandler = ApiHandler();

  //RESULT DETAILS API//


  Future<void> fetchResults() async {
    _setLoading(true);

    try {

      SharedPreferences prefs = await SharedPreferences.getInstance();

      String? accessToken =
          prefs.getString('accessToken');

      print(accessToken);
      if (accessToken == null) {
        print('Access token is null, cannot fetch results');

        return;
      }

      final response = await apiHandler.getRequest(
        Endpoints.result,

        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );


      if (response != null &&
          response['status'] == 0 &&
          response['data'] != null) {
        _results = List<ResultDetails>.from(
            response['data'].map((item) => ResultDetails.fromJson(item)));

        notifyListeners();
      } else {
        // Handle API error (if any)

        print('Error fetching results or response is null');
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



  // Future<void> fetchResultsSubject(int subjectId) async {
  //   _setLoading(true);
  //
  //   try {
  //     // Get the access token from SharedPreferences (or any storage method)
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     String? accessToken = prefs.getString('accessToken');
  //     if (accessToken == null) {
  //       print('Access token is null, cannot fetch results');
  //       return;
  //     }
  //
  //     // Set the Authorization header with the token
  //     final response = await apiHandler.getRequest(
  //     Endpoints.getResultSubjects(subjectId), // Add the subjectId to the API endpoint
  //       headers: {
  //         'Authorization': 'Bearer $accessToken', // Add Authorization header
  //       },
  //     );
  //
  //     if (response != null && response['status'] == 0) {
  //       if (response['data'] != null && response['data'].isNotEmpty) {
  //         _results = List<ResultDetails>.from(
  //           response['data'].map((item) => ResultDetails.fromJson(item)),
  //         );
  //         _errorMessage = null; // Clear error message as data is available
  //       } else {
  //         _results = []; // Empty list if no results
  //         _errorMessage = response['message'] ?? "No results available.";
  //       }
  //     } else {
  //       _errorMessage = response?['message'] ?? "Something went wrong.";
  //       _results = [];
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //   } finally {
  //     _setLoading(false);
  //   }
  // }

}
