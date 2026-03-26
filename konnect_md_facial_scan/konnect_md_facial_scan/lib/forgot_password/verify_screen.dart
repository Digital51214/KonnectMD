import 'dart:async';

import 'package:facial_scan_app/basic_data/app_images.dart';
import 'package:facial_scan_app/basic_data/back_button.dart';
import 'package:facial_scan_app/basic_data/otp_code.dart';
import 'package:facial_scan_app/basic_data/text_field.dart';
import 'package:facial_scan_app/basic_data/text_styles.dart';
import 'package:facial_scan_app/forgot_password/change_passwordxd.dart';

import 'package:flutter/material.dart';

import '../services/forgot_password_service.dart';

class VerifyScreen extends StatefulWidget {
  final String email;
  final String serverOtp;

  const VerifyScreen({
    super.key,
    required this.email,
    required this.serverOtp,
  });

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  // ─── State ────────────────────────────────────────────────────────
  String _currentOtp = ''; // entered by user from OtpField
  late String _activeServerOtp; // current valid OTP from server
  bool _isOtpExpired = false;
  bool _isVerifying = false;
  bool _isResending = false;

  // ─── Timer (2 minutes = 120s) ─────────────────────────────────────
  static const int _otpDurationSeconds = 120;
  int _secondsRemaining = _otpDurationSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _activeServerOtp = widget.serverOtp;
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // ─── Timer Logic ─────────────────────────────────────────────────
  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _secondsRemaining = _otpDurationSeconds;
      _isOtpExpired = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining <= 1) {
        timer.cancel();
        setState(() {
          _secondsRemaining = 0;
          _isOtpExpired = true;
        });
      } else {
        setState(() => _secondsRemaining--);
      }
    });
  }

  String get _timerText {
    final minutes = _secondsRemaining ~/ 60;
    final seconds = _secondsRemaining % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  // ─── Verify OTP ──────────────────────────────────────────────────
  Future<void> _verifyOtp() async {
    if (_currentOtp.length < 6) {
      _showSnackBar('Please enter the complete 6-digit code', isError: true);
      return;
    }

    if (_isOtpExpired) {
      _showSnackBar('OTP has expired. Please request a new one.', isError: true);
      return;
    }

    setState(() => _isVerifying = true);

    // Small delay for UX feel
    await Future.delayed(const Duration(milliseconds: 400));

    setState(() => _isVerifying = false);

    if (_currentOtp.trim() == _activeServerOtp.trim()) {
      // ✅ Correct — expire OTP so back navigation shows expired state
      _timer?.cancel();
      setState(() {
        _isOtpExpired = true;
        _secondsRemaining = 0;
      });

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChangePassword(
            email: widget.email,
            otp: _activeServerOtp,
          ),
        ),
      );
    } else {
      // ❌ Incorrect
      _showSnackBar('Incorrect OTP. Please check and try again.', isError: true);
    }
  }

  // ─── Resend OTP ──────────────────────────────────────────────────
  Future<void> _resendOtp() async {
    setState(() => _isResending = true);

    final result = await ForgotPasswordService.sendOtp(widget.email);

    setState(() => _isResending = false);

    if (result.success && result.otp != null) {
      // Update active OTP and restart timer
      _activeServerOtp = result.otp!;
      _startTimer();
      _showSnackBar('OTP resent to ${widget.email}');
    } else {
      _showSnackBar(result.message, isError: true);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor:
        isError ? Colors.red.shade600 : const Color(0xFF0088C9),
        behavior: SnackBarBehavior.floating,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                    Text('Verify', style: AppTextStyles.t4),
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

                // ── OTP Section ──
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: w * 0.02, vertical: h * 0.01),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Enter Code', style: AppTextStyles.t5),
                      SizedBox(height: h * 0.01),
                      Text(
                        'Enter code sent to ${widget.email}',
                        style: AppTextStyles.t6,
                      ),

                      SizedBox(height: h * 0.02),

                      // ── Timer ──
                      Center(
                        child: _isOtpExpired
                            ? Text(
                          'OTP Expired',
                          style: AppTextStyles.t6.copyWith(
                            color: Colors.red.shade500,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                            : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.timer_outlined,
                              size: 16,
                              color: Color(0xFF0088C9),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Expires in $_timerText',
                              style: AppTextStyles.t6.copyWith(
                                color: _secondsRemaining <= 30
                                    ? Colors.red.shade500
                                    : const Color(0xFF0088C9),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: h * 0.03),

                      // ── OTP Input Field ──
                      OtpField(
                        onCompleted: (otp) {
                          setState(() => _currentOtp = otp);
                        },
                      ),

                      SizedBox(height: h * 0.03),

                      // ── Verify Button ──
                      Center(
                        child: _isVerifying
                            ? const CircularProgressIndicator(
                          color: Color(0xFF0088C9),
                        )
                            : AppButton(
                          text: 'Verify',
                          onPressed: _verifyOtp,
                        ),
                      ),

                      SizedBox(height: h * 0.025),

                      // ── Resend OTP Button ──
                      Center(
                        child: _isResending
                            ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFF0088C9),
                          ),
                        )
                            : GestureDetector(
                          onTap: _resendOtp,
                          child: RichText(
                            text: TextSpan(
                              text: "Didn't receive the code? ",
                              style: AppTextStyles.t6.copyWith(
                                color: Colors.grey.shade600,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Resend OTP',
                                  style: AppTextStyles.t6.copyWith(
                                    color: const Color(0xFF0088C9),
                                    fontWeight: FontWeight.w700,
                                    decoration: TextDecoration.underline,
                                    decorationColor:
                                    const Color(0xFF0088C9),
                                  ),
                                ),
                              ],
                            ),
                          ),
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