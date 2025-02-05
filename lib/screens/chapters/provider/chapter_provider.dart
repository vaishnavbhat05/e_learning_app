import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/api/api_handler.dart';
import '../../../data/model/chapter.dart';
import '../../../data/api/endpoints.dart';
import '../../../data/model/content.dart';
import '../../../data/model/lesson.dart';
import '../../../data/model/liked_topic.dart';
import '../../../data/model/studying_progress.dart';
import '../../../data/model/test.dart';

class ChapterProvider with ChangeNotifier {
  List<Chapter> _chapters = [];
  bool _isLoading = false;
  String? _errorMessage;
  List<Lesson> _lessons = [];
  Lesson? _lessonDetails;
  Lesson? get lessonDetails => _lessonDetails;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Lesson> get lessons => _lessons;
  List<Chapter> get chapters => _chapters;
  List<TestModel> _tests = [];
  List<TestModel> get tests => _tests;

  List<Content> _content = [];
  List<Content> get content => _content;
  int _currentPage = 1;
  int _totalPages = 1;
  String _heading = '';
  int _lessonIndex = 1;
  int get lessonIndex => _lessonIndex;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  String get heading => _heading;

  String? _lessonLevel;
  String? get lessonLevel => _lessonLevel;

  int? _lessonPageStartsFrom;
  int? get lessonPageStartsFrom => _lessonPageStartsFrom;

  List<StudyProgress> _studyProgress = [];

  List<StudyProgress> get studyProgress => _studyProgress;

  List<LikedTopic> _likedTopics = [];

  List<LikedTopic> get likedTopics => _likedTopics;

  final ApiHandler apiHandler = ApiHandler();

  void clearData() {
    chapters.clear();
    lessons.clear();
    likedTopics.clear();
    notifyListeners();
  }
  //CHAPTER API CALL//

