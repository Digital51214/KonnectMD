import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../authentication_screen/sign_in.dart';

class SessionManager {
  // ─── Keys ────────────────────────────────────────────────────────
  static const String _keyUser         = 'user_data';
  static const String _keyTokenExpiry  = 'token_expiry';
  static const String _keyIsLoggedIn   = 'is_logged_in';
  static const String _keyProfileImage = 'persistent_profile_image'; // ✅ persistent image key

  // ─── Save Session ────────────────────────────────────────────────
  static Future<void> saveSession({
    required Map<String, dynamic> user,
    int expiryInDays = 7,
  }) async {
    try {
      final prefs      = await SharedPreferences.getInstance();
      final expiryDate = DateTime.now().add(Duration(days: expiryInDays));

      await prefs.setString(_keyUser,        jsonEncode(user));
      await prefs.setString(_keyTokenExpiry, expiryDate.toIso8601String());
      await prefs.setBool(_keyIsLoggedIn,    true);

      print('SessionManager: Session saved successfully');
      print('SessionManager: User       => ${jsonEncode(user)}');
      print('SessionManager: Expires at => ${expiryDate.toIso8601String()}');
    } catch (e) {
      print('SessionManager: Error saving session => $e');
    }
  }

  // ─── Get Saved User ──────────────────────────────────────────────
  static Future<Map<String, dynamic>?> getUser() async {
    try {
      final prefs   = await SharedPreferences.getInstance();
      final userStr = prefs.getString(_keyUser);
      if (userStr == null) return null;
      final user = jsonDecode(userStr) as Map<String, dynamic>;
      print('SessionManager: getUser => $user');
      return user;
    } catch (e) {
      print('SessionManager: Error getting user => $e');
      return null;
    }
  }

  // ─── Save Profile Image Persistently ────────────────────────────
  // ✅ Logout ke baad bhi nahi hatega — sirf account delete pe hatega
  static Future<void> saveProfileImage(String localPath) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyProfileImage, localPath);
      print('SessionManager: Profile image saved persistently => $localPath');
    } catch (e) {
      print('SessionManager: Error saving profile image => $e');
    }
  }

  // ─── Get Persistent Profile Image ───────────────────────────────
  static Future<String?> getProfileImage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final path  = prefs.getString(_keyProfileImage);
      print('SessionManager: getProfileImage => $path');
      return path;
    } catch (e) {
      print('SessionManager: Error getting profile image => $e');
      return null;
    }
  }

  // ─── Delete Profile Image (sirf account delete pe call karo) ────
  static Future<void> deleteProfileImage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyProfileImage);
      print('SessionManager: Profile image deleted permanently');
    } catch (e) {
      print('SessionManager: Error deleting profile image => $e');
    }
  }

  // ─── Check Session Valid ─────────────────────────────────────────
  static Future<bool> isSessionValid() async {
    try {
      final prefs      = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool(_keyIsLoggedIn) ?? false;
      final expiryStr  = prefs.getString(_keyTokenExpiry);

      if (!isLoggedIn || expiryStr == null) {
        print('SessionManager: Session invalid — not logged in or missing expiry');
        return false;
      }

      final expiryDate = DateTime.parse(expiryStr);
      final isExpired  = DateTime.now().isAfter(expiryDate);

      if (isExpired) {
        print('SessionManager: Session expired — clearing');
        await clearSession();
        return false;
      }

      print('SessionManager: Session valid — expires at $expiryStr');
      return true;
    } catch (e) {
      print('SessionManager: Error checking session => $e');
      return false;
    }
  }

  // ─── Clear Session (logout) ──────────────────────────────────────
  // ✅ Profile image intentionally nahi hata rahe — logout ke baad bhi rahegi
  static Future<void> clearSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyUser);
      await prefs.remove(_keyTokenExpiry);
      await prefs.setBool(_keyIsLoggedIn, false);
      print('SessionManager: Session cleared — profile image preserved');
    } catch (e) {
      print('SessionManager: Error clearing session => $e');
    }
  }

  // ─── Logout & Redirect ───────────────────────────────────────────
  // ✅ Image nahi hategi sirf session clear hoga
  static Future<void> logoutAndRedirect() async {
    try {
      print('SessionManager: Clearing session...');
      await clearSession();
      print('SessionManager: Session cleared — navigating to Sign In');

      Get.offAll(() => const Sign_In());

      print('SessionManager: Navigated to Sign In successfully');
    } catch (e) {
      print('SessionManager: Error during logout => $e');
    }
  }
}