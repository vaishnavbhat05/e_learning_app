import 'package:e_learning_app/data/api/endpoints.dart';
import 'package:e_learning_app/data/model/result_details.dart';
import 'package:flutter/material.dart';

import 'package:e_learning_app/data/api/api_handler.dart';

import 'package:shared_preferences/shared_preferences.dart';

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

        print('Error fetching results or response is null');
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
