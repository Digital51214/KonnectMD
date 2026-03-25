import 'package:facial_scan_app/authentication_screen/sign_in.dart';
import 'package:facial_scan_app/basic_data/app_images.dart';
import 'package:facial_scan_app/basic_data/back_button.dart';
import 'package:facial_scan_app/basic_data/text_field.dart';
import 'package:facial_scan_app/basic_data/text_styles.dart';
import 'package:facial_scan_app/forgot_password/verify_screen.dart';
import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  @override
  Widget build(BuildContext context) {
    TextEditingController passwordController = TextEditingController();
    final double w = MediaQuery.of(context).size.width;
    final double h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: h * 0.05),

                // Back button and title
                Row(
                  children: [
                    BackButtonCircle(),
                    SizedBox(width: w * 0.05),
                    Flexible(
                      child: Text(
                        'Change Password',
                        style: AppTextStyles.t4.copyWith(fontSize: w * 0.05),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: h * 0.05),

                // Lock image
                Center(
                  child: Image.asset(
                    AppImages.lock,
                    height: h * 0.22, // responsive height
                    width: h * 0.22,  // responsive width
                    alignment: Alignment.center,
                  ),
                ),

                SizedBox(height: h * 0.03),

                // Input section
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.02, vertical: h * 0.01),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Change Password',
                        style: AppTextStyles.t5.copyWith(fontSize: w * 0.045),
                      ),
                      SizedBox(height: h * 0.015),

                      PasswordTextField(
                        hintText: 'Password',
                        obscureText: true,
                      ),
                      SizedBox(height: h * 0.015),

                      PasswordTextField(
                        hintText: 'Confirm Password',
                        obscureText: true,
                      ),
                      SizedBox(height: h * 0.03),

                      Center(
                        child: AppButton(
                          text: 'Change',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>Sign_In(),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: h * 0.03),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}