import 'package:facial_scan_app/forgot_password/privacy_policy.dart';
import 'package:facial_scan_app/forgot_password/terms_and_conditions.dart';
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
  TextEditingController passwordController = TextEditingController();
  bool rememberMe = false;

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
                  padding: EdgeInsets.symmetric(
                    horizontal: w * 0.06,
                  ),
                  child: Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        /// Title
                        Text(
                          'Sign Up',
                          style: AppTextStyles.t1,
                        ),

                        SizedBox(height: h * 0.005),

                        Text(
                          'Enter Your Account Details!',
                          style: AppTextStyles.t2,
                        ),

                        SizedBox(height: h * 0.025),

                        /// Username
                        RoundedTextField(
                          hintText: 'Username....',
                        ),

                        SizedBox(height: h * 0.015),

                        /// Email
                        EmailTextField(
                          hintText: 'Email Address....',
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
                          controller: passwordController,
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

                            SizedBox(width: 0),

                            Expanded(
                              child: ClickableRichText(
                                normalText: 'I agree with all ',
                                secondText: 'Terms & Conditions ',onSecondTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TermsAndConditions(),
                                  ),
                                );
                              },
                                actionText: 'and ',
                                thirdText: 'Privacy Policy ',onThirdTap: (){
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

                        /// Button
                        Center(
                          child: AppButton(
                            text: 'Sign Up',
                            onPressed: () {},
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
                      MaterialPageRoute(
                        builder: (context) => const Sign_In(),
                      ),
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