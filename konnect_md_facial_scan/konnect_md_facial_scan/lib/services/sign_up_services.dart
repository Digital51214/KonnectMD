import 'dart:convert';
import 'package:http/http.dart' as http;

class SignUpServices {
  static const String _baseUrl = 'https://kmdfacialscan.com/api';

  static Future<Map<String, dynamic>> signUp({
    required String username,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      print('SignUpServices: Sending request to $_baseUrl/signup');
      print('SignUpServices: Body => username: $username, email: $email');

      final response = await http.post(
        Uri.parse('$_baseUrl/signup'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        }),
      );

      print('SignUpServices: Status Code => ${response.statusCode}');
      print('SignUpServices: Response Body => ${response.body}');

      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return responseData;

    } catch (e) {
      print('SignUpServices: Error => $e');
      return {
        'success': false,
        'message': 'Something went wrong. Please try again.',
      };
    }
  }
}