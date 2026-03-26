import 'dart:convert';
import 'package:http/http.dart' as http;

class ForgotPasswordService {
  static const String _baseUrl = 'https://kmdfacialscan.com/api';

  // ─── Send OTP to Email ────────────────────────────────────────────
  static Future<ForgotPasswordResult> sendOtp(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/forgot-password'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'email': email}),
      );

      print('ForgotPasswordService: Status => ${response.statusCode}');
      print('ForgotPasswordService: Body   => ${response.body}');

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 && data['success'] == true) {
        return ForgotPasswordResult(
          success: true,
          message: data['message'] ?? 'OTP sent successfully',
          otp: data['otp']?.toString(),
        );
      } else {
        return ForgotPasswordResult(
          success: false,
          message: data['message'] ?? 'Failed to send OTP. Please try again.',
        );
      }
    } catch (e) {
      print('ForgotPasswordService: Error => $e');
      return ForgotPasswordResult(
        success: false,
        message: 'Network error. Please check your connection.',
      );
    }
  }
}

// ─── Result Model ─────────────────────────────────────────────────────────────
class ForgotPasswordResult {
  final bool success;
  final String message;
  final String? otp; // received from server

  ForgotPasswordResult({
    required this.success,
    required this.message,
    this.otp,
  });
}