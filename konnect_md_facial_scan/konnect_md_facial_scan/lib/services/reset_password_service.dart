import 'dart:convert';
import 'package:http/http.dart' as http;

class ResetPasswordService {
  static const String _baseUrl = 'https://kmdfacialscan.com/api';

  // ─── Reset Password ───────────────────────────────────────────────
  static Future<ResetPasswordResult> resetPassword({
    required String email,
    required String otp,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/reset-password'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'otp': otp,
          'password': password,
          'password_confirmation': passwordConfirmation,
        }),
      );

      print('ResetPasswordService: Status => ${response.statusCode}');
      print('ResetPasswordService: Body   => ${response.body}');

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 && data['success'] == true) {
        return ResetPasswordResult(
          success: true,
          message: data['message'] ?? 'Password reset successful!',
        );
      } else {
        return ResetPasswordResult(
          success: false,
          message: data['message'] ?? 'Failed to reset password. Please try again.',
        );
      }
    } catch (e) {
      print('ResetPasswordService: Error => $e');
      return ResetPasswordResult(
        success: false,
        message: 'Network error. Please check your connection.',
      );
    }
  }
}

// ─── Result Model ─────────────────────────────────────────────────────────────
class ResetPasswordResult {
  final bool success;
  final String message;

  ResetPasswordResult({
    required this.success,
    required this.message,
  });
}