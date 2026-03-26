import 'dart:convert';
import 'package:http/http.dart' as http;

class UpdatePasswordService {
  static const String _baseUrl = 'https://kmdfacialscan.com/api';

  static Future<Map<String, dynamic>> changePassword({
    required int    userId,
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    try {
      final Map<String, dynamic> body = {
        'user_id':                   userId,
        'current_password':          currentPassword,
        'new_password':              newPassword,
        'new_password_confirmation': newPasswordConfirmation,
      };

      final response = await http.post(
        Uri.parse('$_baseUrl/change-password'),
        headers: {'Content-Type': 'application/json'},
        body:    jsonEncode(body),
      );

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 && data['success'] == true) {
        return {
          'success': true,
          'message': data['message'] ?? 'Password updated successfully.',
          'user':    data['user'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Password update failed.',
        };
      }
    } catch (e) {
      print('UpdatePasswordService: Error => $e');
      return {'success': false, 'message': 'Network error: $e'};
    }
  }
}