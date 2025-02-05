import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextInputType keyboardType;
  final bool obscureText;
  final TextEditingController controller;
  final FocusNode focusNode;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final VoidCallback? suffixIconAction;
  final bool isPasswordField;

  const CustomTextField({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.controller,
    required this.focusNode,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.validator,
    this.onFieldSubmitted,
    this.suffixIconAction,
    this.isPasswordField = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: keyboardType,
        obscureText: obscureText,
        obscuringCharacter: '*',
        style: const TextStyle(
          fontSize: 18,
        ),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 18,
          ),
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 18,
          ),
          suffixIcon: isPasswordField
              ? IconButton(
            icon: Icon(
              obscureText ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey,
            ),
            onPressed: suffixIconAction,
          )
              : null,
        ),
        validator: validator,
        onFieldSubmitted: onFieldSubmitted,
      ),
    );
  }
}
