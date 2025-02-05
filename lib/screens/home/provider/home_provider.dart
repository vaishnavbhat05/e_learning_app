import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/api/api_handler.dart';
import '../../../data/model/subject.dart';

class HomeProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  List<SubjectModel> _searchResults = [];
  List<Map<String, dynamic>> _recommendedChapters = [];
  List<Map<String, dynamic>> _currentlyStudyingChapters = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<SubjectModel> get searchResults => _searchResults;
  List<Map<String, dynamic>> get recommendedChapters => _recommendedChapters;
  List<Map<String, dynamic>> get currentlyStudyingChapters => _currentlyStudyingChapters;


  //SEARCH API//

  Future<void> searchSubjects(String keyword) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    if (keyword.trim().isEmpty) {
      _errorMessage = 'Please enter a keyword to search.';
      _isLoading = false;
      notifyListeners();
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');

    if (accessToken == null) {
      _errorMessage = 'Access token is missing. Please log in again.';
      _isLoading = false;
      notifyListeners();
      return;
    }

    final apiHandler = ApiHandler();
    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    };

    try {
      final responseBody = await apiHandler.getRequest(
        '/search/subjectName?keyword=$keyword',
        headers: headers,
      );

      if (responseBody != null && responseBody['status'] == 0) {
        final subjectsList = responseBody['data'];
        if (subjectsList is List) {
          _searchResults = subjectsList.map((subject) {
            return SubjectModel.fromJson(subject as Map<String, dynamic>);
          }).toList();
        } else {
          _searchResults = [];
        }
      } else {
        _errorMessage = responseBody?['message'] ?? 'No subjects found.';
      }
    } catch (error) {
      _errorMessage = 'Error: ${error.toString()}';
    }

    _isLoading = false;
    notifyListeners();
  }


  //RECOMMENDATION API//

  Future<void> fetchRecommendedChapters() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');

    if (accessToken == null) {
      _errorMessage = 'Access token is missing. Please log in again.';
      _isLoading = false;
      notifyListeners();
      return;
    }

    final apiHandler = ApiHandler();
    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    };

    try {
      final responseBody = await apiHandler.getRequest(
        '/recommendations/chapters',
        headers: headers,
      );

      print('API Response for recommendations: $responseBody');

      if (responseBody != null && responseBody['status'] == 0) {
        if (responseBody.containsKey('data') && responseBody['data'] is List) {
          _recommendedChapters = List<Map<String, dynamic>>.from(responseBody['data']);
        } else {
          _recommendedChapters = [];
          print('No recommended chapters found.');
        }
      } else {
        _errorMessage = responseBody?['message'] ?? 'Failed to load recommendations.';
        print('Error Message: $_errorMessage');
      }
    } catch (error) {
      _errorMessage = 'Error fetching recommendations: ${error.toString()}';
      print('Error fetching recommendations: $error');
    }

    _isLoading = false;
    notifyListeners();
  }


  //CURRENTLY STUDYING API//

  Future<void> fetchCurrentlyStudyingChapters() async {
    _errorMessage = null;
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');

    if (accessToken == null) {
      _errorMessage = 'Access token is missing. Please log in again.';
      notifyListeners();
      return;
    }

    final apiHandler = ApiHandler();
    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    };

    try {
      final responseBody = await apiHandler.getRequest(
        '/user/study-progress',
        headers: headers,
      );

      if (responseBody != null && responseBody['status'] == 0) {
        if (responseBody['data'] != null && responseBody['data'].isNotEmpty) {
          _currentlyStudyingChapters = List<Map<String, dynamic>>.from(responseBody['data']);
        } else {
          _currentlyStudyingChapters = [];
          await fetchRecommendedChapters();
        }
      } else {
        if (responseBody?['message'] == 'User currently studying records not found for the specified subject') {
          _currentlyStudyingChapters = [];
          await fetchRecommendedChapters();
        } else {
          _currentlyStudyingChapters = [];
          _errorMessage = responseBody?['message'] ?? 'Failed to fetch study progress.';
        }
      }
    } catch (error) {
      _errorMessage = 'Error fetching currently studying chapters: ${error.toString()}';
    }

    notifyListeners();
  }

  //RESET STATE

  void resetState() {
    _currentlyStudyingChapters = [];
    _recommendedChapters = [];
    notifyListeners();
  }

  //CLEAR ALL SEARCHES//

  void clearSearchResults() {
    _searchResults = [];
    _errorMessage = null;
    notifyListeners();
  }

}
