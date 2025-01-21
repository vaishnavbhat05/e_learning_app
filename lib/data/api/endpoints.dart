class Endpoints {
  static const String baseUrl = 'http://16.170.246.37:8080/api/v1';

  static const String sendRegOtp = '/user/send-reg-otp';
  static String verifyAccount(String verificationCode) {
    return '/user/register?otp=$verificationCode';
  }
  static const String login = '/login';
}
