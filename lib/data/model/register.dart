class Register {
  String userName;
  String email;
  String password;

  Register({
    required this.userName,
    required this.email,
    required this.password,
  });
  Map<String, String> toJson() {
    return {
      'userName': userName,
      'email': email,
      'password': password,
    };
  }
}

