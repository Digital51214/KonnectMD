import 'dart:convert';
import 'package:http/http.dart' as http;

class SignInServices {
  static const String _baseUrl = 'https://kmdfacialscan.com/api';

  static Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      print('SignInServices: Sending request to $_baseUrl/signin');
      print('SignInServices: Body => email: $email');

      final response = await http.post(
        Uri.parse('$_baseUrl/signin'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      print('SignInServices: Status Code => ${response.statusCode}');
      print('SignInServices: Response Body => ${response.body}');

      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return responseData;

    } catch (e) {
      print('SignInServices: Error => $e');
      return {
        'success': false,
        'message': 'Something went wrong. Please try again.',
      };
    }
  }
}