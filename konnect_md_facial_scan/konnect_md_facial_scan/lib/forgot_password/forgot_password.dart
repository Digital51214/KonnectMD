import 'package:facial_scan_app/basic_data/app_images.dart';
import 'package:facial_scan_app/basic_data/back_button.dart';
import 'package:facial_scan_app/basic_data/text_field.dart';
import 'package:facial_scan_app/basic_data/text_styles.dart';

import 'package:facial_scan_app/forgot_password/verify_screen.dart';
import 'package:flutter/material.dart';

import '../services/forgot_password_service.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  // ─── Find Account ─────────────────────────────────────────────────
  Future<void> _findAccount() async {
    final email = _emailController.text.trim();

    // Basic validation
    if (email.isEmpty) {
      _showSnackBar('Please enter your email address', isError: true);
      return;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      _showSnackBar('Please enter a valid email address', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    final result = await ForgotPasswordService.sendOtp(email);

    setState(() => _isLoading = false);

    if (result.success && result.otp != null) {
      // Navigate to verify screen passing otp + email
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerifyScreen(
            email: email,
            serverOtp: result.otp!,
          ),
        ),
      );
    } else {
      _showSnackBar(result.message, isError: true);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade600 : const Color(0xFF0088C9),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

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

                // ── Back Button + Title ──
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

                // ── Shield Image ──
                Center(
                  child: Image.asset(
                    AppImages.shield,
                    height: h * 0.22,
                    width: h * 0.22,
                    alignment: Alignment.center,
                  ),
                ),

                SizedBox(height: h * 0.03),

                // ── Input Section ──
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: w * 0.02, vertical: h * 0.01),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Verify Your Identity',
                          style:
                          AppTextStyles.t5.copyWith(fontSize: w * 0.045)),
                      SizedBox(height: h * 0.01),
                      Text(
                        'Enter email to find your account',
                        style: AppTextStyles.t6.copyWith(fontSize: w * 0.038),
                      ),
                      SizedBox(height: h * 0.05),

                      // Email field with controller
                      EmailTextField(
                        hintText: 'Email Address',
                        controller: _emailController,
                      ),

                      SizedBox(height: h * 0.03),

                      Center(
                        child: _isLoading
                            ? const CircularProgressIndicator(
                          color: Color(0xFF0088C9),
                        )
                            : AppButton(
                          text: 'Find Your Account',
                          onPressed: _findAccount,
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