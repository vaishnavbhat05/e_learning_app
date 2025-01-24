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
    return '/questions/$testId';
  }

  static const String edit = '/profile-update';

  static const String result = '/results';

  static String getResultSubjects(int subjectId) {
    return '/results/subject/$subjectId';
  }
}
