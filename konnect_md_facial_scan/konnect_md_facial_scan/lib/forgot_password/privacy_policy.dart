import 'package:facial_scan_app/basic_data/back_button.dart';
import 'package:facial_scan_app/basic_data/text_styles.dart';
import 'package:flutter/material.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  @override
  Widget build(BuildContext context) {
    // Screen size for responsiveness
    final double w = MediaQuery.of(context).size.width;
    final double h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: w * 0.05),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: h * 0.02),

                // Back button and title
                Row(
                  children: [
                    BackButtonCircle(),
                    SizedBox(width: w * 0.03),
                    Flexible(
                      child: Text(
                        'Privacy Policy',
                        style: AppTextStyles.t4.copyWith(fontSize: w * 0.05),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: h * 0.03),

                // Paragraph 1
                Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur in mattis ante. Nam ac diam quis dolor lobortis euismod et eget nunc. Curabitur ullamcorper, nibh vel ultricies commodo, libero tortor viverra velit, sed elementum nunc purus sed ante. Donec sit amet bibendum tellus. Integer vehicula est quis mauris euismod, malesuada c',
                  style: AppTextStyles.text.copyWith(
                    height: 1.3,        // responsive line spacing
                    fontSize: w * 0.038, // responsive font size
                  ),
                ),

                SizedBox(height: h * 0.02),

                // Paragraph 2
                Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur in mattis ante. Nam ac diam quis dolor lobortis euismod et eget nunc. Curabitur ullamcorper, nibh vel ultricies commodo, libero tortor viverra velit, sed elementum nunc purus sed ante. Donec sit amet bibendum tellus. Integer vehicula est quis mauris euismod, malesuada c Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur in mattis ante. Nam ac diam quis dolor lobortis euismod et eget nunc. Curabitur ullamcorper, nibh vel ultricies commodo, libero tortor viverra velit, sed elementum nunc purus sed ante. Donec sit amet bibendum tellus. Integer vehicula est quis mauris euismod, malesuada c Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur in mattis ante. Nam ac diam quis dolor lobortis euismod et eget nunc. Curabitur ullamcorper, nibh vel ultricies commodo, libero tortor viverra velit, sed elementum nunc purus sed ante. Donec sit amet bibendum tellus. Integer vehicula est quis mauris euismod, malesuada c',
                  style: AppTextStyles.text.copyWith(
                    height: 1.3,
                    fontSize: w * 0.038,
                  ),
                ),

                SizedBox(height: h * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }
}