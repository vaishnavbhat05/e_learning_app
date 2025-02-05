import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

class Validator {
  static final name = MultiValidator([
    RequiredValidator(errorText: "Please enter your name"),
    PatternValidator(r"^[a-zA-Z\s]+$", errorText: "Enter a valid Name"),
  ]);

  static final email = MultiValidator([
    RequiredValidator(errorText: "Please enter your email"),
    PatternValidator(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",errorText: "Enter a valid email address"),
  ]);

  // static final mobile = MultiValidator([
  //   RequiredValidator(errorText: "Please enter your mobile number"),
  //   PatternValidator(r'^[0-9]{10}$', errorText: "Enter a valid 10-digit number"),
  // ]);

  static final password = MultiValidator([
    RequiredValidator(errorText: "Please enter your password"),
    PatternValidator(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&#])[A-Za-z\d@$!%*?&#]{8,}$', errorText: "Enter a valid password"),
  ]);

  static String? confirmPassword(
      String? value, TextEditingController passwordController) {
    if (value == null || value.isEmpty) {
      return "Please confirm your password";
    } else if (value != passwordController.text) {
      return "Passwords do not match";
    }
    return null;
  }
}
