import 'package:facial_scan_app/forgot_password/privacy_policy.dart';
import 'package:facial_scan_app/forgot_password/terms_and_conditions.dart';
import 'package:facial_scan_app/services/sign_up_services.dart';
import 'package:flutter/material.dart';

import '../basic_data/app_images.dart';
import '../basic_data/checkbox.dart';
import '../basic_data/text_field.dart';
import '../basic_data/text_styles.dart';
import 'sign_in.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool rememberMe = false;
  bool isLoading = false;

  Future<void> handleSignUp() async {
    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    // Basic Validation
    if (username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      print('SignUp: Validation failed - empty fields');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    if (password != confirmPassword) {
      print('SignUp: Validation failed - passwords do not match');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    if (!rememberMe) {
      print('SignUp: Validation failed - terms not accepted');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please accept Terms & Conditions and Privacy Policy')),
      );
      return;
    }

    setState(() => isLoading = true);
    print('SignUp: Loader started');

    final result = await SignUpServices.signUp(
      username: username,
      email: email,
      password: password,
      passwordConfirmation: confirmPassword,
    );

    setState(() => isLoading = false);
    print('SignUp: Loader stopped');
    print('SignUp: Result => $result');

    if (result['success'] == true) {
      print('SignUp: Registration successful for user => ${result['user']['username']}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Registered successfully!')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Sign_In()),
      );
    } else {
      print('SignUp: Registration failed => ${result['message']}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Registration failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: h,
            child: Column(
              children: [
                SizedBox(height: h * 0.06),

                /// Logo
                Image.asset(
                  AppImages.logo2,
                  height: h * 0.22,
                  width: w * 0.35,
                ),

                SizedBox(height: h * 0.02),

                /// Form
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.06),
                  child: Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Title
                        Text('Sign Up', style: AppTextStyles.t1),

                        SizedBox(height: h * 0.005),

                        Text('Enter Your Account Details!', style: AppTextStyles.t2),

                        SizedBox(height: h * 0.025),

                        /// Username
                        RoundedTextField(
                          hintText: 'Username....',
                          controller: usernameController,
                        ),

                        SizedBox(height: h * 0.015),

                        /// Email
                        EmailTextField(
                          hintText: 'Email Address....',
                          controller: emailController,
                        ),

                        SizedBox(height: h * 0.015),

                        /// Password
                        PasswordTextField(
                          hintText: 'Password....',
                          obscureText: true,
                          controller: passwordController,
                        ),

                        SizedBox(height: h * 0.015),

                        /// Confirm Password
                        PasswordTextField(
                          hintText: 'Confirm Password.....',
                          obscureText: true,
                          controller: confirmPasswordController,
                        ),

                        SizedBox(height: h * 0.015),

                        /// Checkbox Row
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircularCheckbox(
                              initialValue: rememberMe,
                              onChanged: (val) {
                                setState(() {
                                  rememberMe = val;
                                });
                              },
                            ),
                            const SizedBox(width: 0),
                            Expanded(
                              child: ClickableRichText(
                                normalText: 'I agree with all ',
                                secondText: 'Terms & Conditions ',
                                onSecondTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TermsAndConditions(),
                                    ),
                                  );
                                },
                                actionText: 'and ',
                                thirdText: 'Privacy Policy ',
                                onThirdTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PrivacyPolicy(),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: h * 0.03),

                        /// Button with Loader
                        Center(
                          child: isLoading
                              ? const CircularProgressIndicator()
                              : AppButton(
                            text: 'Sign Up',
                            onPressed: handleSignUp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: h * 0.05),

                /// Bottom Login Text
                AuthRichText(
                  normalText: "Already have an account?",
                  actionText: "Sign In",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Sign_In()),
                    );
                  },
                ),

                SizedBox(height: h * 0.04),
              ],
            ),
          ),
        ),
      ),
    );
  }
}