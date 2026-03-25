import 'package:facial_scan_app/Bottom_Navigation_Bar/bottom_nav_screen.dart';
import 'package:facial_scan_app/basic_data/text_field.dart';
import 'package:facial_scan_app/basic_data/text_styles.dart';
import 'package:facial_scan_app/forgot_password/forgot_password.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../basic_data/app_images.dart';
import '../basic_data/checkbox.dart';
import 'sign_up.dart';

class Sign_In extends StatefulWidget {
  const Sign_In({super.key});

  @override
  State<Sign_In> createState() => _Sign_InState();
}

class _Sign_InState extends State<Sign_In> {
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
                Image.asset(AppImages.logo2, height: h * 0.22, width: w * 0.35),

                SizedBox(height: h * 0.02),

                /// Form
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.06),
                  child: Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Title
                        Text('Sign In', style: AppTextStyles.t1),

                        SizedBox(height: h * 0.005),

                        Text(
                          'Welcome Back! Enter Your Account Details',
                          style: AppTextStyles.t2,
                        ),

                        SizedBox(height: h * 0.025),

                        /// Email Field
                        EmailTextField(hintText: 'Email Address...'),

                        SizedBox(height: h * 0.010),

                        /// Password Field
                        PasswordTextField(
                          hintText: 'Password',
                          obscureText: true,
                          controller: passwordController,
                        ),

                        SizedBox(height: h * 0.015),

                        /// Remember + Forgot
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircularCheckbox(
                                  initialValue: rememberMe,
                                  onChanged: (val) {
                                    setState(() {
                                      rememberMe = val;
                                    });
                                  },
                                ),

                                SizedBox(width: w * 0.02),

                                Text(
                                  "Remember Me",
                                  style: GoogleFonts.poppins(
                                    fontSize: w * 0.032,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),

                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ForgotPassword(), // target screen
                                  ),
                                );
                              },
                              child: Text(
                                "Forgot Password?",
                                style: GoogleFonts.poppins(
                                  decoration: TextDecoration.underline,
                                  decorationColor: const Color(0xFF0088C9),
                                  color: const Color(0xFF0088C9),
                                  fontWeight: FontWeight.w600,
                                  fontSize: w * 0.028,
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: h * 0.04),

                        /// Button
                        Center(
                          child: AppButton(
                            text: 'Sign In',
                            onPressed: () {
                              Get.offAll(() => const BottomNavScreen());
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: h * 0.1),

                /// Bottom SignUp
                AuthRichText(
                  normalText: "Don’t have an account?",
                  actionText: "Sign Up",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignUp()),
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
