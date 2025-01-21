class VerifyAccount {
  final String userName;
  final String email;
  final String password;
  final String otp;

  VerifyAccount({
    required this.userName,
    required this.email,
    required this.password,
    required this.otp,
  });

  // Convert the model into a map
  Map<String, String> toJson() {
    return {
      'userName': userName,
      'email': email,
      'password': password,
      'otp': otp,
    };
  }
}

