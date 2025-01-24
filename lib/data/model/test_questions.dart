import 'dart:convert';

class TestQuestions {
  final String testName;
  final int totalQuestions;
  final List<QuestionModel> questions;

  TestQuestions({
    required this.testName,
    required this.totalQuestions,
    required this.questions,
  });

  // Factory method to create TestQuestions from JSON
  factory TestQuestions.fromJson(Map<String, dynamic> json) {
    return TestQuestions(
      testName: json['testName'],
      totalQuestions: json['totalQuestions'],
      questions: List<QuestionModel>.from(
        json['questions'].map((question) => QuestionModel.fromJson(question)),
      ),
    );
  }
}

class QuestionModel {
  final int id;
  final String questionStatement;
  final List<String> options;
  final String questionImageUrl;

  QuestionModel({
    required this.id,
    required this.questionStatement,
    required this.options,
    required this.questionImageUrl,
  });

  // Factory method to create QuestionModel from JSON
  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'],
      questionStatement: json['questionStatement'],
      options: List<String>.from(json['options']),
      questionImageUrl: json['questionImageUrl'],
    );
  }
}
