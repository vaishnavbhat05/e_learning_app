import 'package:e_learning_app/screens/register/register_screen.dart';
import 'package:e_learning_app/screens/verify_account/provider/verify_account_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/model/register.dart';
import '../register/provider/register_provider.dart';

class VerifyAccountScreen extends StatefulWidget {
  final String userName;
  final String email;
  final String password;
  VerifyAccountScreen({
    required this.userName,
    required this.email,
    required this.password,
    super.key,
  });

  @override
  State<VerifyAccountScreen> createState() => _VerifyAccountScreenState();
}


class _VerifyAccountScreenState extends State<VerifyAccountScreen> {
  final List<TextEditingController> _controllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  bool _allFieldsFilled = false;
  String? password;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadPassword();
    for (var controller in _controllers) {
      controller.addListener(_checkAllFieldsFilled);
    }
  }

  void _loadPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      password = prefs.getString('password');
    });
  }
  void _checkAllFieldsFilled() {
    setState(() {
      _allFieldsFilled =
          _controllers.every((controller) => controller.text.isNotEmpty);
    });
    if (kDebugMode) {
      print('All fields filled: $_allFieldsFilled');
    }
  }
  void _resendOtp() async {
    print("Password: $password");
    if (password == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password is missing! Please try again.')),
      );
      return;
    }

    final provider = Provider.of<RegisterProvider>(context, listen: false);

    final registerModel = Register(
      userName: widget.userName,
      email: widget.email,
      password: widget.password,
    );
    try {
      await provider.registerUser(registerModel, context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP resent successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to resend OTP. Please try again.')),
      );
    }
  }


  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.removeListener(_checkAllFieldsFilled);
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onVerifyPressed() async {

    if (_allFieldsFilled) {
      String otp = _controllers.map((controller) => controller.text).join();

      final provider =
          Provider.of<VerifyAccountProvider>(context, listen: false);

      setState(() {
        _isLoading = true;
        _errorMessage = 'Invalid verification code';
      });
      try {
        await provider.verifyAccount(otp, context);
      } catch (e) {
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      if (kDebugMode) {
        print('Please fill all fields before verifying.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white.withOpacity(0.97),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: 300,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/verify_page.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 15,
                    left: 15,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterScreen()));
                      },
                      child: const Text(
                        '',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 60),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(4, (index) {
                        bool isError = _errorMessage != null;
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: isError ? Colors.red : (_focusNodes[index].hasFocus ? Colors.blue : Colors.transparent),
                                width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: TextField(
                              controller: _controllers[index],
                              focusNode: _focusNodes[index],
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              maxLength: 1,
                              cursorWidth: 1,
                              cursorHeight: 32,
                              cursorColor: _focusNodes[index].hasFocus
                                  ? Colors.blue
                                  : Colors.black,
                              style: const TextStyle(
                                fontSize: 32,
                                color: Colors.black,
                              ),
                              decoration: const InputDecoration(
                                counterText: "",
                                border: InputBorder.none,
                              ),
                              onChanged: (value) {
                                if (value.isNotEmpty && index < 3) {
                                  FocusScope.of(context).nextFocus();
                                } else if (value.isEmpty && index > 0) {
                                  FocusScope.of(context).previousFocus();
                                }
                              },
                            ),
                          ),
                        );
                      }),
                    ),
                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0,left: 45),
                        child: Row(
                          children:[
                            const Icon(Icons.error,color: Colors.red,),
                             const SizedBox(width: 5,),
                             Text(
                               _errorMessage!,
                               style: const TextStyle(
                                 color: Colors.redAccent,
                                 fontSize: 20,
                               ),
                             ),
                            ],
                        ),
                      ),
                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 50),
                          child: Text.rich(
                            TextSpan(
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.grey,
                              ),
                              children: [
                                const TextSpan(text: "Didn't receive a code? "),
                                TextSpan(
                                  text: "Resend",
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      _resendOtp();
                                    },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                    Row(
                      children: [
                        const SizedBox(width: 30),
                        const Text(
                          "Verify",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        const SizedBox(width: 165),
                        GestureDetector(
                          onTap: _isLoading ? null : _onVerifyPressed,
                          child: Container(
                            height: 85,
                            width: 85,
                            decoration: BoxDecoration(
                              color: _allFieldsFilled
                                  ? (_isLoading ? Colors.grey : Colors.blue)
                                  : Colors.blue.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Center(
                              child: _isLoading
                                  ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                                  : const Icon(
                                Icons.arrow_right_alt_outlined,
                                size: 60,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
