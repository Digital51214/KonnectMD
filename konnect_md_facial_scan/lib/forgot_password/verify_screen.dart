import 'package:facial_scan_app/basic_data/app_images.dart';
import 'package:facial_scan_app/basic_data/back_button.dart';
import 'package:facial_scan_app/basic_data/otp_code.dart';
import 'package:facial_scan_app/basic_data/text_field.dart';
import 'package:facial_scan_app/basic_data/text_styles.dart';
import 'package:facial_scan_app/forgot_password/change_passwordxd.dart';
import 'package:flutter/material.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({super.key});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  @override
  Widget build(BuildContext context) {
    // Screen size
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
                    Text('Verify', style: AppTextStyles.t4),
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

                // OTP section
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.02, vertical: h * 0.01),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Enter Code', style: AppTextStyles.t5),
                      SizedBox(height: h * 0.01),
                      Text(
                        'Enter Code sent to your mail',
                        style: AppTextStyles.t6,
                      ),
                      SizedBox(height: h * 0.05),
                      OtpField(), // your 6-digit OTP input
                      SizedBox(height: h * 0.03),
                      Center(
                        child: AppButton(
                          text: 'Verify',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ChangePassword(),
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