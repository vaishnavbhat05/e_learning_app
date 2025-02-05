import 'package:e_learning_app/data/api/endpoints.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/model/subject.dart';
import '../../../data/api/api_handler.dart';

class SubjectProvider extends ChangeNotifier {
  List<SubjectModel> _subjects = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<SubjectModel> get subjects => _subjects;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Future<void> fetchSubjects() async {
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
        Endpoints.subjects,
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (responseBody != null && responseBody['status'] == 0) {
        List<dynamic> subjectsList = responseBody['data']['subjects'];
        _subjects = subjectsList.map((subject) => SubjectModel.fromJson(subject)).toList();

        if (_subjects.isNotEmpty) {
        }
      } else {
        _errorMessage = responseBody['message'] ?? 'Failed to load subjects.';
      }
    } catch (error) {
      _errorMessage = 'Error: $error';
    }

    _isLoading = false;
    notifyListeners();
  }
}
