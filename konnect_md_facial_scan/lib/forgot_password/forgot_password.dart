import 'package:facial_scan_app/basic_data/app_images.dart';
import 'package:facial_scan_app/basic_data/back_button.dart';
import 'package:facial_scan_app/basic_data/text_field.dart';
import 'package:facial_scan_app/basic_data/text_styles.dart';
import 'package:facial_scan_app/forgot_password/verify_screen.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
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
                        'Forgot Password',
                        style: AppTextStyles.t4.copyWith(fontSize: w * 0.05),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: h * 0.05),

                // Shield image
                Center(
                  child: Image.asset(
                    AppImages.shield,
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
                      Text('Verify Your Identity',
                          style: AppTextStyles.t5.copyWith(fontSize: w * 0.045)),
                      SizedBox(height: h * 0.01),
                      Text(
                        'Enter email to find your account',
                        style: AppTextStyles.t6.copyWith(fontSize: w * 0.038),
                      ),
                      SizedBox(height: h * 0.05),
                      EmailTextField(hintText: 'Email Address'),
                      SizedBox(height: h * 0.03),
                      Center(
                        child: AppButton(
                          text: 'Find Your Account',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const VerifyScreen(),
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