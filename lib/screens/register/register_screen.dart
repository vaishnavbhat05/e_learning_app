import 'package:e_learning_app/screens/register/provider/register_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/model/register.dart';
import '../../common_widgets/custom_text_field.dart';
import '../../core/utils/validator.dart';
import '../login/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  final _formKey = GlobalKey<FormState>();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isFormValid = false;

  @override
  void dispose() {
    _nameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      _isFormValid = _formKey.currentState?.validate() ?? false;
    });
  }
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Container(
                height: 280,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/register_page.png"),
                    fit: BoxFit.cover,
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
                        const SizedBox(height: 20),
                        CustomTextField(
                          labelText: "Name",
                          hintText: "Enter your name",
                          controller: _nameController,
                          focusNode: _nameFocus,
                          validator: Validator.name.call,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_emailFocus);
                          },
                        ),
                        CustomTextField(
                          labelText: "Mobile / Email",
                          hintText: "Enter your email",
                          controller: _emailController,
                          focusNode: _emailFocus,
                          validator: Validator.email.call,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_passwordFocus);
                          },
                        ),
                        CustomTextField(
                          labelText: "Create Password",
                          hintText: "Enter your password",
                          controller: _passwordController,
                          focusNode: _passwordFocus,
                          obscureText: !_isPasswordVisible,
                          isPasswordField: true,
                          suffixIconAction: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                          validator: Validator.password.call,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_confirmPasswordFocus);
                          },
                        ),
                        CustomTextField(
                          labelText: "Confirm Password",
                          hintText: "Re-enter your password",
                          controller: _confirmPasswordController,
                          focusNode: _confirmPasswordFocus,
                          obscureText: !_isConfirmPasswordVisible,
                          isPasswordField: true,
                          suffixIconAction: () {
                            setState(() {
                              _isConfirmPasswordVisible =
                              !_isConfirmPasswordVisible;
                            });
                          },
                          validator: (value) =>
                              Validator.confirmPassword(value, _passwordController),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            const SizedBox(width: 10),
                            const Text(
                              "Sign up",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: _isFormValid && !_isLoading
                                  ? () async {
                                setState(() {
                                  _isLoading = true;
                                });

                                final registerModel = Register(
                                  userName: _nameController.text,
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                );

                                await context.read<RegisterProvider>().registerUser (registerModel, context);

                                setState(() {
                                  _isLoading = false;
                                });
                              }
                                  : null,
                              child: Container(
                                height: 90,
                                width: 90,
                                decoration: BoxDecoration(
                                  color: _isFormValid ? Colors.blue : Colors.blue.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: _isLoading
                                    ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                                    : const Center(
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
                        const SizedBox(height: 30),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const LoginScreen()),
                            );
                          },
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text.rich(
                                TextSpan(
                                  style: TextStyle(fontSize: 20, color: Colors.grey),
                                  children: [
                                    TextSpan(text: "Already have an account? "),
                                    TextSpan(
                                      text: "Sign in\n",
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline),
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
