class Endpoints {
  static const String baseUrl = 'http://16.170.246.37:8080/api/v1';

  static const String sendRegOtp = '/user/send-reg-otp';
  static String verifyAccount(String verificationCode) {
    return '/user/register?otp=$verificationCode';
  }

  static const String login = '/login';
  static const String profile = '/profile';

  static String getTestsForLesson(int lessonId) {
    return '/tests/lessons/$lessonId';
  }

  static const String subjects = '/subjects';

  static String getTestsQuestions(int testId) {
    return '/questions/test/$testId';
  }

  static String submitAnswer(int testId,int questionId) {
    return '/questions/$questionId/test/$testId';
  }

  static const String edit = '$baseUrl/profile-update';

  static const String result = '/results';

  static String getResultSubjects(int subjectId) {
    return '/results/subject/$subjectId';
  }

  static String getStudyingProgress(int subjectId) {
    return '/user/study-progress/subjects/$subjectId';
  }

  static String getChapters(int subjectId) {
    return '/chapters/subject/$subjectId';
  }

  static String getLessonByChapters(int chapterId) {
    return '/lesson-by-chapter/chapter/$chapterId';
  }

  static String getlessonDetails(int chapterId,int lessonId) {
    return '/topics/chapter/$chapterId/lessons/$lessonId';
  }

  static String getTopicContents(int topicId,int lessonId,int pageNumber) {
    return '/content/topics/$topicId/lesson/$lessonId?pageNumber=$pageNumber';
  }

  static String getFavourite(int topicId,int pageNumber) {
    return '/liked-topics/toggle/topic/$topicId?pageNumber=$pageNumber';
  }

  static String topicViewed(int topicId) {
    return '/user/study-progress/viewed/topic/$topicId';
  }

  static String topicCompleted(int topicId,int pageNumber) {
    return '/user/study-progress/topic/$topicId/completed?pageNumber=$pageNumber';
  }


  static const String logout = '/logout';



}
