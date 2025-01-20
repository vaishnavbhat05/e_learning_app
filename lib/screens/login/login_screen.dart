import 'package:e_learning_app/screens/main_page.dart';
import '../register/register_screen.dart';
import 'package:flutter/material.dart';
import '../../common_widgets/custom_text_field.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  bool _isFormValid = false;

  bool _isPasswordVisible = false;
  final _formKey = GlobalKey<FormState>();

  void _validateForm() {
    setState(() {
      _isFormValid = _formKey.currentState?.validate() ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 300,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/login_page.png"),
                    fit: BoxFit.cover, // Ensures the image covers the container
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Form(
                  key: _formKey,
                  onChanged: _validateForm,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextField(
                          labelText: "Mobile / Email",
                          hintText: "Enter your email",
                          controller: _emailController,
                          focusNode: _emailFocus,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_passwordFocus);
                          },
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          labelText: "Password",
                          hintText: "Enter your password",
                          controller: _passwordController,
                          focusNode: _passwordFocus,
                          obscureText: !_isPasswordVisible,
                          isPasswordField: true,
                          suffixIconAction:() {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                          onFieldSubmitted: (_) {
                          },
                        ),
                        const SizedBox(height: 50),
                        Row(
                          children: [
                            const SizedBox(width: 10,),
                            const Text(
                                "Sign in",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24),
                              ),

                            const Spacer(),
                            GestureDetector(
                              onTap: _isFormValid
                                  ? () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                    MainPage(),
                                  ),
                                );
                              }
                                  : null,
                              child: Container(
                                height: 90,
                                width: 90,
                                decoration: BoxDecoration(
                                  color: _isFormValid
                                      ? Colors.blue
                                      : Colors.blue.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.arrow_right_alt_outlined,
                                    size: 60,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 60),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Forgot Password",
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 20,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        const SizedBox(height: 50),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterScreen(),
                              ),
                            );
                          },
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text.rich(
                                TextSpan(
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey,
                                  ),
                                  children: [
                                    TextSpan(text: "Don't have an account? "),
                                    TextSpan(
                                      text: "Sign up\n",
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