  Future<void> fetchChapters(int subjectId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

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
        Endpoints.getChapters(
            subjectId),
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      print(accessToken);

      if (responseBody != null && responseBody['status'] == 0) {
        var chaptersList = responseBody['data']['chapters'];

        if (chaptersList != null && chaptersList is List) {
          _chapters = chaptersList.map((chapter) {
            return Chapter.fromJson(chapter as Map<String, dynamic>);
          }).toList();
        } else {
          _chapters = [];
        }
      } else {
        _errorMessage = responseBody?['message'] ?? 'Failed to load chapters.';
      }
    } catch (error) {
      _errorMessage = 'Error: $error';
    }
    _isLoading = false;
    notifyListeners();
  }

  //LESSON API CALL//

  Future<void> fetchLessonsByChapter(int chapterId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      if (accessToken == null) {
        _errorMessage = 'Access token is missing. Please log in again.';
        _isLoading = false;
        notifyListeners();
        return;
      }

      final response = await apiHandler.getRequest(
        Endpoints.getLessonByChapters(chapterId),
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response != null && response['status'] == 0) {
        var lessonData = response['data'];

        if (lessonData != null && lessonData is List) {
          _lessons = lessonData.map((lesson) {
            return Lesson.fromJson(lesson as Map<String, dynamic>);
          }).toList();
        } else {
          _lessons = [];
        }
      } else {
        _errorMessage = response?['message'] ?? 'Failed to load lessons.';
      }
    } catch (error) {
      _errorMessage = 'Error: $error';
    }

    _isLoading = false;
    notifyListeners();
  }

  //LESSON DETAILS API//

  void clearLessons() {
    _lessons.clear();
    notifyListeners();
  }


  Future<void> fetchLessonDetails(int chapterId, int lessonId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      if (accessToken == null) {
        _errorMessage = 'Access token is missing. Please log in again.';
        _isLoading = false;
        notifyListeners();
        return;
      }

      final response = await apiHandler.getRequest(
        Endpoints.getlessonDetails(chapterId, lessonId),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response != null && response['status'] == 0) {
        var lessonData = response['data'];
        var topics = lessonData['topics'];
          // Find the lesson by its lessonId
          Lesson lesson = _lessons.firstWhere(
            (lesson) => lesson.lessonId == lessonId,
            orElse: () => throw Exception('Lesson not found'),
          );
        for (int i = 0; i < lesson.topics.length; i++) {
          var topic = lesson.topics[i];
          var newTopic = topics.firstWhere(
                (topicData) => topicData["topicId"] == topic.topicId,
            orElse: () => null,
          );

          if (newTopic != null) {
            lesson.topics[i] = Topic(
              topicId: newTopic['topicId'],
              lessonId: newTopic['lessonId'] ?? topic.lessonId,
              heading: newTopic['heading'],
              subHeading: newTopic['subHeading'],
              subjectId: newTopic['subjectId'] ?? topic.subjectId,
              level: newTopic['level'],
              pageStartsFrom: newTopic['pageStartsFrom'],
              completed: newTopic['completed'] ?? topic.completed,
            );
          } else {
            print('No matching topic found for topicId: ${topic.topicId}');
          }
        }


        notifyListeners();

      } else {
        _errorMessage =
            response?['message'] ?? 'Failed to load lesson details.';
      }
    } catch (error) {
      _errorMessage = 'Error: $error';
      print(_errorMessage);
    }

    _isLoading = false;
    notifyListeners();
  }

  //TEST API//

  Future<void> fetchTests(int lessonId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

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
        _errorMessage = responseBody['message'] ??
            'Failed to load tests. Please try again.';
      }
    } catch (error) {
      _errorMessage = 'Error: $error';
    }

    _isLoading = false;
    notifyListeners();
  }

  //CONTENT API//

  void clearContent() {
    _content.clear();
  }

  Future<void> fetchLessonTopics(
      int topicId, int lessonId, int pageNumber) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      if (accessToken == null) {
        _errorMessage = 'Access token is missing. Please log in again.';
        _isLoading = false;
        notifyListeners();
        return;
      }

      final response = await apiHandler.getRequest(
        Endpoints.getTopicContents(topicId, lessonId, pageNumber),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      print(response);
      if (response != null && response['status'] == 0) {
        var data = response['data'];

        if (data != null) {
          var contentData = data['content'] as List<dynamic>;
          _content = contentData.map((contentJson) {
            return Content.fromJson(contentJson as Map<String, dynamic>);
          }).toList();

          _currentPage = data['currentPage'] ?? 1;
          _totalPages = data['totalPages'] ?? 1;
          _lessonIndex = data['lessonIndex'] ?? 1;
          _heading = data['heading'] ?? "topic";
        } else {
          _content = [];
        }
      } else {
        _errorMessage = response?['message'] ?? 'Failed to load lesson topics.';
      }
    } catch (error) {
      _errorMessage = 'Error: $error';
    }

    _isLoading = false;
    notifyListeners();
  }

  //LIKED API//

  Future<void> fetchLikedTopics(int subjectId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');

    if (accessToken == null) {
      _errorMessage = "Access token is missing. Please log in again.";
      _isLoading = false;
      notifyListeners();
      return;
    }
    try {
      final response = await apiHandler.getRequest(
        '/liked-topics/subjects/$subjectId', // Endpoint without base URL
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      print(response); // Check the response body

      if (response['status'] == 0) {
        _likedTopics = (response['data'] as List)
            .map((item) => LikedTopic.fromJson(item))
            .toList();
        _errorMessage = null;
      } else {
        _errorMessage = 'Failed to load data';
      }
    } catch (error) {
      _errorMessage = 'Error: $error';
    }
    _isLoading = false;
    notifyListeners();
  }

  //STUDYING PROGRESS API//

  Future<void> fetchStudyProgress(int subjectId) async {
    _isLoading = true;
    notifyListeners();

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');
      if (accessToken == null) {
        print('Access token is null, cannot fetch study progress');
        _isLoading = false;
        notifyListeners();
        return;
      }

      final response = await apiHandler.getRequest(
        Endpoints.getStudyingProgress(subjectId),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response != null && response['status'] == 0) {
        final data = response['data'];
        _studyProgress = data
            .map<StudyProgress>((item) => StudyProgress.fromJson(item))
            .toList();
      } else {
        print('Failed to fetch study progress: ${response?['message']}');
      }
    } catch (e) {
      print('Error fetching study progress: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //TOPIC VIEWED API//

  Future<void> markTopicAsViewed(int topicId) async {
    _isLoading = true;
    notifyListeners();

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      if (accessToken == null) {
        print('Access token is null, cannot mark topic as viewed');
        _isLoading = false;
        notifyListeners();
        return;
      }

      final response = await apiHandler.postRequest(
        Endpoints.topicViewed(topicId),
        {},
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response != null && response['status'] == 0) {
        print('Topic $topicId marked as viewed successfully.');
      } else {
        print('Failed to mark topic as viewed: ${response?['message']}');
      }
    } catch (e) {
      print('Error marking topic as viewed: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  //TOPIC COMPLETED API//

  // List<int> visitedPages = []; // To track visited pages
  //
  // void markPageAsVisited(int pageNumber) {
  //   if (!visitedPages.contains(pageNumber)) {
  //     visitedPages.add(pageNumber);
  //   }
  //   notifyListeners();
  // }
  //
  // bool isTopicCompleted() {
  //   // Check if all pages from 1 to totalPages have been visited
  //   for (int i = 1; i <= totalPages; i++) {
  //     if (!visitedPages.contains(i)) {
  //       return false; // Not all pages have been visited
  //     }
  //   }
  //   return true; // All pages visited
  // }

  Future<void> markTopicAsCompleted(int topicId,int pageNumber) async {
    _isLoading = true;
    notifyListeners();

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      if (accessToken == null) {
        print('Access token is null, cannot mark topic as completed');
        _isLoading = false;
        notifyListeners();
        return;
      }

      final response = await apiHandler.postRequest(
        Endpoints.topicCompleted(topicId,pageNumber),
        {
          'pageNumber':pageNumber
        },
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response != null && response['status'] == 0) {
        print('Topic $topicId marked as completed successfully.');
      } else {
        print('Failed to mark topic as completed: ${response?['message']}');
      }
    } catch (e) {
      print('Error marking topic as completed: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

