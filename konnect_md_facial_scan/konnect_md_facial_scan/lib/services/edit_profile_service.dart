import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileService {
  static const String _baseUrl = 'https://kmdfacialscan.com/api';

  // ─── Update Profile API ──────────────────────────────────────────
  static Future<Map<String, dynamic>> updateProfile({
    required int    userId,
    required String username,
    File?           profileImageFile,
  }) async {
    try {
      String? base64Image;

      if (profileImageFile != null) {
        final bytes    = await profileImageFile.readAsBytes();
        final ext      = profileImageFile.path.split('.').last.toLowerCase();
        final mimeType = ext == 'png' ? 'image/png' : 'image/jpeg';
        base64Image    = 'data:$mimeType;base64,${base64Encode(bytes)}';
      }

      final Map<String, dynamic> body = {
        'user_id':  userId,
        'username': username,
        if (base64Image != null) 'profile_pic': base64Image,
      };

      final response = await http.post(
        Uri.parse('$_baseUrl/update-profile'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 && data['success'] == true) {
        return {'success': true, 'data': data['data']};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Update failed',
        };
      }
    } catch (e) {
      print('ProfileService: Error updating profile => $e');
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // ─── Save Remote Profile Pic URL ────────────────────────────────
  static Future<void> saveRemoteImageUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('remote_profile_pic_url', url);
    print('ProfileService: Remote image URL saved => $url');
  }

  // ─── Get Remote Profile Pic URL ─────────────────────────────────
  static Future<String?> getRemoteImageUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('remote_profile_pic_url');
  }

  // ─── Clear Remote Image URL (account delete pe) ─────────────────
  static Future<void> clearRemoteImageUrl() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('remote_profile_pic_url');
    print('ProfileService: Remote image URL cleared');
  }
}